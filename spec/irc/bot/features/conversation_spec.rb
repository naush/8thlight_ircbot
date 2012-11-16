require 'spec_helper'
require 'irc/bot/features/tell_someone'

describe IRC::Bot::Features::TellSomeone do
  it 'matches "tell <someone> <something>"' do
    feature = described_class.new('q')
    ':user!~user@0.0.0.0 PRIVMSG #q :q: tell someone something' =~ Regexp.new(feature.keyword_expression)
    $1.should == 'someone something'
  end

  it 'generate reply' do
    feature = described_class.new('q')
    feature.generate_reply('someone something').should == ['someone: something']
  end
end

