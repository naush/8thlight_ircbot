require 'ostruct'

module IRC
  module AI
    class Markov
      attr_reader :store

      def initialize
        @store = Hash.new do |store, key|
          store[key] = Hash.new do |key, word|
            meta = OpenStruct.new
            meta.frequency = 0
            meta.visit = false
            key[word] = meta
          end
        end
      end

      def write(text)
        words = text.gsub(/[^a-zA-Z0-9\-\s]/, '').split
        key = words.shift.downcase unless words.empty?

        until words.empty?
          word = words.shift
          @store[key][word].frequency += 1
          key = word.downcase
        end
      end

      def stop?(tokens, words)
        words.size > 50 || tokens.empty? || tokens.values.all?(&:visit)
      end

      def read(text)
        words = text.gsub(/[^a-zA-Z0-9\-\s]/, '').split
        key = words.pop.downcase unless words.empty?
        words = [key]
        tokens = @store[key]
        metas = []

        until stop?(tokens, words)
          word, meta = tokens.max_by { |word, meta| meta.frequency }
          meta.visit = true
          metas << meta
          words << word
          key = word.downcase
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
