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
      if input[:type] == :ping
        respond_to_ping(input[:content])
      elsif reboot?(input)
        raise Exception
      elsif matching_feature(input)
        execute_matching_feature(input)
      elsif input[:content] == "save"
        @ai.save_corpus
        reply(["Saved."])
      elsif input[:type] == :privmsg && input[:recipient] == @client.nick
        reply([@ai.read(input[:content])])
        @ai.write(input[:content])
      elsif input[:type] == :privmsg
        @ai.write(input[:content])
      end
    end

    private

    def execute_matching_feature(input)
      feature = matching_feature(input)
      if feature
        input[:content] =~ direct_message_regex("#{feature.keyword_expression}")
        reply(feature.generate_reply($1))
      end
    end

    def matching_feature(input)
      @features.find do |feature|
        (input[:content] =~ direct_message_regex("#{feature.keyword_expression}"))
      end
    end

    def reboot?(input)
      input[:content] == "reboot"
    end

    def respond_to_ping(address)
      @client.pong(address)
    end

    def direct_message_regex(user_input)
      Regexp.new(direct_message_regex_prefix + user_input)
    end

    def direct_message_regex_prefix
      "^"
    end

    def reply(messages)
      messages.each { |message| @client.message message }
    end
  end
end
