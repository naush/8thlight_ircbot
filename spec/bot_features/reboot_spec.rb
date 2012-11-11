require 'spec_helper'
require_relative '../../lib/irc/bot_features/reboot'

describe IRC::BotFeatures::Reboot do
  let(:feature) { described_class.new('q') }

  it 'matches the question' do
    result = ':user!~user@0.0.0.0 PRIVMSG #q :q: reboot' =~ Regexp.new(feature.keyword_expression)
    result.should == 0
  end

  it 'raises exception' do
    expect { feature.generate_reply("blah") }.to raise_error
  end
end

