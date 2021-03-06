module IRC
  module Bot
    module Features
      class Reboot
        def initialize(nick)
          @nick = nick
        end

        def keyword_expression
          "^.*PRIVMSG #.* :#{@nick}: reboot.*$"
        end

        def generate_reply(input)
          raise Exception
        end
      end
    end
  end
end
