require_relative '../spec_helper'
require_relative '../../lib/irc/ai/grammar'

describe IRC::AI::Grammar do
  it "capitalizes a sentence" do
    IRC::AI::Grammar.format("he is a robot").should == "He is a robot."
  end

  it "adds an period at the end of the sentence" do
    IRC::AI::Grammar.format("he has a heart").should == "He has a heart."
  end

  it "adds a question mark at the end of the sentence if starts with a question word" do
    IRC::AI::Grammar.format("what").should == "What?"
    IRC::AI::Grammar.format("when").should == "When?"
    IRC::AI::Grammar.format("where").should == "Where?"
    IRC::AI::Grammar.format("which").should == "Which?"
    IRC::AI::Grammar.format("who").should == "Who?"
    IRC::AI::Grammar.format("whom").should == "Whom?"
    IRC::AI::Grammar.format("whose").should == "Whose?"
    IRC::AI::Grammar.format("why").should == "Why?"
    IRC::AI::Grammar.format("how").should == "How?"
  end
end