require "formulator/version"
require "formulator/binary_operation"
require "formulator/token"
require "formulator/token_scanner"
require "formulator/token_matcher"
require "formulator/rules"
require "formulator/tokenizer"
require "formulator/evaluator"


module Formulator
  # Your code goes here...
  def self.evaluate(expression)
    tokenizer = Tokenizer.new
    tokens = tokenizer.tokenize(expression)
    evaluator = Evaluator.new

    evaluator.evaluate(tokens)
  end

end

def Formulator(expression)
  Formulator.evaluate(expression)
end
