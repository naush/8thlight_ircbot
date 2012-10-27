require 'cgi'

module IRC
  module Bot
    def self.image_search(query)
      escaped_query = CGI.escape(query)
      result = `curl "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{escaped_query}&userip=0.0.0.0"`
      hash = JSON.parse(result)
      hash['responseData']['results'].sample['unescapedUrl']
    end

    def self.weather_forecast(client, query)
      escaped_query = CGI.escape(query)
      result = `curl http://autocomplete.wunderground.com/aq?query=#{escaped_query}`
      hash = JSON.parse(result)
      if hash['RESULTS'].size > 0
        query = hash['RESULTS'].first['l']
        result = `curl http://api.wunderground.com/api/75f2849f81861d8b/forecast#{query}.json`
        hash = JSON.parse(result)
        hash['forecast']['txt_forecast']['forecastday'].map do |forecast|
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
      when /^.*PRIVMSG ##{client.channel} :joe: show me (.*)$/i
        client.message(image_search($1))
      when /^.*PRIVMSG ##{client.channel} :joe: weather for (.*)$/i
        weather_forecast(client, $1)
      end
    end
  end
end
