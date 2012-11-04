require 'spec_helper'
require_relative '../../lib/irc/bot_features/show_me'

describe IRC::BotFeatures::ShowMe do
  let(:feature) { described_class.new }

  it 'keyword is "show me"' do
    feature.keyword.should == "show me"
  end

  it 'returns a not found message if no query results' do
    IRC::API::GoogleImage.should_receive(:query).with('kitties').and_return([])
    feature.generate_reply('kitties').should == ["Image not found."]
  end

  it 'returns a sample of the image results' do
    results = ['cat1.jpg', 'cat2.jpg']
    IRC::API::GoogleImage.should_receive(:query).with('kitties').and_return(results)
    results.should include(feature.generate_reply('kitties')[0])
  end
end

