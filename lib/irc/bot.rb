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
      puts "> #{input}"
      input = input.strip

      if input =~ /^.*PING :(.+)$/i
        respond_to_ping($1)
      elsif reboot?(input)
        raise Exception
      elsif input =~ /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: save$/i
        @ai.save_corpus
        @client.message("Saved.")
      elsif matching_feature(input)
        execute_matching_feature(input)
      elsif input =~ /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: (.*)$/i
        reply([@ai.read($1)])
        @ai.write($1)
      elsif input =~ /^.*PRIVMSG ##{@client.channel} :(.*)$/i
        @ai.write($1)
      end
    end

    private

    def execute_matching_feature(input)
      feature = matching_feature(input)
      if feature
        input =~ /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: #{feature.keyword} (.*)$/i
        reply(feature.generate_reply($1))
      end
    end

    def matching_feature(input)
      @features.find do |feature|
        (input =~ /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: #{feature.keyword} (.*)$/i) 
      end
    end

    def reboot?(input)
      input =~ /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: reboot$/i
    end

    def respond_to_ping(address)
      @client.pong(address)
    end

    def reply(messages)
      messages.each { |message| @client.message message }
    end
  end
end
