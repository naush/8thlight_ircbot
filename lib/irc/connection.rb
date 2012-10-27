require 'json'
require_relative 'bot'

module IRC
  class Connection
    def self.start(client, stdin = $stdin)
      while true
        ready = select([client.socket, stdin])
        next unless ready

        ready.first.each do |io|
          if io == client.socket
            input = client.socket.gets
            return unless input
            IRC::Bot.handle_server_input(client, input)
          else
            input = io.gets
            client.message(input)
          end
        end
      end
    end
  end
end
