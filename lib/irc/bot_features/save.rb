module IRC
  module BotFeatures
    class Save
      def initialize(ai, nick)
        @ai = ai
        @nick = nick
      end

      def keyword_expression
        "^.*PRIVMSG #.* :#{@nick}: save"
      end

      def generate_reply(input)
        @ai.save_corpus

        ["Saved."]
      end
    end
  end
end
