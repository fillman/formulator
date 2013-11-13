require 'spec_helper'

describe Formulator::Evaluator do
  let(:evaluator) { described_class.new }

  describe 'rule scan' do
    it 'should find a matching rule' do
      rule = [Formulator::TokenMatcher.new(:numeric, nil)]
      stream = [Formulator::Token.new(:numeric, 1),
                Formulator::Token.new(:operator, :add),
                Formulator::Token.new(:numeric, 1)]
      position, match = evaluator.find_rule_match(rule, stream)
      position.should eq(0)
    end
  end

  describe 'evaluation' do
    it 'should be true when empty and return 0' do
      evaluator.evaluate([]).should be
      evaluator.evaluate([]).should eq(0)
    end

    it 'single numeric returns value' do
      evaluator.evaluate([Formulator::Token.new(:numeric, 5)]).should eq(5)
    end

    it 'should evaluate operation' do
      stream = token_stream(1, :add, 1, :add, 1)
      expected = token_stream(2, :add, 1)

      evaluator.evaluate_step(stream, 0, 3, :apply).should eq(expected)
    end

    it 'respects grouping' do
      stream = token_stream(:open, 2, :add, 2, :close, :multiply, 2)
      expected = token_stream(4, :multiply, 2)
      evaluator.evaluate_step(stream, 0, 5, :evaluate_group).should eq(expected)
    end

    it 'should perform addition' do
      evaluator.evaluate(token_stream(1, :add, 1)).should eq(2)
    end

    it 'should respect order of precedence' do
      evaluator.evaluate(token_stream(1, :add, 1, :multiply, 5)).should eq(6)
    end

    it 'should respect explicit grouping' do
      evaluator.evaluate(token_stream(:open, 1, :add, 1, :close, :multiply, 5)).should eq(10)
    end

    it 'should return floating point from division when there is a remainder' do
      evaluator.evaluate(token_stream(5, :divide, 4)).should eq(1.25)
    end
  end
end