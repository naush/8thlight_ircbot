module IRC
  module AI
    class Markov
      attr_reader :store

      def initialize
        @store = Hash.new do |store, key|
          store[key] = Hash.new do |key, token|
            key[token] = 0
          end
        end
      end

      def write(text)
        tokens = text.gsub(/[^a-zA-Z0-9\-\s]/, '').split
        first_token = tokens.shift unless tokens.empty?
        second_token = tokens.shift unless tokens.empty?

        until tokens.empty?
          key = [first_token, second_token].join(" ")
          third_token = tokens.shift
          first_token = second_token
          second_token = third_token
          @store[key][third_token] += 1
        end
      end

      def read(text)
        tokens = text.gsub(/[^a-zA-Z0-9\-\s]/, '').split
        second_token = tokens.pop unless tokens.empty?
        first_token = tokens.pop unless tokens.empty?
        words = [first_token, second_token].compact
        key = words.join(" ")
        until @store[key].empty? || words.size > 50
          token = @store[key].max_by(&:last).first
          words << token
          key = [second_token, token].join(" ")
          second_token = token
        end

        if words.size > 2
          return format(words.join(" "))
        else
          return ["I beg your pardon?", "Excuse me?", "What did you call me?"].sample
        end
      end

      def format(sentence)
        sentence[0].capitalize + sentence[1..-1] + '.'
      end
    end
  end
end
