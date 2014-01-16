
class FakeSender
  attr_reader :challenge, :credential, :was_cancelled, :continue_without_credential
  def cancelAuthenticationChallenge(challenge)
    @was_cancelled = true
  end
  def useCredential(credential, forAuthenticationChallenge:challenge)
    @challenge = challenge
    @credential = credential
  end
  def continueWithoutCredentialForAuthenticationChallenge(challenge)
    @continue_without_credential = true
  end
end

class FakeChallenge
  attr_accessor :previousFailureCount, :failureResponse

  def sender
    @fake_sender ||= FakeSender.new
  end

  def failureResponse
    @failureResponse ||= FakeURLResponse.new(401, { bla: "123" }, 123)
  end
end

class BubbleWrap::HTTP::Query
  def create_connection(request)
    FakeURLConnection.new(request, self)
  end
end

class FakeURLConnection < NSURLConnection
  attr_reader :delegate, :request, :was_started, :was_cancelled
  def initialize(request, delegate)
    @was_started = false
    @request = request
    @delegate = delegate
    self.class.connectionWithRequest(request, delegate:delegate)
  end
  def start
    @was_started = true
    @was_cancelled = false
    super
  end
  def cancel
    @was_cancelled = true
  end
end

class FakeURLResponse < NSHTTPURLResponse
  attr_reader :statusCode, :allHeaderFields, :expectedContentLength
  def initialize(status_code, headers, length)
    @statusCode = status_code
    @allHeaderFields = headers
    @expectedContentLength = length
  end
end
