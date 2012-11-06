module IRC
  module BotFeatures
    class BookReader
      def initialize(ai)
        @ai = ai
      end

      def keyword_expression
        'read (.*)$'
      end

      def generate_reply(input)
        book_title = File.dirname(__FILE__) + '/../ai/txt/' + input.gsub(/\s/, '_').downcase

        if File.exists?(book_title)
          @ai.learn(book_title)
          ["I know #{input.capitalize}."]
        else
          ['Book not found.']
        end
      end
    end
  end
end
