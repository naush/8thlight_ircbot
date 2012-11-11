if ARGV.size != 5
  puts "USAGE: ruby boot.rb <nick> <server> <port> <channel> <password>"
  exit
end
nick, server, port, channel, password = ARGV

require_relative 'lib/irc/client'
require_relative 'lib/irc/connection'
client = IRC::Client.new(server, port, nick)

begin
  client.disconnect
  client.connect
  client.join(channel, password)
  IRC::Connection.start(client)
rescue Interrupt
rescue Exception => e
  p e.backtrace
  puts "> #{e.message}"
end
