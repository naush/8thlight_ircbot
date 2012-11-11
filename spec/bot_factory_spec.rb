require 'spec_helper'
require_relative '../lib/irc/bot_factory'
require_relative '../lib/irc/bot'
require_relative '../lib/irc/client'

describe IRC::BotFactory do
  it 'builds a bot' do
    client = IRC::Client.new('irc.8thlight.com', '1234', 'q')
    IRC::BotFactory.assemble_bot(client).should be_a IRC::Bot
  end
end
