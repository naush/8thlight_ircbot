require_relative '../api/google_image'

module IRC
  module BotFeatures
    class ShowMe
      def keyword_expression
        "show me (.*)$"
      end

      def generate_reply(input)
        messages = IRC::API::GoogleImage.query(input)
        if messages.empty?
          ["Image not found."]
        else
          [messages.sample]
        end
      end
    end
  end
end
