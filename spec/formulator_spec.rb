require 'spec_helper'

describe Formulator do
  it 'should evaluate mathematical expression' do
    Formulator('5+3').should eql(8)
    Formulator('(5+3)*2').should eql(16)
    Formulator('(5+3)*2 + 1').should eql(17)
    Formulator('5 + 6 / 2').should eql(8.0)
  end
end