# Response class wrapping the results of a Query's response
module BubbleWrap; module HTTP; class Response
  attr_reader :body
  attr_reader :headers
  attr_accessor :status_code, :status_description, :error_message
  attr_reader :url
  attr_reader :original_url

  def initialize(values={})
    self.update(values)
  end

  def update(values)
    values.each do |k,v|
      self.instance_variable_set("@#{k}", v)
    end
    update_status_description
  end

  def ok?
    status_code.to_s =~ /2\d\d/ ? true : false
  end

  def to_s
    "#<#{self.class}:#{self.object_id} - url: #{self.url}, body: #{self.body}, headers: #{self.headers}, status code: #{self.status_code}, error message: #{self.error_message} >"
  end
  alias description to_s

  def update_status_description
    @status_description = status_code.nil? ? nil : NSHTTPURLResponse.localizedStringForStatusCode(status_code)
  end
end; end; end
