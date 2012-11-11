require 'json'
require 'irc/bot/factory'

module IRC
  class Connection
    def self.start(client)
      bot = IRC::Bot::Factory.assemble_bot(client)

      while true
        if ready = select([client.socket])
          socket = ready.first
          input = client.socket.gets
          return unless input

          puts "> #{input}"
          bot.respond(input)
        end
      end
    end
  end
end
