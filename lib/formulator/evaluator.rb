module Formulator
  class Evaluator
    def evaluate(tokens)
      evaluate_token_stream(tokens).value
    end

    def evaluate_token_stream(tokens)
      while tokens.length > 1
        matched, tokens = match_rule_pattern(tokens)
        raise "no rule found" unless matched
      end

      tokens << Formulator::Token.new(:numeric, 0) if tokens.empty?

      tokens.first
    end

    def match_rule_pattern(tokens)
      matched = false
      Formulator::Rules.each do |pattern, evaluator|
        pos, match = find_rule_match(pattern, tokens)

        if pos
          tokens = evaluate_step(tokens, pos, match.length, evaluator)
          matched = true
          break
        end
      end

      [matched, tokens]
    end

    def find_rule_match(pattern, token_stream)
      position = 0

      while position <= token_stream.length
        matches = []
        matched = true

        pattern.each do |matcher|
          match = matcher.match(token_stream, position + matches.length)
          matched &&= match.matched?
          matches += match
        end

        return position, matches if matched
        position += 1
      end

      nil
    end

    def evaluate_step(token_stream, start, length, evaluator)
      expr = token_stream.slice!(start, length)
      token_stream.insert start, *self.send(evaluator, *expr)
    end

    def evaluate_group(*args)
      evaluate_token_stream(args[1..-2])
    end

    def apply(lvalue, operator, rvalue)
      operation = BinaryOperation.new(lvalue.value, rvalue.value)
      raise "unknown operation #{ operator.value }" unless operation.respond_to?(operator.value)
      Formulator::Token.new(*operation.send(operator.value))
    end
  end
end