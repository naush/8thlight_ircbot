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
        feature = @features.find do |feature|
          input =~ Regexp.new(feature.keyword_expression)
        end
        if feature
          input =~ Regexp.new(feature.keyword_expression)
          reply(feature.generate_reply($1))
        end
      end
    end

    private

    def reply(messages)
      messages.each { |message| @client.message message }
    end
  end
end
