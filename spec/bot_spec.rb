require 'spec_helper'
require_relative '../lib/irc/bot'

describe IRC::Bot do
  let(:mock_client) { mock("client", :channel => '8thlight', :nick => 'q') }
  let(:mock_ai) { mock("ai", :write => true, :load_corpus => true) }
  let(:bot) { IRC::Bot.new(mock_client, mock_ai) }

  class MockFeature
    def keyword
      "mock"
    end

    def generate_reply(input)
      ["output for #{input}"]
    end
  end

  context "self.respond" do
    before do
      IRC::Bot.any_instance.stub(:puts)
    end

    it "pong" do
      mock_client.should_receive(:pong).with("irc.example.net")
      bot = IRC::Bot.new(mock_client, mock_ai)
      bot.respond("PING :irc.example.net")
    end

    it "writes to ai" do
      mock_client = mock("client", :channel => '8thlight', :nick => 'q')
      mock_ai.should_receive(:write).with('How are you?')
      mock_ai.should_receive(:load_corpus)
      bot = IRC::Bot.new(mock_client, mock_ai)
      bot.respond(":naush!~naush@0.0.0.0 PRIVMSG #8thlight :How are you?")
    end

    it "writes to and read from ai" do
      mock_client = mock("client", :channel => '8thlight', :nick => 'q')
      mock_client.should_receive(:message).with('Fine, thank you.')
      mock_ai = mock("ai")
      mock_ai.should_receive(:write).with('How are you?')
      mock_ai.should_receive(:read).and_return('Fine, thank you.')
      mock_ai.should_receive(:load_corpus)
      bot = IRC::Bot.new(mock_client, mock_ai)

      bot.respond(":naush!~naush@0.0.0.0 PRIVMSG #8thlight :q: How are you?")
    end

    it 'uses feature registry to respond' do
      bot.features = []
      feature = MockFeature.new
      bot.install_feature(feature)
      mock_client.should_receive(:message).with("output for something")

      bot.respond(":naush!~naush@0.0.0.0 PRIVMSG #8thlight :q: mock something")
    end

    it 'raises exception if bot should reboot' do
      lambda {bot.respond(":naush!~naush@0.0.0.0 PRIVMSG #8thlight :q: reboot")}.should raise_error
    end

    it 'responds via AI if no installed features execute' do
      response = "mock ai response"
      mock_ai.should_receive(:write)
      mock_ai.should_receive(:read).with("mock something").and_return(response)
      mock_client.should_receive(:message).with(response)

      bot = IRC::Bot.new(mock_client, mock_ai)

      bot.respond(":naush!~naush@0.0.0.0 PRIVMSG #8thlight :q: mock something")
    end
  end

  context 'features' do
    it 'installs features' do
      bot.features = []
      feature = stub(keyword: "stub", generate_reply: "stub reply")
      bot.install_feature(feature)

      bot.features.should == [feature]
    end
  end
end
