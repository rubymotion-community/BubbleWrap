# This object is capable of creating query objects
module BubbleWrap; module HTTP; class QueryFactory

  [:get, :post, :put, :delete, :head, :options, :patch].each do |http_verb|

    define_method(http_verb) do |url, options = {}, &block|
      options[:action] = block if block
      options[:autostart] = false
      HTTP::Query.new(url, http_verb, options)
    end

  end

end end end
