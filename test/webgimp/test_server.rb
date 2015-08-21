require "helper"

class TestServer < MiniTest::Test  
  def test_server
    Webgimp::Server.start("127.0.0.1", "18081")
  end
end