require 'spec_helper'

describe Formulator::TokenMatcher do
  it 'matcher category should match token category' do
    matcher = described_class.new(:numeric)
    token   = Formulator::Token.new(:numeric, 5)

    matcher.should == token
  end

  it 'multiple categories should also match token category is there is one' do
    matcher    = described_class.new([:numeric, :operator])
    numeric    = Formulator::Token.new(:numeric, 5)
    whitespace = Formulator::Token.new(:whitespace, ' ')
    operator   = Formulator::Token.new(:operator, :add)

    matcher.should == numeric
    matcher.should == operator
    matcher.should_not == whitespace
  end

  it 'should match category and value if given' do
    matcher  = described_class.new(:numeric, 5)
    five     = Formulator::Token.new(:numeric, 5)
    seven    = Formulator::Token.new(:numeric, 7)

    matcher.should == five
    matcher.should_not == seven
  end

  it 'should catch with multiple values' do
    matcher  = described_class.new(:numeric, [5, 7])
    five     = Formulator::Token.new(:numeric, 5)
    seven    = Formulator::Token.new(:numeric, 7)
    eight    = Formulator::Token.new(:numeric, 8)

    matcher.should == five
    matcher.should == seven
    matcher.should_not == eight
  end

  it 'should be invertible' do
    matcher  = described_class.new(:numeric, [5, 7]).invert
    five     = Formulator::Token.new(:numeric, 5)
    seven    = Formulator::Token.new(:numeric, 7)
    eight    = Formulator::Token.new(:numeric, 8)

    matcher.should_not == five
    matcher.should_not == seven
    matcher.should == eight
  end

  describe 'stream matching' do
    let(:stream) { token_stream(5, 11, 9, 24, :hello, 8) }

    describe :standart do
      let(:standart) { described_class.new(:numeric) }

      it 'should match zero or one occurrence in a token stream' do
        substream = standart.match(stream)
        substream.should be_matched
        substream.length.should eq 1
        substream.map(&:value).should eq [5]

        substream = standart.match(stream, 4)
        substream.should be_empty
        substream.should_not be_matched
      end
    end

    describe :star do
      let(:standart) { described_class.new(:numeric).star }

      it 'should match zero or more occurrences in a stream' do
        substream = standart.match(stream)
        substream.should be_matched
        substream.length.should eq 4
        substream.map(&:value).should eq [5, 11, 9, 24]

        substream = standart.match(stream, 4)
        substream.should be_empty
        substream.should be_matched
      end
    end

    describe :plus do
      let(:plus) { described_class.new(:numeric).plus }

      it 'should match one or more occurrences in a token stream' do
        substream = plus.match(stream)
        substream.should be_matched
        substream.length.should eq 4
        substream.map(&:value).should eq [5, 11, 9, 24]

        substream = plus.match(stream, 4)
        substream.should be_empty
        substream.should_not be_matched
      end
    end
  end
end