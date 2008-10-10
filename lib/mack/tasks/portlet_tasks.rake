require 'rake/gempackagetask'
namespace :mack do
  
  namespace :portlet do
    
    desc 'Removes any generated portlet files.'
    task :clean => :environment do
      Mack::Portlet.clean
    end
    
    desc 'Prepares your application to become a portlet.'
    task :prepare => [:clean] do
      Mack::Portlet.prepare
    end
    
    desc 'Packages up your application into a portlet gem.'
    task :package => [:prepare] do
      Mack::Portlet.package
    end
    
    desc 'Installs your application as a portlet gem.'
    task :install => :package do
      sudo = ENV['SUDOLESS'] == 'true' || RUBY_PLATFORM =~ /win32|cygwin/ ? '' : 'sudo'
      puts `#{sudo} gem install #{Mack::Paths.root('pkg', Mack::Portlet.portlet_spec.name)}-#{Mack::Portlet.portlet_spec.version}.gem --no-update-sources`
    end
    
  end
  
end