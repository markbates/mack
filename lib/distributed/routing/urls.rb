module Mack
  module Distributed
    module Routes
      # A class used to house the Mack::Routes::Url module for distributed applications.
      # Functionally this class does nothing, but since you can't cache a module, a class is needed.
      class Urls
        
        def initialize(dsd) # :nodoc:
          @dsd = dsd
          @url_method_list = {}
        end
        
        # def add_url_method(key, meth)
        #   @url_method_list[key.to_sym] = meth
        # end
        
        def []=(key, method)
          @url_method_list[key.to_sym] = method
          @runner = nil
        end
        
        def run
          if @runner.nil?
            klass_name = String.randomize(40).downcase.camelcase
            meths = ""
            @url_method_list.each_pair {|k,v| meths += v + "\n\n"}
            eval %{
              class Mack::Distributed::Routes::Temp::M#{klass_name}
                include Mack::Routes::Urls
                def initialize(dsd)
                  @dsd = dsd
                end
                #{meths}
              end
            }
            @runner = "Mack::Distributed::Routes::Temp::M#{klass_name}".constantize.new(@dsd)
          end
          @runner
        end
        
      end # Urls
      
      module Temp # :nodoc:
      end # Temp
      
    end # Routes
  end # Distributed
end # Mack