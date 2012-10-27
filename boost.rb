if ARGV.size != 5
  puts "USAGE: ruby boost.rb <bot> <server> <port> <channel> <password>"
  exit
end

bot, server, port, channel, password = ARGV
require_relative 'lib/irc/client'
require_relative 'lib/irc/connection'

client = IRC::Client.new(server, port, bot)
client.connect
client.join(channel, password)

begin
  IRC::Connection.start(client)
rescue Interrupt
end
