require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'
require 'application_configuration'

require File.join(File.dirname(__FILE__), "initialization", "configuration.rb")

require 'mack_core'
require File.join(Mack.root, "config", "initializers", "gems.rb")
Mack::Utils::GemManager.instance.do_requires

orm = app_config.orm
unless orm.nil?
  Mack.logger.warn %{
    Please note that setting up orm in app_config has been deprecated, and will not be supported in future mack releases.
    Here's how to update your existing application:
    1.  Remove the line:
        orm: data_mapper
        from the app_config/default.yml file
    2.  In gem.rb, add the following line in the require_gems block:
        gem.add "mack-data_mapper", :version => "0.6.0", :libs => ["mack-data_mapper"]
        ** if you use active record, then change it to mack-active_record instead of mack-data_mapper
    }
  require "mack-#{orm}_tasks"
end

# Requires all rake tasks that ship with the Mack framework.
[File.join(File.dirname(__FILE__)), File.join(FileUtils.pwd, "lib"), File.join(FileUtils.pwd, "vendor", "plugins")].each do |dir|
  begin
    require File.join(dir, "tasks", "rake_helpers.rb")
  rescue Exception => e
  end
  files = Dir.glob(File.join(dir, "**/*.rake"))
  files.each do |f|
    unless f == __FILE__
      load f
    end
  end
end