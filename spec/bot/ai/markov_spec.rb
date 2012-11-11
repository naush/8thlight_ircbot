require 'spec_helper'
require 'irc/bot/ai/markov'

describe IRC::Bot::AI::Markov do
  let(:ai) { IRC::Bot::AI::Markov.new }

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

  it "assigns zero frequency to stop words" do
    ai.stop_words = ['i', 'thought']
    ai.write("I thought I")
    ai.store['i thought'].values.first.should == 0
  end

  it "writes word in lowercase" do
    ai.write("One two three")
    ai.store["one two"].keys.should == ["three"]
  end

  it "reads two words" do
    ai.write("one two three")
    ai.write("two three four")
    ai.read("one two").should == "One two three four."
  end

  it "reads a sentence" do
    ai.write("I have a book")
    ai.write("a book about Alchemy")
    ai.read("I have").should == "I have a book about alchemy."
  end

  it "avoids a loop" do
    ai.write("one two one")
    ai.read("one two").should == "One two."
  end

  it "avoids a loop with capitalized keys" do
    ai.write("I thought I")
    ai.read("I thought").should == "I thought."
  end

  it "recognizes sentences" do
    ai.write("one two three. one two four.")
    sentence = ai.read("one two")
    ["One two three.", "One two four."].should include(sentence)
  end

  it "changes persona" do
    ai.change('skim')
    ai.persona['confused_phrases'].should include('What did you say to me?')
  end
end
