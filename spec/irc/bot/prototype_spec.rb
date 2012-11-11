require 'spec_helper'
require 'irc/bot/prototype'

describe IRC::Bot::Prototype do
  let(:mock_client) { mock("client", :channel => '8thlight', :nick => 'q') }
  let(:mock_ai) { mock("ai", :write => true, :load_corpus => true) }
  let(:bot) { IRC::Bot::Prototype.new(mock_client, mock_ai) }

  class MockFeature
    def keyword_expression
      "mock (.*)$"
    end

    def generate_reply(input)
      ["output for #{input}"]
    end
  end

  context "self.respond" do
    it 'uses feature registry to respond' do
      feature = MockFeature.new
      bot.install_feature(feature)
      mock_client.should_receive(:message).with("output for something")
      bot.respond("mock something")
    end
  end

  context 'features' do
    it 'installs features' do
      feature = stub(keyword_expression: "stub", generate_reply: "stub reply")
      bot.install_feature(feature)

      bot.features.should == [feature]
    end
  end
end
