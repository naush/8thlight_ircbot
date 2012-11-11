require_relative '../spec_helper'
require_relative '../../lib/irc/ai/grammar'

describe IRC::AI::Grammar do
  before do
    IO.stub(:read).and_return(['what'])
  end

  it "capitalizes a sentence" do
    IRC::AI::Grammar.format("he is a robot").should == "He is a robot."
  end

  it "adds an period at the end of the sentence" do
    IRC::AI::Grammar.format("he has a heart").should == "He has a heart."
  end

  it "adds a question mark to sentence if starts with a question word" do
    IRC::AI::Grammar.format("what").should == "What?"
  end
end
