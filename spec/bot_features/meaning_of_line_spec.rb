require 'spec_helper'
require_relative '../../lib/irc/api/google_image'
require_relative '../../lib/irc/bot_features/meaning_of_life'

describe IRC::BotFeatures::MeaningOfLife do
  let(:feature) { described_class.new }

  it 'keyword is "what is the meaning of life"' do
    feature.keyword.should == 'what is the meaning of life'
  end

  it 'is 42' do
    feature.generate_reply("blah").should == ['42.']
  end
end
