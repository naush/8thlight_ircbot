require 'spec_helper'
require 'irc/bot/ai/engine'

describe IRC::Bot::AI::Engine do
  let(:ai) do
    ai = IRC::Bot::AI::Engine.new
    ai.stop_words = []
    ai
  end

  it "writes one word" do
    ai.write("one")
    ai.store["one"].should == {}
  end

  it "writes two words" do
    ai.write("one two")
    ai.store["one two"].should == {}
  end

  it "writes three words" do
    ai.write("one two three")
    ai.store["one two"].keys.should == ["three"]
  end

  it "writes five duplicate words" do
    ai.write("cat cat cat cat cat")
    ai.store["cat cat"].values.first.should == 3
  end

  it "writes word in lowercase" do
    ai.write("One two three")
    ai.store["one two"].keys.should == ["three"]
  end

  it "reads one word" do
    ai.write("one two three")
    ai.write("two three four")
    ai.read("one").should == "One two three four."
  end

  it "reads two words" do
    ai.write("one two three")
    ai.write("two three four")
    ["One two three four.", "Two three four."].should include(ai.read("one two"))
  end

  it "reads a sentence" do
    ai.write("I have a book")
    ai.write("a book about Alchemy")
    ai.read("I").should == "I have a book about alchemy."
  end

  it "avoids a loop" do
    ai.write("one two one")
    ai.read("one").should == "One two."
  end

  it "avoids a loop with capitalized keys" do
    ai.write("I thought I")
    ai.read("I thought").should == "I thought."
  end

  it "recognizes sentences" do
    ai.write("one two three. one two four.")
    sentence = ai.read("one two")
    ["One two three.", "One two four.", "Two three.", "Two four."].should include(sentence)
  end

  it "changes persona" do
    ai.change('skim')
    ai.persona['confused_phrases'].should include('What did you say to me?')
  end
end
