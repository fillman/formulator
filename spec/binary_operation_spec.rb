require 'spec_helper'

describe Formulator::BinaryOperation do
  let(:operation) { described_class.new(2,3) }

  it 'can add' do
    operation.add.should eq [:numeric, 5]
  end

  it 'can substract' do
    operation.substract.should eq [:numeric, -1]
  end

  it 'can multiple' do
    operation.multiply.should eq [:numeric, 6]
  end

  it 'can divide' do
    operation.divide.should eq [:numeric, 2.0/3.0]
  end
end