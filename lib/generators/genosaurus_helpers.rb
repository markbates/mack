module Mack
  module Genosaurus
    module Helpers
      def columns(name = param(:name))
        ivar_cache("form_columns") do
          cs = []
          cols = (param(:cols) || param(:columns))
          if cols
            cols.split(",").each do |x|
              cs << Mack::Generator::ModelColumn.new(name, x)
            end
          end
          cs
        end
      end
      self.include_safely_into(::Genosaurus::Base)
    end # Helpers
  end # Genosaurus
end # Mack