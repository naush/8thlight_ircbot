require 'ostruct'

module IRC
  module AI
    class Markov
      attr_reader :store
      attr_accessor :corpus

      def initialize
        @store = Hash.new do |store, key|
          store[key] = Hash.new do |key, word|
            meta = OpenStruct.new
            meta.frequency = 0
            meta.visit = false
            key[word] = meta
          end
        end

        @stop_words = ['a', 'an', 'the', 'and', 'but']
      end

      def learn(file_path)
        corpus = IO.read(file_path)
        write(corpus)
      end

      def write(text)
        sentences = text.split(/\.|\!|\?/)
        sentences.each do |sentence|
          words = sentence.gsub(/[^a-zA-Z0-9\-\s\']/, '').split
          key = words.shift.downcase unless words.empty?

          until words.empty?
            word = words.shift

            if @stop_words.include?(word)
              @store[key][word].frequency = 1
            else
              @store[key][word].frequency += 1
            end
            key = word.downcase
          end
        end
      end

      def frequent_tokens(tokens)
        max_frequency = tokens.values.max_by(&:frequency).frequency
        tokens.select do |word, meta|
          meta.frequency == max_frequency && !meta.visit
        end
      end

      def generate(key)
        words = [key]
        metas = []
        tokens = @store[key]

        until words.size > 30 || tokens.empty?
          tokens = frequent_tokens(tokens)
          unless tokens.empty?
            word = tokens.keys.sample
            meta = tokens[word]
            meta.visit = true
            metas << meta
            words << word
            key = word.downcase
            tokens = @store[key]
          end
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
