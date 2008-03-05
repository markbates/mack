require 'singleton'
module Mack
  module Utils
    # This class is used to deal with inflection strings. This means taken a string and make it plural, or singular, etc...
    # Inflection rules can be added very easy, and are checked from the bottom up. This means that the last rule is the first
    # rule to be matched. The exception to this, kind of, is 'irregular' and 'uncountable' rules. The 'uncountable' rules are
    # always checked first, then the 'irregular' rules, and finally either the 'singular' or 'plural' rules, depending on what
    # you're trying to do. Within each of these sets of rules, the last rule in is the first rule matched.
    # 
    # Example:
    #   Mack::Utils::Inflector.inflections do |inflect|
    #     inflect.plural(/$/, 's')
    #     inflect.plural(/^(ox)$/i, '\1en')
    #     inflect.plural(/(phenomen|criteri)on$/i, '\1a')
    #   
    #     inflect.singular(/s$/i, '')
    #     inflect.singular(/(n)ews$/i, '\1ews')
    #     inflect.singular(/^(.*)ookies$/, '\1ookie')
    #   
    #     inflect.irregular('person', 'people')
    #     inflect.irregular('child', 'children')
    #   
    #     inflect.uncountable(%w(fish sheep deer offspring))
    #   end
    class Inflector
      include Singleton
      
      def initialize # :nodoc:
        @plural_rules = []
        @singular_rules = []
        @irregular_rules = []
        @uncountable_rules = []
      end
      
      # Adds a plural rule to the system.
      # 
      # Example:
      #   Mack::Utils::Inflector.inflections do |inflect|
      #     inflect.plural(/$/, 's')
      #     inflect.plural(/^(ox)$/i, '\1en')
      #     inflect.plural(/(phenomen|criteri)on$/i, '\1a')
      #   end
      def plural(rule, replacement)
        @plural_rules << {:rule => rule, :replacement => replacement}
      end
      
      # Adds a singular rule to the system.
      # 
      # Example:
      #   Mack::Utils::Inflector.inflections do |inflect|
      #     inflect.singular(/s$/i, '')
      #     inflect.singular(/(n)ews$/i, '\1ews')
      #     inflect.singular(/^(.*)ookies$/, '\1ookie')
      #   end
      def singular(rule, replacement)
        @singular_rules << {:rule => rule, :replacement => replacement}
      end
      
      # Adds a irregular rule to the system.
      # 
      # Example:
      #   Mack::Utils::Inflector.inflections do |inflect|
      #     inflect.irregular('person', 'people')
      #     inflect.irregular('child', 'children')
      #   end
      def irregular(rule, replacement)
        @irregular_rules << {:rule => rule, :replacement => replacement}
        # do the reverse so you get:
        # person => people
        # people => person
        @irregular_rules << {:rule => replacement, :replacement => rule}
      end
      
      # Adds a uncountable word, or words, to the system.
      # 
      # Example:
      #   Mack::Utils::Inflector.inflections do |inflect|
      #     inflect.uncountable(%w(fish sheep deer offspring))
      #   end
      def uncountable(*args)
        [args].flatten.each do |word|
          @uncountable_rules << word.downcase
        end
      end
      
      # Returns the singular version of the word, if possible.
      # 
      # Examples:
      #   Mack::Utils::Inflector.instance.singularize("armies") # => "army"
      #   Mack::Utils::Inflector.instance.singularize("people") # => "person"
      #   Mack::Utils::Inflector.instance.singularize("boats") # => "boat"
      def singularize(word)
        do_work(word, @singular_rules)
      end
      
      # Returns the singular version of the word, if possible.
      # 
      # Examples:
      #   Mack::Utils::Inflector.instance.pluralize("army") # => "armies"
      #   Mack::Utils::Inflector.instance.pluralize("person") # => "people"
      #   Mack::Utils::Inflector.instance.pluralize("boat") # => "boats"
      def pluralize(word)
        do_work(word, @plural_rules)
      end
      
      private
      def do_work(word, specific_rules)
        return word if @uncountable_rules.include?(word.downcase)
        w = word.dup
        [specific_rules, @irregular_rules].flatten.reverse.each do |rule_hash|
          return w if w.gsub!(rule_hash[:rule], rule_hash[:replacement])
        end
        # if all else fails, return the word:
        return word
      end
      
      public
      class << self
        
        # Yields up Mack::Utils::Inflector.instance
        def inflections
          yield Mack::Utils::Inflector.instance
        end
        
      end
      
    end # Inflection
  end # Utils
end # Mack