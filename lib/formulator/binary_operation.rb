module Formulator
  class BinaryOperation
    attr_reader :left, :right

    def initialize(left, right)
      @left = left
      @right = right
    end

    def add
      [:numeric, left + right]
    end

    def substract
      [:numeric, left - right]
    end

    def multiply
      [:numeric, left * right]
    end

    def divide
      [:numeric, left.to_f / right.to_f]
    end
  end
end