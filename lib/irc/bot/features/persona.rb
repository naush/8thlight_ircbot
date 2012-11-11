module IRC
  module Bot
    module Features
      class Persona
        def initialize(ai, nick)
          @ai = ai
          @nick = nick
        end

        def keyword_expression
          "^.*PRIVMSG #.* :#{@nick}: change (.*)$"
        end

        def generate_reply(input)
          persona_name = input.strip.downcase

          if File.exists?(File.dirname(__FILE__) + "/../ai/personas/#{persona_name}.yml")
            @ai.change(persona_name)

            ["I am #{persona_name.capitalize}."]
          else
            ["Persona file not found."]
          end
        end
      end
    end
  end
end

