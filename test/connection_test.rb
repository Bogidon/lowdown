require "test_helper"

describe Lowdown::Connection do
  server = nil

  before do
    server ||= MockAPNS.new.tap(&:run)
    @connection = Lowdown::Connection.new(server.uri, server.certificate, server.pkey)
  end

  #it "uses the certificate to connect" do
    ## verifies that it *does* fail with the wrong certificate
    #_, other_cert = MockAPNS.certificate_with_uid("com.example.other")
    #connection = Lowdown::Connection.new(server.uri, other_cert)
    #lambda { connection.open }.must_raise(OpenSSL::SSL::SSLError)
  #end

  describe "when making a request" do
    before do
      @connection.open
      @connection.post("/3/device/some-device-token", { "apns-id" => 42 }, "♥") { |r| @response = r }
      @connection.flush

      @request = server.requests.last
    end

    after do
      @connection.close
    end

    it "makes a POST request" do
      @request.headers[":method"].must_equal "POST"
    end

    it "specifies the :path" do
      @request.headers[":path"].must_equal "/3/device/some-device-token"
    end

    it "converts header values to strings" do
      @request.headers["apns-id"].must_equal "42"
    end

    it "specifies the payload size in bytes" do
      @request.headers["content-length"].must_equal "3"
    end

    it "sends the payload" do
      @request.body.must_equal "♥".force_encoding(Encoding::BINARY)
    end

    it "yields the response" do
      @response.status.must_equal 200
      @response.unformatted_id.must_equal "42"
    end
  end
end

