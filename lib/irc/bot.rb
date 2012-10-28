require_relative 'api/google_image'
require_relative 'api/wunderground'
require_relative 'ai/markov'

module IRC
  class Bot
    def initialize(client)
      @client = client
      @ai = IRC::AI::Markov.new
    end

    def respond(input)
      puts "> #{input}"

      case input.strip
      when /^.*PING :(.+)$/i
        @client.pong($1)
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: show me (.*)$/i
        show_me($1)
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: weather for (.*)$/i
        weather_for($1)
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: reboot$/i
        raise Exception
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: what is the meaning of life(\?)?$/i
        @client.message("42.")
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: (.*)$/i
        @ai.write($1)
        @client.message(@ai.read($1))
      end
    end

    def show_me(search_terms)
      messages = IRC::API::GoogleImage.query(search_terms)
      if messages.empty?
        @client.message("Image not found.")
      else
        @client.message(messages.sample)
      end
    end

    def weather_for(search_terms)
      messages = IRC::API::Wunderground.query(search_terms)
      if messages.empty?
        @client.message("City not found.")
      else
        messages.each do |message|
          @client.message(message)
        end
      end
    end
  end
end
