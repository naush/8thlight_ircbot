module IRC
  module BotFeatures
    class MeaningOfLife
      def keyword_expression
        'what is the meaning of life\??$'
      end

      def generate_reply(input)
        ["42."]
      end
    end
  end
end
