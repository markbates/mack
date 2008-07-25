module Mack
  module RakeHelpers
    
    # Allows the aliasing and chaining of Rake tasks.
    # 
    # Examples:
    #   alias_task :server, "log:clear", "script:server"
    #   alias_task "server:start", "log:clear", "script:server"
    def alias_task(name, *args)
      ts = [args].flatten
      ts = ts.collect {|x| "'#{x}'"}.join(", ")
      ts = "[#{ts}]"
      n_task = %{
        desc "Alias: #{name} => #{ts}"
        task "#{name}" => #{ts} do |t|
        end
      }
      eval(n_task)
    end
    
  end # RakeHelpers
end # Mack

self.send(:include, Mack::RakeHelpers)