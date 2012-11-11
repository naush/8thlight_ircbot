module IRC
  module BotFeatures
    class Default
      def keyword_expression
        '.*'
      end

      def generate_reply(input)
        []
      end
    end
  end
end

