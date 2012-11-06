require 'spec_helper'
require_relative '../../lib/irc/bot_features/weather'

describe IRC::BotFeatures::Weather do
  let(:feature) { described_class.new }

  it 'keyword_expression is "weather for"' do
    feature.keyword_expression.should == 'weather for (.*)$'
  end

  it 'returns a not found message if query returns no results' do
    IRC::API::Wunderground.should_receive(:query).with('chicago').and_return([])
    feature.generate_reply('chicago').should == ["City not found."]
  end

  it 'returns wunderground query if results' do
    IRC::API::Wunderground.should_receive(:query).with('chicago').and_return(["sunny!"])
    feature.generate_reply('chicago').should == ["sunny!"]
  end
end
