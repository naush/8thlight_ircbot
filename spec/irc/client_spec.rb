require 'spec_helper'
require 'irc/client'

describe IRC::Client do
  before do
    IRC::Client.any_instance.stub(:puts)
  end

  it "has server, port, nick and channel" do
    client = IRC::Client.new('irc.8thlight.com', 6697, 'joe')
    client.server.should == 'irc.8thlight.com'
    client.port.should == 6697
    client.nick.should == 'joe'
  end

  it "connects to the irc server" do
    client = IRC::Client.new('irc.8thlight.com', 6697, 'joe')
    socket = mock("TCPSocket")
    TCPSocket.should_receive(:new).with('irc.8thlight.com', 6697).and_return(socket)
    ssl_socket = mock("SSLSocket")
    OpenSSL::SSL::SSLSocket.should_receive(:new).with(socket).and_return(ssl_socket)
    ssl_socket.should_receive(:connect)
    ssl_socket.should_receive(:puts).with("USER Anonymous 8 * :Anonymous\n")
    ssl_socket.should_receive(:puts).with("NICK joe\n")

    client.connect
    client.socket.should == ssl_socket
  end

  context "joining a room" do
    it "joins a room" do
      client = IRC::Client.new('irc.8thlight.com', 6697, 'joe')
      mock_socket = mock
      mock_socket.should_receive(:puts).with("JOIN #8thlight\n")
      client.socket = mock_socket
      client.join("8thlight")
    end

    it "joins a room with password" do
      client = IRC::Client.new('irc.8thlight.com', 6697, 'joe')
      mock_socket = mock
      mock_socket.should_receive(:puts).with("JOIN #8thlight password\n")
      client.socket = mock_socket
      client.join("8thlight", "password")
    end
  end

  it "messages the server" do
    client = IRC::Client.new('irc.8thlight.com', 6697, 'joe')

    mock_socket = mock
    mock_socket.should_receive(:puts).with("JOIN #8thlight\n")
    mock_socket.should_receive(:puts).with("PRIVMSG #8thlight :I'm a real boy!\n")

    client.socket = mock_socket
    client.join('8thlight')
    client.message("I'm a real boy!")
  end
end
