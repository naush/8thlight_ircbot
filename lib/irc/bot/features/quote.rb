module IRC
  module Bot
    module Features
      class Quote
        def initialize(nick)
          @nick = nick
        end

        def keyword_expression
          "^.*PRIVMSG #.* :#{@nick}: quote(.*)$"
        end

        def generate_reply(input)
          search_terms = input.strip
          messages = IRC::Bot::API::Quote.query(search_terms)
          if messages.empty?
            ['Quote not found.']
          else
            []
          end
        end
      end
    end
  end
end

