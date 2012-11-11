module IRC
  module Bot
    module Features
      class Spy
        def initialize(ai)
          @ai = ai
        end

        def keyword_expression
          "^.*PRIVMSG #.* :(.*)"
        end

        def generate_reply(input)
          @ai.write(input)

          []
        end
      end
    end
  end
end
