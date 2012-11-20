module IRC
  module Bot
    module Features
      class Forget
        def initialize(ai, nick)
          @ai = ai
          @nick = nick
        end

        def keyword_expression
          "^.*PRIVMSG #.* :#{@nick}: forget (.*)$"
        end

        def generate_reply(input)
          token = input.strip.downcase
          @ai.forget(token)
          ["I have forgotten."]
        end
      end
    end
  end
end

