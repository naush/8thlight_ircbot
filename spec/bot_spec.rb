require 'spec_helper'
require_relative '../lib/irc/bot'

describe IRC::Bot do
  context "self.handle_server_input" do
    before do
      IRC::Bot.stub(:puts)
    end

    it "pong" do
      mock_client = mock("client")
      mock_client.should_receive(:pong).with("irc.example.net")
      IRC::Bot.handle_server_input(mock_client, "PING :irc.example.net")
    end

    it "image_search" do
      mock_client = mock("client", :channel => '8thlight', :nick => 'siri')
      IRC::Bot.should_receive(:image_search).with(mock_client, 'kitties')
      IRC::Bot.handle_server_input(mock_client, ":naush!~naush@0.0.0.0 PRIVMSG #8thlight :siri: show me kitties")
    end

    it "weather_forecast" do
      mock_client = mock("client", :channel => '8thlight', :nick => 'siri')
      IRC::Bot.should_receive(:weather_forecast).with(mock_client, 'chicago')
      IRC::Bot.handle_server_input(mock_client, ":naush!~naush@0.0.0.0 PRIVMSG #8thlight :siri: weather for chicago")
    end
  end
end
