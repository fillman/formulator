require 'spec_helper'

describe Formulator::Tokenizer do
  let(:tokenizer) { described_class.new }

  it 'should handle empty expression' do
    tokenizer.tokenize('').should be_empty
  end

  it 'should tokenize addition' do
    tokens = tokenizer.tokenize('1+1')
    tokens.map(&:category).should eq([:numeric, :operator, :numeric])
    tokens.map(&:value).should eq([1, :add, 1])
  end

  it 'should ignore whitespace' do
    tokens = tokenizer.tokenize('1                   *                     1')
    tokens.map(&:category).should eq([:numeric, :operator, :numeric])
    tokens.map(&:value).should eq([1, :multiply, 1])
  end

  it 'should deal with floats' do
    tokens = tokenizer.tokenize('1.0 + 1.3')
    tokens.map(&:category).should eq([:numeric, :operator, :numeric])
    tokens.map(&:value).should eq([1.0, :add, 1.3])
  end

  it 'should detect missing brackets' do
    lambda { tokenizer.tokenize('(1+1')}.should raise_error
    lambda { tokenizer.tokenize(')')}.should raise_error
  end
end