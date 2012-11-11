module IRC
  module BotFeatures
    class BookReader
      def initialize(ai, nick)
        @ai = ai
        @nick = nick
      end

      def keyword_expression
        "^.*PRIVMSG #.* :#{@nick}: read (.*)$"
      end

      def generate_reply(input)
        book_title = File.dirname(__FILE__) + '/../ai/corpus/' + input.strip.gsub(/\s/, '_').downcase

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
