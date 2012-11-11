require 'spec_helper'
require 'irc/bot/features/persona'

describe IRC::Bot::Features::Persona do
  it 'matches persona name' do
    ai = mock('ai')
    feature = described_class.new(ai, 'q')
    ':user!~user@0.0.0.0 PRIVMSG #q :q: change skim' =~ Regexp.new(feature.keyword_expression)
    $1.should == 'skim'
  end

  it 'changes persona' do
    ai = mock('ai')
    ai.should_receive(:change).with('skim')
    feature = described_class.new(ai, 'q')
    feature.generate_reply("skim").should == ["I am Skim."]
  end

  it 'changes to unknown persona' do
    ai = mock('ai')
    feature = described_class.new(ai, 'q')
    feature.generate_reply("unknown").should == ["Persona file not found."]
  end
end
