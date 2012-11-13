require_relative 'lib/irc/bot/ai/engine'

ai = IRC::Bot::AI::Engine.new

while true
  print "< "
  user_input = $stdin.gets
  break if ["exit\n", "quit\n", "q\n"].include?(user_input.downcase)
  puts "> " + ai.read(user_input)
  ai.write(user_input)
end

puts "> See ya!"
