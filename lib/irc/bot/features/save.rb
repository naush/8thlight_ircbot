module IRC
  module Bot
    module Features
      class Save
        def initialize(ai, nick)
          @ai = ai
          @nick = nick
        end

        def keyword_expression
          "^.*PRIVMSG #.* :#{@nick}: save"
        end

        def generate_reply(input)
          @ai.save

          ["Saved."]
        end
      end
    end
  end
end
