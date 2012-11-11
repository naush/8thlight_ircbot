require 'spec_helper'
require_relative '../../lib/irc/bot_features/conversation'

describe IRC::BotFeatures::Conversation do
  it 'matches the question' do
    ai = mock('ai')
    feature = described_class.new(ai, 'q')
    ':user!~user@0.0.0.0 PRIVMSG #q :q: talk to me' =~ Regexp.new(feature.keyword_expression)
    $1.should == 'talk to me'
  end

  it 'generate reply' do
    ai = mock('ai')
    ai.should_receive(:write).with('foo')
    ai.should_receive(:read).with('foo').and_return('bar')
    feature = described_class.new(ai, 'q')
    feature.generate_reply('foo').should == ['bar']
  end
end

