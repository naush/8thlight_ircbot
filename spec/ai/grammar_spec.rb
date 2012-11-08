require_relative '../spec_helper'
require_relative '../../lib/irc/ai/grammar'

describe IRC::AI::Grammar do
  it "capitalizes a sentence" do
    IRC::AI::Grammar.format("he is a robot").should == "He is a robot."
  end

  it "adds an period at the end of the sentence" do
    IRC::AI::Grammar.format("he has a heart").should == "He has a heart."
  end

  it "adds a question mark  sentence if starts with a question word" do
    IRC::AI::Grammar.format("what").should == "What?"
    IRC::AI::Grammar.format("when").should == "When?"
    IRC::AI::Grammar.format("where").should == "Where?"
    IRC::AI::Grammar.format("which").should == "Which?"
    IRC::AI::Grammar.format("who").should == "Who?"
    IRC::AI::Grammar.format("whom").should == "Whom?"
    IRC::AI::Grammar.format("whose").should == "Whose?"
    IRC::AI::Grammar.format("why").should == "Why?"
    IRC::AI::Grammar.format("how").should == "How?"

    IRC::AI::Grammar.format("should").should == "Should?"
    IRC::AI::Grammar.format("shouldn't").should == "Shouldn't?"
    IRC::AI::Grammar.format("can").should == "Can?"
    IRC::AI::Grammar.format("can't").should == "Can't?"
    IRC::AI::Grammar.format("do").should == "Do?"
    IRC::AI::Grammar.format("don't").should == "Don't?"
    IRC::AI::Grammar.format("does").should == "Does?"
    IRC::AI::Grammar.format("doesn't").should == "Doesn't?"
    IRC::AI::Grammar.format("have").should == "Have?"
    IRC::AI::Grammar.format("haven't").should == "Haven't?"

    IRC::AI::Grammar.format("am").should == "Am?"
    IRC::AI::Grammar.format("are").should == "Are?"
    IRC::AI::Grammar.format("aren't").should == "Aren't?"
    IRC::AI::Grammar.format("is").should == "Is?"
    IRC::AI::Grammar.format("isn't").should == "Isn't?"
  end
end
