require 'spec_helper'
require 'irc/bot/ai/grammar'

describe IRC::Bot::AI::Grammar do
  it "capitalizes a sentence" do
    IRC::Bot::AI::Grammar.format("he is a robot").should == "He is a robot."
  end

  it "adds an period at the end of the sentence" do
    IRC::Bot::AI::Grammar.format("he has a heart").should == "He has a heart."
  end

  it "adds a question mark to sentence if starts with a question word" do
    IRC::Bot::AI::Grammar.format("what").should == "What?"
  end
end
