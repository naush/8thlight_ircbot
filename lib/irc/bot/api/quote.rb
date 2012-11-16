require 'json'

module IRC
  module Bot
    module API
      module Quote
        def self.query(search_terms)
          if search_terms.empty?
            result = `curl http://www.iheartquotes.com/api/v1/random?format=json&max_lines=1`
          else
            result = `curl http://www.iheartquotes.com/api/v1/random?format=json&max_lines=1&source=#{search_terms}`
          end

          JSON.create_id = nil
          hash = JSON.parse(result)
          quote = hash['quote']
          quote.split(/\r?\n/)
        end
      end
    end
  end
end
