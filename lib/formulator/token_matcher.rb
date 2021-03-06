module Formulator
  class TokenMatcher
    def initialize(categories=nil, values=nil)
      @categories = [categories].compact.flatten
      @values     = [values].compact.flatten
      @invert     = false

      @min = 1
      @max = 1
    end

    def invert
      @invert = !@invert
      self
    end

    def ==(token)
      return false unless token
      (category_match(token.category) && value_match(token.value)) ^ @invert
    end

    def category_match(value)
      @categories.empty? || @categories.include?(value)
    end

    def value_match(value)
      @values.empty? || @values.include?(value)
    end

    def match(token_stream, offset=0)
      matched_tokens = []

      while self == token_stream[matched_tokens.length + offset] &&
            matched_tokens.length < @max
        matched_tokens << token_stream[matched_tokens.length + offset]
      end

      if (@min..@max).include? matched_tokens.length
        def matched_tokens.matched?() true end
      else
        def matched_tokens.matched?() false end
      end

      matched_tokens
    end

    def star
      @min = 0
      @max = 1.0/0 # invinite (nice!)
      self
    end

    def plus
      @max = 1.0/0 # invinite (nice!)
      self
    end

    def self.numeric;        new(:numeric);                        end
    def self.string;         new(:string);                         end
    def self.addsub;         new(:operator, [:add, :subtract]);    end
    def self.muldiv;         new(:operator, [:multiply, :divide]); end
    def self.pow;            new(:operator, :pow);                 end
    def self.open;           new(:grouping, :open);                end
    def self.close;          new(:grouping, :close);               end
    def self.non_group;      new(:grouping).invert;                end
    def self.non_group_star; new(:grouping).invert.star;           end
  end
end
