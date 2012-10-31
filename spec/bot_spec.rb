require 'spec_helper'
require_relative '../lib/irc/bot'

describe IRC::Bot do
  context "self.respond" do
    before do
      IRC::Bot.any_instance.stub(:puts)
    end

    it "pong" do
      mock_client = mock("client")
      mock_client.should_receive(:pong).with("irc.example.net")
      bot = IRC::Bot.new(mock_client)
      bot.respond("PING :irc.example.net")
    end

    it "image_search" do
      mock_client = mock("client", :channel => '8thlight', :nick => 'q')
      mock_client.should_receive(:message).with("Image not found.")
      IRC::API::GoogleImage.should_receive(:query).with('kitties').and_return([])
      bot = IRC::Bot.new(mock_client)
      bot.respond(":naush!~naush@0.0.0.0 PRIVMSG #8thlight :q: show me kitties")
    end

    it "weather_forecast" do
      mock_client = mock("client", :channel => '8thlight', :nick => 'q')
      mock_client.should_receive(:message).with("City not found.")
      IRC::API::Wunderground.should_receive(:query).with('chicago').and_return([])
      bot = IRC::Bot.new(mock_client)
      bot.respond(":naush!~naush@0.0.0.0 PRIVMSG #8thlight :q: weather for chicago")
    end

    it "writes to ai" do
      mock_client = mock("client", :channel => '8thlight', :nick => 'q')
      mock_ai = mock("ai")
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
  end
end
