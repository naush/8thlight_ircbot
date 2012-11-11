require 'spec_helper'
require 'irc/bot/features/weather'

describe IRC::Bot::Features::Weather do
  let(:feature) { described_class.new('q') }

  it 'matches the city' do
    ':user!~user@0.0.0.0 PRIVMSG #q :q: weather for chicago' =~ Regexp.new(feature.keyword_expression)
    $1.should == 'chicago'
  end

  it 'returns a not found message if query returns no results' do
    IRC::Bot::API::Wunderground.should_receive(:query).with('chicago').and_return([])
    feature.generate_reply('chicago').should == ["City not found."]
  end

  it 'returns wunderground query if results' do
    IRC::Bot::API::Wunderground.should_receive(:query).with('chicago').and_return(["sunny!"])
    feature.generate_reply('chicago').should == ["sunny!"]
  end
end
