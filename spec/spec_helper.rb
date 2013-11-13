require 'formulator'

def token_stream(*args)
  args.map do |value|
    type = type_for(value)
    Formulator::Token.new(type, value)
  end
end

def type_for(value)
  case value
    when Numeric
      :numeric
    when :add, :subtract, :multiply, :divide
      :operator
    when :open, :close
      :grouping
    else
      :identifier
  end
end

