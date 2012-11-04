require 'spec_helper'
require_relative '../lib/irc/bot_factory'
require_relative '../lib/irc/bot'


describe IRC::BotFactory do
  it 'builds a bot' do
    client = mock("client")
    IRC::BotFactory.assemble_bot(client).should be_a IRC::Bot
  end
end
