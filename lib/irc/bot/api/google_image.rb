require 'cgi'

module IRC
  module Bot
    module API
      module GoogleImage
        def self.query(search_terms)
          result = `curl "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{CGI.escape(search_terms)}&userip=0.0.0.0"`
          hash = JSON.parse(result)
          hash.fetch('responseData', []).fetch('results', []).collect do |result|
            result['unescapedUrl']
          end
        end
      end
    end
  end
end
