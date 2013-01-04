require 'irc/bot/features/jargon'

module IRC
  module Bot
    module Features
      describe Jargon do
        it 'matches "initiate business"' do
          jargon = described_class.new('q')
          ':user!~user@0.0.0.0 PRIVMSG #q :q: initiate business'.should =~ Regexp.new(jargon.keyword_expression)
        end

        it 'generate reply' do
          jargon = described_class.new('q')
          Jargon::Jargonizer.stub(:generate).and_return('generated jargon')
          jargon.generate_reply('').should == ['generated jargon']
        end

        describe Jargon::Jargonizer do
          it "generates a business jargon sentance" do
            stub_const("IRC::Bot::Features::Jargon::Jargonizer::ADVERBS", ["adverb"])
            stub_const("IRC::Bot::Features::Jargon::Jargonizer::VERBS", ["verb"])
            stub_const("IRC::Bot::Features::Jargon::Jargonizer::ADJECTIVES", ["adjective"])
            stub_const("IRC::Bot::Features::Jargon::Jargonizer::NOUNS", ["noun"])
            Jargon::Jargonizer.generate.should == "adverb verb adjective noun"
          end
        end
      end

    end
  end
end

