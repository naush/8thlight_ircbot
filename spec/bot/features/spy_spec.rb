require 'spec_helper'
require 'irc/bot/features/spy'

describe IRC::Bot::Features::Spy do
  it 'matches any private message' do
    ai = mock('ai')
    feature = described_class.new(ai)
    result = ':user!~user@0.0.0.0 PRIVMSG #q :blah blah blah' =~ Regexp.new(feature.keyword_expression)
    result.should == 0
  end

  it 'generate reply' do
    ai = mock('ai')
    ai.should_receive(:write).with('blah')
    feature = described_class.new(ai)
    feature.generate_reply('blah').should == []
  end
end



