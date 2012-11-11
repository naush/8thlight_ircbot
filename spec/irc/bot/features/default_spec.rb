require 'spec_helper'
require 'irc/bot/features/default'

describe IRC::Bot::Features::Default do
  let (:feature) { described_class.new }

  it 'matches everything' do
    result = 'everything' =~ Regexp.new(feature.keyword_expression)
    result.should == 0
  end

  it 'generates nothing' do
    feature.generate_reply('everything').should == []
  end
end
