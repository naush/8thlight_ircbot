require 'spec_helper'
require_relative '../../lib/irc/bot_features/save'

describe IRC::BotFeatures::Save do
  it 'matches the save command' do
    ai = mock('ai')
    feature = described_class.new(ai, 'q')
    result = ':user!~user@0.0.0.0 PRIVMSG #q :q: save' =~ Regexp.new(feature.keyword_expression)
    result.should == 0
  end

  it 'saves' do
    ai = mock('ai')
    ai.should_receive(:save_corpus)
    feature = described_class.new(ai, 'q')
    feature.generate_reply('save').should == ['Saved.']
  end
end


