module Formulator
  class Token
    attr_reader :category, :value, :raw

    def initialize(category, value, raw=nil)
      @category = category
      @value    = value
      @raw      = raw
    end

    def is?(category)
      @category == category
    end

    def ==(other)
      (category.nil? || other.category.nil? || category == other.category) &&
      (value.nil? || other.value.nil? || value == other.value)
    end

    def length
      raw.to_s.length
    end
  end
end