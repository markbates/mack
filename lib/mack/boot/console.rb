require File.join(File.dirname(__FILE__), '..', '..', 'gems')

require 'mack-facets'

run_once do
  
  # This file gets loaded when you run:
  #   rake console
  # It loads the following classes to make using the application via the console easier:
  # 
  # * Mack::TestHelpers
  # * Mack::Routes::Urls

  fl = File.join_from_here('..')

  require File.join(fl, "..", "..", "bin", "gem_load_path.rb")

  require File.join(fl, "..", "mack.rb")

  require File.join(fl, "testing", "helpers.rb")

  # self.send(:include, Mack::TestHelpers)
  self.send(:include, Mack::Routes::Urls)

  # When using the Mack console if you edit any files
  # you can reload them in the console using this method
  # without having to exit the console and start again.
  def reload!
    ivar_cache("_rack_reloader") do
      Mack::Reloader.new(nil)
    end.reload!
  end

  # Prevent AutoRunner from getting executed when user exits out of console
  Test::Unit.run = true
  
  
end