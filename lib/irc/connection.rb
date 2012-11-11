require 'json'
require_relative 'bot_factory'
require_relative 'message'

module IRC
  class Connection
    def self.start(client, stdin = $stdin)
      bot = IRC::BotFactory.assemble_bot(client)

      while true
        if ready = select([client.socket])
          socket = ready.first
          input = client.socket.gets
          return unless input

          puts "> #{input}"
          bot.respond(IRC::Message.parse(input))
        end
      end
    end
  end
end
