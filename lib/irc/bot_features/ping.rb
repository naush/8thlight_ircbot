module IRC
  module BotFeatures
    class Ping
      def initialize(client)
        @client = client
      end

      def keyword_expression
        "^.*PING :(.+)$"
      end

      def generate_reply(input)
        @client.pong(input)

        []
      end
    end
  end
end



