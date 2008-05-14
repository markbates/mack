module Mack
  module Rendering
    module Engines
      class Registry
        include Singleton
      
        attr_reader :engines
      
        def initialize
          @engines = {
            :action => [{:engine => :erubis, :extension => :erb}],
            :partial => [{:engine => :erubis, :extension => :erb}],
            :layout => [{:engine => :erubis, :extension => :erb}],
            :public => [{:engine => :public}],
            :text => [{:engine => :text}],
            :url => [{:engine => :url}],
            :xml => [{:engine => :builder}],
            :inline => [{:engine => :erubis}]
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