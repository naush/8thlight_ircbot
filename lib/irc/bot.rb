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
      elsif input =~ direct_message_regex("save$")
        @ai.save_corpus
        reply(["Saved."])
      elsif matching_feature(input)
        execute_matching_feature(input)
      elsif input =~ direct_message_regex("(.*)$")
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
        input =~ direct_message_regex("#{feature.keyword_expression}")
        reply(feature.generate_reply($1))
      end
    end

    def matching_feature(input)
      @features.find do |feature|
        (input =~ direct_message_regex("#{feature.keyword_expression}"))
      end
    end

    def reboot?(input)
      input =~ direct_message_regex("reboot$")
    end

    def respond_to_ping(address)
      @client.pong(address)
    end

    def direct_message_regex(user_input)
      Regexp.new(direct_message_regex_prefix + user_input)
    end

    def direct_message_regex_prefix
      "^.*PRIVMSG ##{@client.channel} :#{@client.nick}: "
    end

    def reply(messages)
      messages.each { |message| @client.message message }
    end
  end
end
