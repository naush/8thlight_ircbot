module IRC
  module Bot
    module Features
      class MeaningOfLife
        def initialize(nick)
          @nick = nick
        end

        def keyword_expression
          "^.*PRIVMSG #.* :#{@nick}: what is the meaning of life.*$"
        end

        def generate_reply(input)
          ["42."]
        end
      end
    end
  end
end
