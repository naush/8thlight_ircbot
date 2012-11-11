require 'spec_helper'
require_relative '../lib/irc/bot'

describe IRC::Bot do
  let(:mock_client) { mock("client", :channel => '8thlight', :nick => 'q') }
  let(:mock_ai) { mock("ai", :write => true, :load_corpus => true) }
  let(:bot) { IRC::Bot.new(mock_client, mock_ai) }

  class MockFeature
    def keyword_expression
      "mock (.*)$"
    end

    def generate_reply(input)
      ["output for #{input}"]
    end
  end

  context "self.respond" do
    it "pong" do
      message = {type: :ping, recipient: nil, content: 'irc.example.net'}
      mock_client.should_receive(:pong).with("irc.example.net")
      bot = IRC::Bot.new(mock_client, mock_ai)
      bot.respond(message)
    end

    it "writes to ai" do
      message = {type: :privmsg, recipient: nil, content: 'How are you?'}
      mock_client = mock("client", :channel => '8thlight', :nick => 'q')
      mock_ai.should_receive(:write).with('How are you?')
      mock_ai.should_receive(:load_corpus)
      bot = IRC::Bot.new(mock_client, mock_ai)
      bot.respond(message)
    end

    it "writes to and read from ai" do
      message = {type: :privmsg, recipient: 'q', content: 'How are you?'}
      mock_client = mock("client", :channel => '8thlight', :nick => 'q')
      mock_client.should_receive(:message).with('Fine, thank you.')
      mock_ai = mock("ai")
      mock_ai.should_receive(:write).with('How are you?')
      mock_ai.should_receive(:read).and_return('Fine, thank you.')
      mock_ai.should_receive(:load_corpus)
      bot = IRC::Bot.new(mock_client, mock_ai)

      bot.respond(message)
    end

    it 'uses feature registry to respond' do
      message = {type: :privmsg, recipient: 'q', content: 'mock something'}
      bot.features = []
      feature = MockFeature.new
      bot.install_feature(feature)
      mock_client.should_receive(:message).with("output for something")

      bot.respond(message)
    end

    it 'raises exception if bot should reboot' do
      message = {type: :privmsg, recipient: 'q', content: 'reboot'}
      lambda {bot.respond(message)}.should raise_error
    end

    it 'responds via AI if no installed features execute' do
      message = {type: :privmsg, recipient: 'q', content: 'mock something'}
      bot.features = []
      response = "mock ai response"
      mock_ai.should_receive(:write)
      mock_ai.should_receive(:read).with("mock something").and_return(response)
      mock_client.should_receive(:message).with(response)

      bot = IRC::Bot.new(mock_client, mock_ai)

      bot.respond(message)
    end

    it 'saves ai corpus' do
      message = {type: :privmsg, recipient: 'q', content: 'save'}
      mock_client = mock("client", :channel => '8thlight', :nick => 'q')
      mock_client.should_receive(:message).with("Saved.")
      mock_ai = mock("ai", :load_corpus => true)
      mock_ai.should_receive(:save_corpus)

      bot = IRC::Bot.new(mock_client, mock_ai)
      bot.respond(message)
    end
  end

  context 'features' do
    it 'installs features' do
      bot.features = []
      feature = stub(keyword_expression: "stub", generate_reply: "stub reply")
      bot.install_feature(feature)

      bot.features.should == [feature]
    end
  end
end
