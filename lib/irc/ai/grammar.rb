module IRC
  module AI
    module Grammar
      def self.format(sentence)
        sentence[0].capitalize + sentence[1..-1] + stop(sentence.split.first)
      end

      def self.stop(first_word)
        @question_words ||= IO.read(File.dirname(__FILE__) + '/corpus/_question_words')
        return '?' if @question_words.include?(first_word)
        return '.'
      end
    end
  end
end
