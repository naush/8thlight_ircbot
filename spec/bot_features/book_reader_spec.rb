require 'spec_helper'
require_relative '../../lib/irc/bot_features/book_reader'

describe IRC::BotFeatures::BookReader do
  class MockAi
    def learn(book_title)
    end
  end

  let (:feature) { described_class.new(MockAi.new, 'q') }

  it 'matches book titles' do
    ':user!~user@0.0.0.0 PRIVMSG #q :q: read Metamorphosis' =~ Regexp.new(feature.keyword_expression)
    $1.should == 'Metamorphosis'
  end

  it 'knows books' do
    File.should_receive(:exists?).and_return(true)

    feature.generate_reply("ulysses").should == ["I know Ulysses."]
  end
end
