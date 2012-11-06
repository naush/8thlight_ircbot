require 'spec_helper'
require_relative '../../lib/irc/bot_features/book_reader'

describe IRC::BotFeatures::BookReader do
  class MockAi
    def learn(book_title)
    end
  end

  let (:feature) { described_class.new(MockAi.new) }

  it 'keyword expression is "read (.*)$"' do
    feature.keyword_expression.should == 'read (.*)$'
  end

  it 'knows books' do
    File.should_receive(:exists?).and_return(true)

    feature.generate_reply("ulysses").should == ["I know Ulysses."]
  end

  it 'knows metamorphosis' do
    feature.generate_reply("metamorphosis").should == ["I know Metamorphosis."]
  end
end
