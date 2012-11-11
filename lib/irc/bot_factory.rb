require_relative 'ai/markov'
require_relative 'bot'
require_relative 'bot_features/book_reader'
require_relative 'bot_features/conversation'
require_relative 'bot_features/default'
require_relative 'bot_features/meaning_of_life'
require_relative 'bot_features/save'
require_relative 'bot_features/show_me'
require_relative 'bot_features/spy'
require_relative 'bot_features/weather'

module IRC
  class BotFactory
    def self.assemble_bot(client)
      ai = IRC::AI::Markov.new
      bot = IRC::Bot.new(client, ai)
      nick = client.nick

      bot.install_feature(IRC::BotFeatures::MeaningOfLife.new(nick))
      bot.install_feature(IRC::BotFeatures::BookReader.new(ai, nick))
      bot.install_feature(IRC::BotFeatures::ShowMe.new(nick))
      bot.install_feature(IRC::BotFeatures::Weather.new(nick))
      bot.install_feature(IRC::BotFeatures::Save.new(ai, nick))
      bot.install_feature(IRC::BotFeatures::Conversation.new(ai, nick))
      bot.install_feature(IRC::BotFeatures::Spy.new(ai))
      bot.install_feature(IRC::BotFeatures::Default.new)

      bot
    end
  end
end
