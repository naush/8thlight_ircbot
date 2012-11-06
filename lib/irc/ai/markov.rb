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
          file.puts(@store.to_json)
        end
      end

      def load_corpus
        if File.exists?(CORPUS_FILE)
          corpus = IO.read(CORPUS_FILE)
          if corpus && !corpus.empty?
            backup_store = JSON.parse(corpus)
            backup_store.each do |key, tokens|
              tokens.each do |word, meta|
                @store[key][word] = meta
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
          words = sentence.gsub(/[^a-zA-Z0-9\-\s\']/, '').split
          key = words.shift.downcase unless words.empty?

          until words.empty?
            word = words.shift.downcase
            if @stop_words.include?(word)
              @store[key][word] = 0
            else
              @store[key][word] += 1
            end
            key = word
          end
        end
      end

      def generate(key)
        words = [key]
        tokens = @store[key]

        until words.size > 30 || tokens.empty?
          max = tokens.collect(&:last).max
          word = tokens.group_by(&:last)[max].sample.first
          if words.include?(word)
            tokens.delete(word)
          else
            words << word
            tokens = @store[word]
          end
        end

        return words
      end

      def read(text)
        tokens = parse_input_text_into_tokens(text)
        sentences = find_matching_sentences(tokens)
        sentences.empty? ? confused_phrase : sentences.sample
      end

      private

      def parse_input_text_into_tokens(text)
        tokens = text.gsub(/[^a-zA-Z0-9\-\s\']/, '').split
        tokens.reject { |token| @stop_words.include?(token) }
      end

      def find_matching_sentences(tokens)
        tokens.collect do |token|
          key = token.downcase
          words = generate(key)
          if words.size > 1
            sentence = words.join(" ")
            format(sentence)
          end
        end.compact
      end

      def confused_phrase
        ["I beg your pardon?", "Excuse me?", "What did you call me?", "What did you say to me?"].sample
      end

      def format(sentence)
        sentence[0].capitalize + sentence[1..-1] + '.'
      end
    end
  end
end
