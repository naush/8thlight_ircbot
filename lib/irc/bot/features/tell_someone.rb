module IRC
  module Bot
    module Features
      class TellSomeone
        def initialize(nick)
          @nick = nick
        end

        def keyword_expression
          "^.*PRIVMSG #.* :#{@nick}: tell (.*)$"
        end

        def generate_reply(input)
          words = input.split(' ')
          recipient = words.first
          message = words[1..-1].join(' ')

          [
            "#{recipient}: #{message}"
          ]
        end
      end
    end
  end
end
