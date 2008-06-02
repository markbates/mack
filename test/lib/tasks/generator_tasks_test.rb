# require File.dirname(__FILE__) + '/../../test_helper.rb'
# 
# class GeneratorTasksTest < Test::Unit::TestCase
#   
#   def test_list
#     rake_task("generator:list") do
#       assert_not_nil ENV["__generator_list"]
#       list = <<-LIST
# 
# Available Generators:
# 
# MackApplicationGenerator
#   rake generate:mack_application_generator
# MigrationGenerator
#   rake generate:migration_generator
# ModelGenerator
#   rake generate:model_generator
# PluginGenerator
#   rake generate:plugin_generator
# ScaffoldGenerator
#   rake generate:scaffold_generator
# 
# 
# LIST
#       assert_equal list, ENV["__generator_list"]
#     end
#   end
#   
# end