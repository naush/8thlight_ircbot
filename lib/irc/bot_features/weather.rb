require_relative '../api/wunderground'

module IRC
  module BotFeatures
    class Weather
      def initialize(nick)
        @nick = nick
      end

      def keyword_expression
        "^.*PRIVMSG #.* :#{@nick}: weather for (.*)$"
      end

      def generate_reply(input)
        messages = IRC::API::Wunderground.query(input)
        if messages.empty?
          ["City not found."]
        else
          messages
        end
      end
    end
  end
end
