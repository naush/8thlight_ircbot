require 'json'
require 'yaml'
require 'fast_stemmer'
require_relative 'grammar'

module IRC
  module Bot
    module AI
      class Engine
        attr_accessor :stop_words
        attr_accessor :stem_words
        attr_accessor :persona
        attr_reader :store

        DIALOGUE_FILE = File.dirname(__FILE__) + '/resources/dialogue.json'
        STEM_WORDS_FILE = File.dirname(__FILE__) + '/resources/stem_words.json'

        def initialize
          @store = Hash.new do |store, key|
            store[key] = Hash.new do |key, word|
              key[word] = 0
            end
          end

          @stop_words ||= YAML.load_file(File.dirname(__FILE__) + '/resources/stop_words.yml')
          @persona ||= YAML.load_file(File.dirname(__FILE__) + '/personas/skim.yml')
          @stem_words = Hash.new do |words, stem|
            words[stem] = [stem]
          end
        end

        def save
          File.open(DIALOGUE_FILE, 'w') do |file|
            file.puts(store.to_json)
          end

          File.open(STEM_WORDS_FILE, 'w') do |file|
            file.puts(stem_words.to_json)
          end
        end

        def load
          if File.exists?(DIALOGUE_FILE)
            dialog = IO.read(DIALOGUE_FILE)
            if dialog && !dialog.empty?
              backup_store = JSON.parse(dialog)
              backup_store.each do |key, tokens|
                tokens.each do |word, meta|
                  store[key][word] = meta
                end
              end
            end
          end

          if File.exists?(STEM_WORDS_FILE)
            backup_stem_words = IO.read(STEM_WORDS_FILE)
            if backup_stem_words && !backup_stem_words.empty?
              stem_words = JSON.parse(backup_stem_words)
            end
          end
        end

        def learn(file_path)
          corpus = IO.read(file_path)
          write(corpus)
        end

        def conflate(word)
          stem_word = word.stem
          stem_words[stem_word] << word unless stem_words[stem_word].include?(word)
          stem_words[stem_word]
        end

        def write(text)
          sentences = text.split(/\.|\!|\?/)
          sentences.each do |sentence|
            words = sentence.downcase.gsub(/[^a-z0-9\-\s\']/, '').split

            if words.size > 2
              first_word = words.shift
              second_word = words.shift

              until words.empty?
                conflate(first_word)
                conflate(second_word)

                key = [first_word, second_word].join(' ')
                third = words.shift
                store[key][third] += 1
                first_word = second_word
                second_word = third
              end
            end
          end
        end

        def read(text)
          words = text.downcase.gsub(/[^a-z0-9\-\s\']/, '').split
          words = words - @stop_words

          sentences = []

          until words.empty?
            word = words.shift
            conflate(word).each do |word|
              store.keys.each do |key|
                if key.include?(word)
                  sentence = generate(key).join(' ')
                  sentences << Grammar.format(sentence)
                end
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
          tokens.group_by(&:last).min_by(&:first).last.collect(&:first).sample
        end

        def confused_phrases
          @persona['confused_phrases']
        end
      end
    end
  end
end
