namespace :mack do
  
  namespace :update do
    
    desc "Renames thin.ru to rackup.ru and updates your thin.yml, if necessary."
    task :rackup do
      require 'fileutils'
      ru = File.join(Mack::Configuration.config_directory, "thin.ru")
      if File.exists?(ru)
        FileUtils.mv(ru, File.join(Mack::Configuration.config_directory, "rackup.ru"))
      end
      thin_yml = File.join(Mack::Configuration.config_directory, "thin.yml")
      if File.exists?(thin_yml)
        contents = File.open(thin_yml).read
        contents.gsub!("thin.ru", "rackup.ru")
        File.open(thin_yml, "w") do |f|
          f.puts contents
        end
      end
    end
  
  end
  
end

alias_task "mack:update", "mack:update:rackup"