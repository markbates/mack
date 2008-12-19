require File.join_from_here('all_helpers')
module Mack
  module View
    module FormBuilder
      
      def self.included(base)
        klass = base.to_s
        klass = klass.match(/(.+)(Form|FormBuilder)$/).captures.first
        mod = Module.new do
          # define_method("#{klass.methodize}_form") do |*args, &block|
          #   # Thread.current[:view_template].form(*args) do
          #   #   yield base.new
          #   # end
          #   Thread.current[:view_template].form(*args, &block)
          # end
          eval %{
            def #{klass.methodize}_form(action, options = {}, &block)
              Thread.current[:view_template].form(action, options.merge(:builder => #{base}.new(self)), &block)
            end
          }
        end
        Mack::ViewHelpers::FormHelpers.class_eval do
          include mod
        end
        Mack::Rendering::ViewTemplate.class_eval do
          include mod
        end
      end # included
      
      def initialize(view)
        @_view = view
      end
      
      def view
        @_view
      end
      
      def all(sym, *args)
        return @_view.send(sym, *args)
      end
      
      def method_missing(sym, *args)
        return self.all(sym, *args)
      end
      
    end # FormBuilder
  end # View
end # Mack