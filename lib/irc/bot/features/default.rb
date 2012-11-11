module IRC
  module Bot
    module Features
      class Default
        def keyword_expression
          '^.*$'
        end

        def generate_reply(input)
          []
        end
      end
    end
  end
end
