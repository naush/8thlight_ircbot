require 'json'
require 'yaml'
require_relative 'grammar'

module IRC
  module Bot
    module AI
      class Engine
        attr_accessor :stop_words
        attr_accessor :persona
        attr_reader :store

        STORE_FILE = File.dirname(__FILE__) + '/corpus/_store'

        def initialize
          @store = Hash.new do |store, key|
            store[key] = Hash.new do |key, word|
              key[word] = 0
            end
          end

          @stop_words ||= YAML.load_file(File.dirname(__FILE__) + '/resources/stop_words.yml')
          @persona ||= YAML.load_file(File.dirname(__FILE__) + '/personas/skim.yml')
        end

        def save_corpus
          File.open(STORE_FILE, 'w') do |file|
            file.puts(store.to_json)
          end
        end

        def load_corpus
          if File.exists?(STORE_FILE)
            corpus = IO.read(STORE_FILE)
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
              first_word = words.shift
              second_word = words.shift

              until words.empty?
                key = [first_word, second_word].join(' ')
                third = words.shift
                if stop_words.include?(third)
                  store[key][third] = 0
                else
                  store[key][third] += 1
                end
                first_word = second_word
                second_word = third
              end
            end
          end
        end

        def read(text)
          words = text.downcase.gsub(/[^a-z0-9\-\s\']/, '').split
          sentences = []

          until words.empty?
            word = words.shift
            store.keys.each do |key|
              if key.include?(word)
                sentence = generate(key).join(' ')
                sentences << Grammar.format(sentence)
              end
            end
          end

          if sentences.empty?
            return confused_phrases.sample
          else
            return sentences.sample
          end
        end

        def generate(key)
          first_word, second_word = key.split(' ')
          words = [first_word, second_word]
          tokens = store[key]

          until tokens.empty?
            first_word = second_word
            second_word = random_word(tokens)

            if words.include?(second_word)
              tokens.delete(second_word)
            else
              words << second_word
              key = [first_word, second_word].join(' ')
              tokens = store[key]
            end
          end

          words
        end

        def change(persona_name)
          @persona = YAML.load_file(File.dirname(__FILE__) + "/personas/#{persona_name}.yml")
        end

        private

        def random_word(tokens)
          tokens.group_by(&:last).max_by(&:first).last.collect(&:first).sample
        end

        def confused_phrases
          @persona['confused_phrases']
        end
      end
    end
  end
end