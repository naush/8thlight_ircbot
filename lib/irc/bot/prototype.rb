module IRC
  module Bot
    class Prototype
      attr_reader :features

      def initialize(client, ai)
        @client = client
        @ai = ai
        @ai.load
        @features = []
      end

      def install_feature(feature)
        @features << feature
      end

      def respond(input)
        @features.each do |feature|
          result = input =~ Regexp.new(feature.keyword_expression)
          if result == 0
            reply(feature.generate_reply($1))
            break
          end
        end
      end

      private

      def reply(messages)
        messages.each { |message| @client.message message }
      end
    end
  end
end
