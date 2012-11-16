require 'spec_helper'
require 'irc/bot/features/quote'
require 'irc/bot/api/quote'

describe IRC::Bot::Features::Quote do
  let(:feature) { described_class.new('q') }

  it 'matches query words' do
    ':user!~user@0.0.0.0 PRIVMSG #q :q: quote simpsons_homer' =~ Regexp.new(feature.keyword_expression)
    $1.should == ' simpsons_homer'
  end

  it 'returns a not found message if no query results' do
    IRC::Bot::API::Quote.should_receive(:query).with('Homer Simpsons').and_return([])
    feature.generate_reply('Homer Simpsons').should == ["Quote not found."]
  end
end

