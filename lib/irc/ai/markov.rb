require 'json'

module IRC
  module AI
    class Markov
      attr_reader :store

      CORPUS_FILE = File.dirname(__FILE__) + '/txt/_corpus'
      STOP_WORDS_FILE = File.dirname(__FILE__) + '/txt/_stop_words'

      def initialize
        @store = Hash.new do |store, key|
          store[key] = Hash.new do |key, word|
            key[word] = {
              :frequency => 0,
              :visit => false
            }
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
        corpus = IO.read(CORPUS_FILE)
        if corpus && !corpus.empty?
          @store.merge!(JSON.parse(corpus))
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
            word = words.shift

            if @stop_words.include?(word)
              @store[key][word][:frequency] = 0
            else
              @store[key][word][:frequency] += 1
            end
            key = word.downcase
          end
        end
      end

      def frequent_tokens(tokens)
        max_frequency = tokens.values.collect { |value| value[:frequency] }.max
        tokens.select do |word, meta|
          meta[:frequency] == max_frequency && !meta[:visit]
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
            meta[:visit] = true
            metas << meta
            words << word
            key = word.downcase
            tokens = @store[key]
          end
        end

        metas.each do |meta|
          meta[:visit] = false
        end

        return words
      end

      def read(text)
        tokens = text.gsub(/[^a-zA-Z0-9\-\s\']/, '').split
        tokens.reject! { |token| @stop_words.include?(token) }
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
