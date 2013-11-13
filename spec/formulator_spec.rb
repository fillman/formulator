require 'spec_helper'

describe Formulator do
  it 'should evaluate mathematical expression' do
    Formulator('5+3').should eql(8)
  end
end