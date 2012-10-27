require 'cgi'

module IRC
  module Bot
    def self.image_search(client, query)
      if client.sleep
        client.action("is in a deep slumber...")
        return
      end

      escaped_query = CGI.escape(query)
      result = `curl "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{escaped_query}&userip=0.0.0.0"`
      hash = JSON.parse(result)
      urls = hash.fetch('responseData', []).fetch('results', [])
      if urls.empty?
        client.message("Image not found.")
      else
        client.message(urls.sample['unescapedUrl'])
      end
    end

    def self.weather_forecast(client, query)
      if client.sleep
        client.action("is in a deep slumber...")
        return
      end

      escaped_query = CGI.escape(query)
      result = `curl http://autocomplete.wunderground.com/aq?query=#{escaped_query}`
      hash = JSON.parse(result)
      if hash['RESULTS'].size > 0
        query = hash['RESULTS'].first['l']
        result = `curl http://api.wunderground.com/api/75f2849f81861d8b/forecast#{query}.json`
        hash = JSON.parse(result)
        hash['forecast']['txt_forecast']['forecastday'].each do |forecast|
          client.message(forecast['title'] + ": " + forecast['fcttext'])
        end
        client.message("For more information, please visit: http://www.wunderground.com#{query}")
      else
        client.message("City not found.")
      end
    end

    def self.handle_server_input(client, input)
      puts "> #{input}"

      case input.strip
      when /^.*PING :(.+)$/i
        client.pong($1)
      when /^.*PRIVMSG ##{client.channel} :#{client.nick}: show me (.*)$/i
        image_search(client, $1)
      when /^.*PRIVMSG ##{client.channel} :#{client.nick}: weather for (.*)$/i
        weather_forecast(client, $1)
      when /^.*PRIVMSG ##{client.channel} :#{client.nick}: reboot$/i
        raise Exception
      when /^.*PRIVMSG ##{client.channel} :#{client.nick}: (die|sleep|stand by)$/i
        client.action("casts a sleep spell on herself.")
        client.sleep = true
      when /^.*PRIVMSG ##{client.channel} :#{client.nick}: wake( up)?$/i
        client.action("is slowly returning to this world...")
        client.sleep = false
      when /^.*PRIVMSG ##{client.channel} :#{client.nick}: what is the meaning of life(\?)?$/i
        client.message("42.")
      end
    end
  end
end
