module Formulator
  class TokenScanner
    def initialize(category, regex, converter=nil)
      @category  = category
      @regex     = %r{\A(#{ regex })}i
      @converter = converter
    end

    def scan(string)
      if m = @regex.match(string)
        value = raw = m.to_s
        value = @converter.call(raw) if @converter

        return Token.new(@category, value, raw)
      end

      false
    end

    class << self
      def scanners
        @scanners ||= [
            whitespace,
            numeric,
            operator,
            grouping
        ]
      end

      def whitespace
        new(:whitespace, '\s+')
      end

      def numeric
        new(:numeric, '(\d+(\.\d+)?|\.\d+)\b', lambda { |raw| raw =~ /\./ ? raw.to_f : raw.to_i })
      end

      def operator
        names = { pow: '^', add: '+', subtract: '-', multiply: '*', divide: '/' }.invert
        new(:operator, '\^|\+|-|\*|\/', lambda { |raw| names[raw] })
      end

      def grouping
        names = { open: '(', close: ')'}.invert
        new(:grouping, '\(|\)', lambda { |raw| names[raw] })
      end
    end
  end
end