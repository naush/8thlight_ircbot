require_relative 'ai/engine'
require_relative 'prototype'
require_relative 'features/book_reader'
require_relative 'features/conversation'
require_relative 'features/default'
require_relative 'features/meaning_of_life'
require_relative 'features/ping'
require_relative 'features/persona'
require_relative 'features/reboot'
require_relative 'features/save'
require_relative 'features/show_me'
require_relative 'features/spy'
require_relative 'features/weather'

module IRC
  module Bot
    class Factory
      def self.assemble_bot(client)
        ai = IRC::Bot::AI::Engine.new
        bot = IRC::Bot::Prototype.new(client, ai)
        nick = client.nick

        bot.install_feature(IRC::Bot::Features::Ping.new(client))
        bot.install_feature(IRC::Bot::Features::Persona.new(ai, nick))
        bot.install_feature(IRC::Bot::Features::Reboot.new(nick))
        bot.install_feature(IRC::Bot::Features::MeaningOfLife.new(nick))
        bot.install_feature(IRC::Bot::Features::BookReader.new(ai, nick))
        bot.install_feature(IRC::Bot::Features::ShowMe.new(nick))
        bot.install_feature(IRC::Bot::Features::Weather.new(nick))
        bot.install_feature(IRC::Bot::Features::Save.new(ai, nick))
        bot.install_feature(IRC::Bot::Features::Conversation.new(ai, nick))
        bot.install_feature(IRC::Bot::Features::Spy.new(ai))
        bot.install_feature(IRC::Bot::Features::Default.new)

        bot
      end
    end
  end
end
