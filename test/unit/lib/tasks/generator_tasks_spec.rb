require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent.parent + 'spec_helper'

describe "rake" do
  
  describe "generator" do
    
    describe "list" do
  
      it "should generate a list of tasks" do
        rake_task("generator:list") do
          ENV["__generator_list"].should_not be_nil

          if app_config.orm.nil?
            list = <<-LIST

Available Generators:

ControllerGenerator
	rake generate:controller
ControllerHelperGenerator
	rake generate:controller_helper
MackApplicationGenerator
	rake generate:mack_application
PluginGenerator
	rake generate:plugin
ViewHelperGenerator
	rake generate:view_helper


            LIST
          else
            list = <<-LIST

Available Generators:

MackApplicationGenerator
	rake generate:mack_application
MigrationGenerator
	rake generate:migration
ModelGenerator
	rake generate:model
PluginGenerator
	rake generate:plugin
ScaffoldGenerator
	rake generate:scaffold


            LIST
          end

          ENV["__generator_list"].should == list
        end
      end
      
    end
    
  end
  
end