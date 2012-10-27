require 'socket'
require 'openssl'

module IRC
  class Client
    attr_reader :server
    attr_reader :port
    attr_reader :nick
    attr_reader :channel
    attr_accessor :socket

    def initialize(server, port, nick)
      @server = server
      @port = port
      @nick = nick
    end

    def connect
      tcp_socket = TCPSocket.new(@server, @port)
      @socket = OpenSSL::SSL::SSLSocket.new(tcp_socket)
      @socket.connect
      @socket.puts("USER Anonymous 8 * :Anonymous\n", 0)
      @socket.puts("NICK #{@nick}\n", 0)
    end

    def join(channel, password = nil)
      @channel = channel

      if password
        @socket.puts("JOIN ##{@channel} #{password}\n", 0)
      else
        @socket.puts("JOIN ##{@channel}\n", 0)
      end
    end

    def send(command)
      puts "< #{command}"
      @socket.puts("#{command}\n", 0)
    end

    def message(text)
      send("PRIVMSG ##{@channel} :#{text}")
    end

    def pong(server_name)
      send("PONG :#{server_name}")
    end
  end
end
