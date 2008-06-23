require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "Generator Tasks" do
  it "should generate a list of tasks" do
    rake_task("generator:list") do
      ENV["__generator_list"].should_not be_nil

      if app_config.orm.nil?
        list = <<-LIST

Available Generators:

MackApplicationGenerator
	rake generate:mack_application_generator
PluginGenerator
	rake generate:plugin_generator


        LIST
      else
        list = <<-LIST

Available Generators:

MackApplicationGenerator
	rake generate:mack_application_generator
MigrationGenerator
	rake generate:migration_generator
ModelGenerator
	rake generate:model_generator
PluginGenerator
	rake generate:plugin_generator
ScaffoldGenerator
	rake generate:scaffold_generator


        LIST
      end

      ENV["__generator_list"].should == list
    end
  end
end
