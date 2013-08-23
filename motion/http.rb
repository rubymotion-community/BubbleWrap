module BubbleWrap

  # The HTTP module provides a simple interface to make HTTP requests.
  #
  # TODO: preflight support, easier/better cookie support, better error handling
  module HTTP

    # Make a GET request and process the response asynchronously via a block.
    #
    # @examples
    #  # Simple GET request printing the body
    #   BubbleWrap::HTTP.get("https://api.github.com/users/mattetti") do |response|
    #     p response.body.to_str
    #   end
    #
    #  # GET request with basic auth credentials
    #   BubbleWrap::HTTP.get("https://api.github.com/users/mattetti", {credentials: {username: 'matt', password: 'aimonetti'}}) do |response|
    #     p response.body.to_str # prints the response's body
    #   end
    #

    [:get, :post, :put, :delete, :head, :options, :patch].each do |http_verb|

      define_singleton_method(http_verb) do |url, options = {}, &block|
        options[:action] = block if block
        HTTP::Query.new(url, http_verb, options)
      end

    end

    module_function
    # This object is capable of creating a request using the same methods as
    # `BW::HTTP`, but the query is not started automatically.
    def query
      HTTP::QueryFactory.new
    end

  end
end

class InvalidURLError < StandardError; end
class InvalidFileError < StandardError; end
