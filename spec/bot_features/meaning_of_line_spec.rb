require 'spec_helper'
require_relative '../../lib/irc/bot_features/meaning_of_life'

describe IRC::BotFeatures::MeaningOfLife do
  let(:feature) { described_class.new('q') }

  it 'matches the question' do
    result = ':user!~user@0.0.0.0 PRIVMSG #q :q: what is the meaning of life' =~ Regexp.new(feature.keyword_expression)
    result.should == 0

    result = ':user!~user@0.0.0.0 PRIVMSG #q :q: what is the meaning of life?' =~ Regexp.new(feature.keyword_expression)
    result.should == 0
  end

  it 'is 42' do
    feature.generate_reply("blah").should == ['42.']
  end
end
