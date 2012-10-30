require_relative 'api/google_image'
require_relative 'api/wunderground'
require_relative 'ai/markov'

module IRC
  class Bot
    def initialize(client, ai = IRC::AI::Markov.new)
      @client = client
      @ai = ai
    end

    def respond(input)
      puts "> #{input}"

      case input.strip
      when /^.*PING :(.+)$/i
        @client.pong($1)
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: show me (.*)$/i
        show_me($1)
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: read (.*)$/i
        read_book($1)
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: weather for (.*)$/i
        weather_for($1)
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: reboot$/i
        raise Exception
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: what is the meaning of life(\?)?$/i
        @client.message("42.")
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: (.*)$/i
        @client.message(@ai.read($1))
        @ai.write($1)
      when /^.*PRIVMSG ##{@client.channel} :(.*)$/i
        @ai.write($1)
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

    def read_book(title)
      book_title = File.dirname(__FILE__) + '/ai/gutenberg/' + title.gsub(/\s/, '_').downcase + '.txt'

      if File.exists?(book_title)
        @ai.learn(book_title)
        @client.message("I know #{title.capitalize}.")
      else
        @client.message('Book not found.')
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
