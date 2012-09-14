# Asynchronous and non blocking RSS Parser based on NSXMLParser.
# The parser will progressively parse a feed and yield each item to the provided block.
#
# The parser can also trigger delegate methods, you can define the following delegate method on the receiving object:
# def when_parser_initializes; end
# def when_parser_parses; end
# def when_parser_is_done; end
# def when_parser_errors; end
#
# @see https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Classes/NSXMLParser_Class/Reference/Reference.html
#
# @usage example:
#   feed = RSSParser.new(URL)
#   feed.delegate = self
#   feed.parse do |item|
#     print item.link
#   end
#   def when_parser_is_done
#     App.alert('parsing complete')
#   end
#
module BubbleWrap
  class RSSParser

    attr_accessor :parser, :source, :doc, :debug, :delegate, :parser_error
    attr_reader :state

    # RSSItem is a simple class that holds all of RSS items.
    # Extend this class to display/process the item differently.
    class RSSItem
      attr_accessor :title, :description, :link, :guid, :pubDate, :enclosure

      def initialize
        @title, @description, @link, @pubDate, @guid = '', '', '', '', ''
      end

      def to_hash
        {
          :title        => title,
          :description  => description,
          :link         => link,
          :pubDate      => pubDate,
          :guid         => guid,
          :enclosure    => enclosure
        }
      end
    end

    def initialize(input, data=false)
      if data
        data_to_parse = input.respond_to?(:to_data) ? input.to_data : input
        @source = data_to_parse
      else
        url = input.is_a?(NSURL) ? input : NSURL.alloc.initWithString(input)
        @source = url
      end
      self.state = :initializes
      self
    end

    def state=(new_state)
      @state = new_state
      callback_meth = "when_parser_#{new_state}"
      if self.delegate && self.delegate.respond_to?(callback_meth)
        self.delegate.send(callback_meth)
      end
    end

    # Starts the parsing and send each parsed item through its block.
    #
    # Usage:
    #   feed.parse do |item|
    #     puts item.link
    #   end
    def parse(&block)
      @block = block

      fetch_source_data do |data|
        @parser = NSXMLParser.alloc.initWithData(data)
        @parser.shouldProcessNamespaces = true
        @parser.delegate ||= self
        @parser.parse
      end
    end

    # Delegate getting called when parsing starts
    def parserDidStartDocument(parser)
      puts "starting parsing.." if debug
      self.state = :parses
    end

    # Delegate being called when an element starts being processed
    def parser(parser, didStartElement:element, namespaceURI:uri, qualifiedName:name, attributes:attrs)
      if element == 'item'
        @current_item = RSSItem.new
      elsif element == 'enclosure'
        @current_item.enclosure = attrs
      end
      @current_element = element
    end

    # as the parser finds characters, this method is being called
    def parser(parser, foundCharacters:string)
      if @current_element && @current_item && @current_item.respond_to?(@current_element)
        el = @current_item.send(@current_element)
        el << string if el.respond_to?(:<<)
      end
    end

    # method called when an element is done being parsed
    def parser(parser, didEndElement:element, namespaceURI:uri, qualifiedName:name)
      if element == 'item'
        @block.call(@current_item) if @block
      else
        @current_element = nil
      end
    end

    # method called when the parser encounters an error
    # error can be retrieved with parserError
    def parser(parser, parseErrorOccurred:parse_error)
      puts "parseErrorOccurred" if debug
      @parser_error = parse_error

      self.state = :errors
    end

    # delegate getting called when the parsing is done
    # If a block was set, it will be called on each parsed items
    def parserDidEndDocument(parser)
      puts "done parsing" if debug
      self.state = :is_done
    end

    def parserError
      @parser_error || @parser.parserError
    end

    # TODO: implement
    # parser:validationErrorOccurred:
    # parser:foundCDATA:

    protected

    def fetch_source_data(&blk)
      if @source.is_a?(NSURL)
        HTTP.get(@source.absoluteString) do |response|
          if response.ok?
            blk.call(response.body)
          else
            parser(parser, parseErrorOccurred:"HTTP request failed (#{response})")
          end
        end
      else
        yield @source
      end
    end
  end
end
