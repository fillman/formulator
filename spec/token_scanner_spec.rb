require 'spec_helper'

describe Formulator::TokenScanner do
  let(:whitespace)  { described_class.new(:whitespace, '\s') }
  let(:numeric)     { described_class.new(:numeric, '(\d+(\.\d+)?|\.\d+)', ->(raw) {raw =~ /\./ ? raw.to_f : raw.to_i})}

  it 'should return a token for a match' do
    token = whitespace.scan(' ')
    token.category.should eq(:whitespace)
    token.value.should eq(' ')
  end

  it 'it should return false if no match' do
    whitespace.scan('NOT_WHITESPACE_HERE').should be_false
  end

  it 'it should return raw values' do
    token = numeric.scan('777')
    token.category.should eq(:numeric)
    token.value.should eq(777)
  end

end