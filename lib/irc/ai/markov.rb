require 'json'

module IRC
  module AI
    class Markov
      attr_accessor :stop_words
      attr_reader :store

      CORPUS_FILE = File.dirname(__FILE__) + '/txt/_corpus'
      STOP_WORDS_FILE = File.dirname(__FILE__) + '/txt/_stop_words'

      def initialize
        @store = Hash.new do |store, key|
          store[key] = Hash.new do |key, word|
            key[word] = 0
          end
        end

        @stop_words = IO.read(STOP_WORDS_FILE).split("\n")
      end

      def save_corpus
        File.open(CORPUS_FILE, 'w') do |file|
          file.puts(store.to_json)
        end
      end

      def load_corpus
        if File.exists?(CORPUS_FILE)
          corpus = IO.read(CORPUS_FILE)
          if corpus && !corpus.empty?
            backup_store = JSON.parse(corpus)
            backup_store.each do |key, tokens|
              tokens.each do |word, meta|
                store[key][word] = meta
              end
            end
          end
        end
      end

      def learn(file_path)
        corpus = IO.read(file_path)
        write(corpus)
      end

      def write(text)
        sentences = text.split(/\.|\!|\?/)
        sentences.each do |sentence|
          words = sentence.downcase.gsub(/[^a-z0-9\-\s\']/, '').split

          if words.size > 2
            first = words.shift
            second = words.shift

            until words.empty?
              key = [first, second].join(' ')
              third = words.shift
              if stop_words.include?(third)
                store[key][third] = 0
              else
                store[key][third] += 1
              end
              first = second
              second = third
            end
          end
        end
      end

      def read(text)
        words = text.downcase.gsub(/[^a-z0-9\-\s\']/, '').split
        words.reject! { |token| stop_words.include?(token) }
        sentences = []

        if words.size > 1
          first = words.shift

          until words.empty?
            second = words.shift
            sentence = generate(first, second).join(' ')
            sentences << format(sentence)
            first = second
          end
        end

        if sentences.empty?
          return confused_phrases.sample
        else
          return sentences.sample
        end
      end

      def generate(first, second)
        words = [first, second]
        key = [first, second].join(' ')
        tokens = store[key]

        until words.size > 30 || tokens.empty?
          first = second
          second = frequent_tokens(tokens).sample

          if words.include?(second)
            tokens.delete(second)
          else
            words << second
            key = [first, second].join(' ')
            tokens = store[key]
          end
        end

        return words
      end

      def frequent_tokens(tokens)
        max = tokens.collect(&:last).max
        tokens.group_by(&:last)[max].collect(&:first)
      end

      private

      def confused_phrases
        [
          "I beg your pardon?",
          "Excuse me?",
          "What did you call me?",
          "What did you say to me?"
        ]
      end

      def format(sentence)
        sentence[0].capitalize + sentence[1..-1] + '.'
      end
    end
  end
end
