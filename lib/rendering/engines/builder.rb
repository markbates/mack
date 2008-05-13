module Mack
  module Rendering
    module Engines
      class Builder < Mack::Rendering::Engines::Base
        
        def initialize(view_template, engine_settings)
          super
          @xml_output = ""
          @xml = ::Builder::XmlMarkup.new(:target => @xml_output, :indent => 1)
          view_template.instance_variable_set("@xml", @xml)
        end
        
        def render
          find_file(self.view_template.controller_view_path, "#{self.view_template.engine_type_value}.#{self.view_template.options[:format]}.#{self.engine_settings[:extension]}") do |f|
            return eval(File.open(f).read, self.view_template.binder)
          end
        end
        
      end # Erb
    end # Engines
  end # Rendering
end # Mack