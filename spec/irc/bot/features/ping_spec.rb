require 'spec_helper'
require 'irc/client'
require 'irc/bot/features/ping'

describe IRC::Bot::Features::Ping do
  it 'matches ping' do
    client = IRC::Client.new(:server, :port, :nick)
    feature = described_class.new(client)
    result = 'PING :irc.example.net' =~ Regexp.new(feature.keyword_expression)
    result.should == 0
  end

  it 'pongs' do
    client = IRC::Client.new(:server, :port, :nick)
    client.should_receive(:pong).with("irc.example.net")
    feature = described_class.new(client)
    feature.generate_reply("irc.example.net").should == []
  end
end
