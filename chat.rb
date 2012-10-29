require_relative 'lib/irc/ai/markov'

ai = IRC::AI::Markov.new

while true
  print "< "
  user_input = $stdin.gets
  break if ["exit\n", "quit\n", "q\n"].include?(user_input.downcase)
  puts "> " + ai.read(user_input)
  ai.write(user_input)
end

puts "> See ya!"
