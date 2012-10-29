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
        sentences = text.split(/\.|\!|\?/)
        sentences.each do |sentence|
          words = sentence.gsub(/[^a-zA-Z0-9\-\s\']/, '').split
          key = words.shift.downcase unless words.empty?

          until words.empty?
            word = words.shift
            @store[key][word].frequency += 1
            key = word.downcase
          end
        end
      end

      def stop?(tokens, words)
        words.size > 50 || tokens.empty? || tokens.values.all?(&:visit)
      end

      def generate(key)
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

        return words
      end

      def read(text)
        tokens = text.gsub(/[^a-zA-Z0-9\-\s\']/, '').split
        sentences = tokens.collect do |token|
          key = token.downcase
          words = generate(key)
          if words.size > 1
            sentence = words.join(" ")
            format(sentence)
          end
        end.compact

        if sentences.empty?
          return ["I beg your pardon?", "Excuse me?", "What did you call me?"].sample
        else
          return sentences.sample
        end
      end

      def format(sentence)
        sentence[0].capitalize + sentence[1..-1] + '.'
      end
    end
  end
end
