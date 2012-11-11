module IRC
  class Bot
    attr_accessor :features

    def initialize(client, ai)
      @client = client
      @ai = ai
      @ai.load_corpus
      @features = []
    end

    def install_feature(feature)
      @features << feature
    end

    def respond(input)
      if input =~ /^.*PING :(.+)$/i
        @client.pong($1)
      elsif input =~ /^.*PRIVMSG ##{@client.nick}: reboot$/i
        raise Exception
      else
        @features.each do |feature|
          result = input =~ Regexp.new(feature.keyword_expression)
          if result == 0
            reply(feature.generate_reply($1))
            break
          end
        end
      end
    end

    private

    def reply(messages)
      messages.each { |message| @client.message message }
    end
  end
end
