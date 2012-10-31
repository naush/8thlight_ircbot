require 'json'
require_relative 'bot'

module IRC
  class Connection
    def self.start(client)
      bot = IRC::Bot.new(client)
      while true
        if ready = select([client.socket])
          socket = ready.first
          input = client.socket.gets
          return unless input
          bot.respond(input)
        end
      end
    end
  end
end
