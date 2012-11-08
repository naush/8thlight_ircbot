module IRC
  module AI
    module Grammar
      QUESTION_WORDS = [
        'what',
        'when',
        'where',
        'which',
        'who',
        'whom',
        'whose',
        'why',
        'how'
      ]

      def self.format(sentence)
        sentence[0].capitalize + sentence[1..-1] + stop(sentence.split.first)
      end

      def self.stop(first_word)
        return '?' if QUESTION_WORDS.include?(first_word)
        return '.'
      end
    end
  end
end
