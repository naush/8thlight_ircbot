require "spec_helper"
require "irc/bot/ai/engine"

describe IRC::Bot::AI::Engine do
  let(:ai) do
    ai = IRC::Bot::AI::Engine.new
    ai.stop_words = []
    ai
  end

  it "writes one word" do
    ai.write("one")
    ai.store[">"]["one"].should == {}
    ai.store["<"]["one"].should == {}
  end

  it "writes two words" do
    ai.write("one two")
    ai.store[">"]["one two"].should == {}
    ai.store["<"]["one two"].should == {}
  end

  it "writes three words" do
    ai.write("one two three")
    ai.store[">"]["one two"].keys.should == ["three"]
    ai.store["<"]["two three"].keys.should == ["one"]
  end

  it "writes five duplicate words" do
    ai.write("cat cat cat cat cat")
    ai.store[">"]["cat cat"].values.first.should == 3
  end

  it "writes word in lowercase" do
    ai.write("One two three")
    ai.store[">"]["one two"].keys.should == ["three"]
  end

  it "reads one word in forward" do
    ai.write("one two three")
    ai.write("two three four")
    ai.read("one").should == "One two three four."
  end

  it "reads one word in backward" do
    ai.write("one two three")
    ai.write("two three four")
    ai.read("four").should == "One two three four."
  end

  it "reads two words" do
    ai.write("one two three")
    ai.write("two three four")
    ai.read("one two").should == "One two three four."
  end

  it "reads a sentence" do
    ai.write("I have a book")
    ai.write("a book about Alchemy")
    ai.read("I").should == "I have a book about alchemy."
  end

  it "reads backward" do
    ai.write("I have a book")
    ["I have a book."].should include(ai.read("book"))
  end

  it "avoids a loop" do
    ai.write("one two one")
    ["One two.", "Two one."].include?(ai.read("one"))
  end

  it "avoids a loop with capitalized keys" do
    ai.write("I thought I")
    ["I thought.", "Thought i."].should include(ai.read("I thought"))
  end

  it "recognizes sentences" do
    ai.write("one two three. one two four.")
    sentence = ai.read("one two")
    ["One two three.", "One two four."].should include(sentence)
  end

  it "changes persona" do
    ai.change("skim")
    ai.persona["confused_phrases"].should include("What did you say to me?")
  end

  it "stems a word" do
    ai.write("He loves you")
    ai.stem_words["love"].should == ["love", "loves"]
  end

  it "uses a stem word" do
    ai.write("Tiger eats bunny")
    ai.read("eat").should == "Tiger eats bunny."
  end
end
