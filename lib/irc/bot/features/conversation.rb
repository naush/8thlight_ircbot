module IRC
  module Bot
    module Features
      class Conversation
        def initialize(ai, nick)
          @ai = ai
          @nick = nick
        end

        def keyword_expression
          "^.*PRIVMSG #.* :#{@nick}: (.*)$"
        end

        def generate_reply(input)
          @ai.write(input)

          [
            @ai.read(input)
          ]
        end
      end
    end
  end
end

