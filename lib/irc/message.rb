module IRC
  module Message
    def self.parse(input)
      if input =~ /^.*PING :(.+)$/i
        message_hash(:ping, nil, $1)
      elsif input =~ /^.*PRIVMSG #.* :(.*): (.*)/i
        message_hash(:privmsg, $1, $2)
      elsif input =~ /^.*PRIVMSG #.* (.*)/i
        message_hash(:privmsg, nil, $1)
      else
        message_hash(nil, nil, nil)
      end
    end

    def self.message_hash(type, recipient, content)
      {
        :type => type,
        :recipient => recipient,
        :content => formatted_content(content)
      }
    end

    def self.formatted_content(content)
      content ? content.strip : nil
    end
  end
end
