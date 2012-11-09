require 'spec_helper'
require 'irc/message'

describe IRC::Message do
  let(:ping) { "PING :irc.example.net" }
  let(:empty_ping) { "PING" }
  let(:privmsg_with_nick) { ":naush!~naush@0.0.0.0 PRIVMSG #8thlight :q: How are you?" }
  let(:privmsg_without_nick) { ":naush!~naush@0.0.0.0 PRIVMSG #8thlight How are you?" }
  let(:privmsg_with_blank_spaces) { ":naush!~naush@0.0.0.0 PRIVMSG #8thlight :q: How are you?   " }

  context 'ping' do
    let(:message) { IRC::Message.parse(ping) }
    it 'has a message type of :ping' do
      message[:type].should == :ping
    end

    it 'has a recipient of nil' do
      message[:recipient].should == nil
    end

    it 'has content of irc.example.net' do
      message[:content].should == 'irc.example.net'
    end
  end

  context 'privmsg' do
    let(:message) { IRC::Message.parse(privmsg_with_nick) }

    it 'message type is :privmsg' do
      message[:type].should == :privmsg
    end

    it 'finds a recipient' do
      message[:recipient].should == 'q'
    end

    it 'returns nil if no recipient found' do
      message = IRC::Message.parse(privmsg_without_nick)
      message[:recipient].should == nil
    end

    it 'has content' do
      message[:content].should == "How are you?"
    end
  end

  context 'cannot identify message type' do
    it 'returns an empty message' do
      message = IRC::Message.parse('some string')

      message[:type].should be_nil
      message[:recipient].should be_nil
      message[:content].should be_nil
    end
  end
  context 'content formatting' do
    it 'strips blank spaces' do
      message = IRC::Message.parse(privmsg_with_blank_spaces)
      message[:content].should == "How are you?"
    end
  end
end
