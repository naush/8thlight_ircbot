require 'spec_helper'
require 'irc/bot/factory'
require 'irc/bot/prototype'
require 'irc/client'

describe IRC::Bot::Factory do
  it 'builds a bot' do
    client = IRC::Client.new('irc.8thlight.com', '1234', 'q')
    IRC::Bot::Factory.assemble_bot(client).should be_a IRC::Bot::Prototype
  end
end
