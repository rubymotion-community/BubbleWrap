# Asynchronous and non blocking RSS Parser based on NSXMLParser.
# The parser will progressively parse a feed and yield each item to the provided block.
#
# The parser can also trigger delegate methods, you can define the following delegate method on the receiving object:
# def when_parser_initializes; end
# def when_parser_parses; end
# def when_parser_is_done; end
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
class RSSParser
  include BW::KVO

  attr_accessor :parser, :xml_url, :doc, :debug, :state, :delegate

  def initialize(input, data=false)
    if data
      data_to_parse = input.respond_to?(:to_data) ? input.to_data : input
      @parser = NSXMLParser.alloc.initWithData(data_to_parse)
    else
      url = NSURL.alloc.initWithString(input)
      @parser = NSXMLParser.alloc.initWithContentsOfURL(url)
    end
    observe(self, 'state') do |old_state, new_state|
      meth = "when_parser_#{new_state}"
      if self.delegate && self.delegate.respond_to?(meth)
        self.delegate.send(meth)
      end
    end
    self.state = :initializes
    @parser.shouldProcessNamespaces = true
    @parser.delegate = self
    self
  end

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

  # Starts the parsing and send each parsed item through its block.
  #
  # Usage:
  #   feed.parse do |item|
  #     puts item.link
  #   end
  def parse(&block)
    @block = block
    puts "Parsing #{xml_url}" if debug
    @parser.parse
  end

  # Delegate getting called when parsing starts
  def parserDidStartDocument(parser)
    self.state = :parses
    puts "starting parsing.." if debug
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
    if @current_item && @current_item.respond_to?(@current_element)
      el = @current_item.send(@current_element) 
      el << string if el.respond_to?(:<<)
    end
  end
  
  # method called when an element is done being parsed
  def parser(parser, didEndElement:element, namespaceURI:uri, qualifiedName:name)
    if element == 'item'
      @block.call(@current_item) if @block
    end
  end
  
  # delegate getting called when the parsing is done
  # If a block was set, it will be called on each parsed items
  def parserDidEndDocument(parser)
    self.state = :is_done
    puts "done parsing" if debug
  end

end
