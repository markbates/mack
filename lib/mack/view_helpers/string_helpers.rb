module Mack
  module ViewHelpers # :nodoc:
    module StringHelpers
      
      # Takes a count integer and a word and returns a phrase containing the count
      # and the correct inflection of the word.
      # 
      # Examples:
      #   pluralize_word(0, "error") # => "0 errors"
      #   pluralize_word(1, "error") # => "1 error"
      #   pluralize_word(2, "error") # => "2 errors"
      def pluralize_word(count, word)
        if count.to_i == 1
          "#{count} #{word.singular}"
        else
          "#{count} #{word.plural}"
        end
      end
      
    end # StringHelpers
  end # ViewHelpers
end # Mack