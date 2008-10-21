require File.join(File.dirname(__FILE__), 'routing', 'urls')
require File.join(File.dirname(__FILE__), 'application')
module Mack
  class Runner # :nodoc:

    def call(env) # :nodoc:
      Mack::Application.new.call(env)
    end
    
  end # Runner
end # Mack