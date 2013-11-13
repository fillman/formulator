require 'spec_helper'

describe Formulator::Token do
  it 'should have a category and a value' do
    token = Formulator::Token.new(:numeric, 5)
    token.category.should eq(:numeric)
    token.value.should eq(5)
    token.is?(:numeric).should be_true
  end

end