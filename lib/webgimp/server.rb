module Webgimp
  class Server
    include Loggable
    
    # Constants
    # XXX - Yes, we will eventually move this to a Configuration class
    WEBGIMP_200_HEADER    = "HTTP/1.1 200 OK\n"
    WEBGIMP_200_HEADER    << "Content-Type: text/html\n"

    WEBGIMP_302_HEADER    =  "HTTP/1.1 302 Found\n"
    WEBGIMP_302_HEADER    << "Server: Foo\n"
    WEBGIMP_302_HEADER    << "Cache-Control: no-store, no-cache, must-revalidate\n"
    WEBGIMP_302_HEADER    << "Content-Type: text/html\n"

                                
    def initialize(host, port, options={})
      @host, @port = host, port
      @path = options[:path] || ""
      @redirect = options[:redirect]
      
      @server = TCPServer.new(host, port)
    end
    
    # Main run loop
    def run()
      logger.info("Initializing Server: #{@host}:#{@port}")
      message = []
      loop do
        @client = @server.accept()
        # Retrieve the client request
        loop do 
          # Append message bits to our array
          message << @client.gets()
          # Stop looping if we receive all the data
          #break if @client.eof?
          break if message.last =~ /^\r\n$/
        end
        
        # Attempt to parse the data 
        request = parse_request(message.join)
        send_response(request)
        @client.close
      end
    end
    
    
    # Reply to the sender
    def send_response(request)
      # Our standard case
      if @path <=> request.path
        response = WEBGIMP_302_HEADER
        logger.info("Redirect: #{response}")
        # Extract the parameters and/or body and append
        #
      else
        response = WEBGIMP_200_HEADER
        logger.info("Okay: #{response}")
      end
      
      @client.puts(response)
    end
    
    # Parse the socket data as an HTTP request
    def parse_request(data)
      request = WEBrick::HTTPRequest.new(WEBrick::Config::HTTP)
      begin
        request.parse(StringIO.new(data))
      rescue WEBrick::HTTPStatus::BadRequest
        logger.info("Non-HTTP data found")
      end
      logger.info("Request Header: #{request.raw_header}")
      logger.info("Request Body: #{request.body}")
      request
    end
    
    def self.start(server, port)
      self.new(server, port).run()
    end
    
  end
end