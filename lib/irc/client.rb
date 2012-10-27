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

    def disconnect
      @socket.close if @socket
    end

    def connect
      tcp_socket = TCPSocket.new(@server, @port)
      @socket = OpenSSL::SSL::SSLSocket.new(tcp_socket)
      @socket.connect
      send("USER Anonymous 8 * :Anonymous")
      send("NICK #{@nick}")
    end

    def join(channel, password = nil)
      @channel = channel

      if password
        @socket.puts("JOIN ##{@channel} #{password}\n")
      else
        @socket.puts("JOIN ##{@channel}\n")
      end
    end

    def send(command)
      puts "< #{command}"
      @socket.puts("#{command}\n")
    end

    def message(text)
      send("PRIVMSG ##{@channel} :#{text}")
    end

    def pong(server_name)
      send("PONG :#{server_name}")
    end

    def action(description)
      message("\u0001ACTION #{description}\u0001")
    end
  end
end
