require 'ostruct'

module IRC
  module AI
    class Markov
      attr_reader :store

      def initialize
        @store = Hash.new do |store, key|
          store[key] = Hash.new do |key, token|
            meta = OpenStruct.new
            meta.frequency = 0
            meta.visit = false
            key[token] = meta
          end
        end
      end

      def write(text)
        tokens = text.gsub(/[^a-zA-Z0-9\-\s]/, '').split
        first_token = tokens.shift unless tokens.empty?
        second_token = tokens.shift unless tokens.empty?

        until tokens.empty?
          key = [first_token, second_token].join(" ").downcase
          third_token = tokens.shift
          first_token = second_token
          second_token = third_token
          @store[key][third_token].frequency += 1
        end
      end

      def stop?(tokens, words)
        words.size > 50 || tokens.empty? || tokens.values.all?(&:visit)
      end

      def read(text)
        words = text.gsub(/[^a-zA-Z0-9\-\s]/, '').split
        second_word = words.pop unless words.empty?
        first_word = words.pop unless words.empty?
        words = [first_word, second_word].compact
        key = words.join(" ").downcase

        tokens = @store[key]
        metas = []
        until stop?(tokens, words)
          word, meta = tokens.max_by { |word, meta| meta.frequency }
          meta.visit = true
          metas << meta
          words << word
          key = [second_word, word].join(" ").downcase
          second_word = word
          tokens = @store[key]
        end

        metas.each do |meta|
          meta.visit = false
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
