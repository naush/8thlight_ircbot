require 'spec_helper'
require 'irc/bot/features/show_me'

describe IRC::Bot::Features::ShowMe do
  let(:feature) { described_class.new('q') }

  it 'matches query words' do
    ':user!~user@0.0.0.0 PRIVMSG #q :q: show me ponies' =~ Regexp.new(feature.keyword_expression)
    $1.should == 'ponies'
  end

  it 'returns a not found message if no query results' do
    IRC::Bot::API::GoogleImage.should_receive(:query).with('kitties').and_return([])
    feature.generate_reply('kitties').should == ["Image not found."]
  end

  it 'returns a sample of the image results' do
    results = ['cat1.jpg', 'cat2.jpg']
    IRC::Bot::API::GoogleImage.should_receive(:query).with('kitties').and_return(results)
    results.should include(feature.generate_reply('kitties')[0])
  end
end
