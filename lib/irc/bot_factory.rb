require_relative 'ai/markov'
require_relative 'bot'
require_relative 'bot_features/default'
require_relative 'bot_features/show_me'
require_relative 'bot_features/weather'
require_relative 'bot_features/book_reader'
require_relative 'bot_features/meaning_of_life'

module IRC
  class BotFactory
    def self.assemble_bot(client)
      ai = IRC::AI::Markov.new
      bot = IRC::Bot.new(client, ai)

      bot.install_feature(IRC::BotFeatures::ShowMe.new)
      bot.install_feature(IRC::BotFeatures::BookReader.new(ai))
      bot.install_feature(IRC::BotFeatures::Weather.new)
      bot.install_feature(IRC::BotFeatures::MeaningOfLife.new)
      bot.install_feature(IRC::BotFeatures::Default.new)

      bot
    end
  end
end
