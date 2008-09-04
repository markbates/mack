# require the core classes:

# puts "Loading mack from: #{File.dirname(__FILE__)}"

require File.join(File.dirname(__FILE__), 'mack_core')

# load the environment:
Mack::Environment.load