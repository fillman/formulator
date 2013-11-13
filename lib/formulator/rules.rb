module Formulator
  class Rules
    def self.each
      @rules ||= [
          [ p(:group),      :evaluate_group ],
          [ p(:math_mul),   :apply          ],
          [ p(:math_add),   :apply          ],
      ]

      @rules.each { |r| yield r }
    end

    def self.t(name)
      @matchers ||= [
          :numeric, :addsub, :muldiv,
          :open, :close,
          :non_group, :non_group_star,
      ].each_with_object({}) do |name, matchers|
        matchers[name] = TokenMatcher.send(name)
      end

      @matchers[name]
    end

    def self.p(name)
      @patterns ||= {
          group:      pattern(:open,    :non_group_star, :close),
          math_add:   pattern(:numeric, :addsub,         :numeric),
          math_mul:   pattern(:numeric, :muldiv,         :numeric),
      }

      @patterns[name]
    end

    def self.pattern(*symbols)
      symbols.map { |s| t(s) }
    end
  end
end
