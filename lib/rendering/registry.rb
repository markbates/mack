module Mack
  module Rendering
    module Engines
      class Registry
        include Singleton
      
        attr_reader :engines
      
        def initialize
          @engines = {
            :action => [{:engine => Mack::Rendering::Engines::Erb, :extension => :erb}],
            :partial => [{:engine => Mack::Rendering::Engines::Erb, :extension => :erb}],
            :layout => [{:engine => Mack::Rendering::Engines::Erb, :extension => :erb}],
            :public => [{:engine => Mack::Rendering::Engines::Public}],
            :text => [{:engine => Mack::Rendering::Engines::Text}],
            :url => [{:engine => Mack::Rendering::Engines::Url}],
            :xml => [{:engine => Mack::Rendering::Engines::Builder, :extension => :builder}]
          }
        end
      
        def register(type, options = {})
          type = type.to_sym
          if self.engines.has_key?(type)
            self.engines[type].insert(0, options)
          else
            self.engines[type] = [options]
          end
        end
      
        class << self
        
          def method_missing(sym, *args)
            Mack::Rendering::Engines::Registry.instance.send(sym, *args)
          end
        
        end
      end # Registry
    end # Engines
  end # Rendering
end # Mack