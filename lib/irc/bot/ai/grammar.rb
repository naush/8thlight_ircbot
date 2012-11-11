module IRC
  module Bot
    module AI
      module Grammar
        def self.format(sentence)
          sentence[0].capitalize + sentence[1..-1] + stop(sentence.split.first)
        end

        def self.stop(first_word)
          @question_words ||= YAML.load_file(File.dirname(__FILE__) + '/resources/question_words.yml')
          return '?' if @question_words.include?(first_word)
          return '.'
        end
      end
    end
  end
end
