require 'cgi'

module IRC
  module Bot
    module API
      module Wunderground
        def self.query(search_terms)
          result = `curl http://autocomplete.wunderground.com/aq?query=#{CGI.escape(search_terms)}`
          hash = JSON.parse(result)
          messages = []

          if hash['RESULTS'].size > 0
            query = hash['RESULTS'].first['l']
            result = `curl http://api.wunderground.com/api/75f2849f81861d8b/forecast#{query}.json`
            hash = JSON.parse(result)
            hash['forecast']['txt_forecast']['forecastday'].each do |forecast|
              messages << forecast['title'] + ": " + forecast['fcttext']
            end
            messages << "For more information, please visit: http://www.wunderground.com#{query}"
          end

          return messages
        end
      end
    end
  end
end
