require "json"
require "yaml"
require "fast_stemmer"
require 'fileutils'
require_relative "grammar"

module IRC
  module Bot
    module AI
      class Engine
        attr_accessor :stop_words
        attr_accessor :stem_words
        attr_accessor :persona
        attr_reader :store

        DIALOGUE_FILE = File.dirname(__FILE__) + "/resources/dialogue.json"
        STEM_WORDS_FILE = File.dirname(__FILE__) + "/resources/stem_words.json"

        def new_store
          Hash.new do |store, key|
            store[key] = Hash.new do |key, word|
              key[word] = 0
            end
          end
        end

        def initialize
          @store = { ">" => new_store, "<" => new_store }
          @stop_words = YAML.load_file(File.dirname(__FILE__) + "/resources/stop_words.yml")
          @persona = YAML.load_file(File.dirname(__FILE__) + "/personas/skim.yml")
          @stem_words = {}
        end

        def save
          File.open(DIALOGUE_FILE, "w") do |file|
            file.puts(store.to_json)
          end

          File.open(STEM_WORDS_FILE, "w") do |file|
            file.puts(stem_words.to_json)
          end
        end

        def load
          if File.exists?(DIALOGUE_FILE)
            dialog = IO.read(DIALOGUE_FILE)
            if dialog && !dialog.empty?
              backup_store = JSON.parse(dialog)
              [">", "<"].each do |direction_key|
                backup_store[direction_key].each do |key, tokens|
                  tokens.each do |word, frequency|
                    store[direction_key][key][word] = frequency
                  end
                end
              end
            end
          else
            FileUtils.touch(DIALOGUE_FILE)
          end

          if File.exists?(STEM_WORDS_FILE)
            backup_stem_words = IO.read(STEM_WORDS_FILE)
            if backup_stem_words && !backup_stem_words.empty?
              stem_words = JSON.parse(backup_stem_words)
            end
          else
            FileUtils.touch(STEM_WORDS_FILE)
          end
        end

        def learn(file_path)
          corpus = IO.read(file_path)
          write(corpus)
        end

        def conflate(word)
          stem_word = word.stem
          stem_words[stem_word] ||= [stem_word]
          stem_words[stem_word] << word unless stem_words[stem_word].include?(word)
          stem_words[stem_word]
        end

        def write(text)
          sentences = text.split(/\.|\!|\?/)
          sentences.each do |sentence|
            words = sentence.downcase.gsub(/[^a-z0-9\-\s\"\']/, "").split

            if words.size > 2
              first_word = words.shift
              second_word = words.shift

              until words.empty?
                conflate(first_word)
                conflate(second_word)

                third_word = words.shift
                forward_key = [first_word, second_word].join(" ")
                backward_key = [second_word, third_word].join(" ")
                store[">"][forward_key][third_word] += 1
                store["<"][backward_key][first_word] += 1
                first_word = second_word
                second_word = third_word
              end
            end
          end
        end

        def read(text)
          words = text.downcase.gsub(/[^a-z0-9\-\s\"\']/, "").split
          words = words - @stop_words
          sentences = []

          until words.empty?
            word = words.shift
            conflate(word).each do |word|
              (store[">"].keys + store["<"].keys).each do |key|
                if key.include?(word)
                  forward_sentence = generate(key, ">")
                  backward_sentence = generate(key, "<")
                  sentence = (backward_sentence + forward_sentence).uniq
                  sentences << Grammar.format(sentence.join(' '))
                end
              end
            end
          end

          if sentences.empty?
            return confused_phrases.sample
          else
            return sentences.uniq.sample
          end
        end

        def generate(key, direction)
          if direction == ">"
            first_word, second_word = key.split(" ")
            words = [first_word, second_word]
          else
            second_word, first_word = key.split(" ")
            words = [second_word, first_word]
          end

          tokens = store[direction][key]
          store[direction].delete(key) if store[direction][key].empty?

          until tokens.empty?
            first_word = second_word
            second_word = random_word(tokens)

            if words.include?(second_word)
              tokens.delete(second_word)
            else
              if direction == ">"
                words << second_word
                key = [first_word, second_word].join(" ")
              else
                words.unshift(second_word)
                key = [second_word, first_word].join(" ")
              end
              tokens = store[direction][key]
              store[direction].delete(key) if store[direction][key].empty?
            end
          end

          words
        end

        def change(persona_name)
          @persona = YAML.load_file(File.dirname(__FILE__) + "/personas/#{persona_name}.yml")
        end

        def forget(token)
          ['>', '<'].each do |direction|
            store[direction].each do |key, words|
              if key.include?(token) || words.keys.any? { |key| key.include?(token) }
                store[direction].delete(key)
              end
            end
          end
        end

        private

        def random_word(tokens)
          tokens.group_by(&:last).min_by(&:first).last.collect(&:first).sample
        end

        def confused_phrases
          @persona["confused_phrases"]
        end
      end
    end
  end
end
