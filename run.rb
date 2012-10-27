if ARGV.size != 5
  puts "USAGE: ruby run.rb <bot> <server> <port> <channel> <password>"
  exit
end

bot = ARGV[0]
server = ARGV[1]
port = ARGV[2]
channel = ARGV[3]
password = ARGV[4]

require_relative 'lib/irc/client'
require_relative 'lib/irc/connection'

client = IRC::Client.new(server, port, bot)
client.connect
client.join(channel, password)

begin
  IRC::Connection.start(client)
rescue Interrupt
end
