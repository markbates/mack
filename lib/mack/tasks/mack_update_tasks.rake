namespace :mack do
  
  namespace :update do
    
    desc "Convert application configuration yml file into Configatron file"
    task :configuration do
      file = ENV['FILE'] || ENV['file'] || File.join(Mack.root, "config", "app_config")
      raise "Cannot find: #{file}" if !File.exists?(file)
      if File.directory?(file)
        Dir.glob(File.join(file, "**", "*.yml")).each do |f|
          convert_config_file(f)
        end
      else
        raise "Cannot convert non-yml file: #{file}" if File.extname(file) != ".yml"
        convert_config_file(file)
      end
      
      puts "\nPlease note that you still have access to the pre-converted yml file(s)."
    end
    
    
    
  #   desc "Renames thin.ru to rackup.ru and updates your thin.yml, if necessary."
  #   task :rackup do
  #     require 'fileutils'
  #     ru = File.join(Mack.root, "config", "thin.ru")
  #     if File.exists?(ru)
  #       FileUtils.mv(ru, File.join(Mack.root, "config", "rackup.ru"))
  #     end
  #     thin_yml = File.join(Mack.root, "config", "thin.yml")
  #     if File.exists?(thin_yml)
  #       contents = File.open(thin_yml).read
  #       contents.gsub!("thin.ru", "rackup.ru")
  #       File.open(thin_yml, "w") do |f|
  #         f.puts contents
  #       end
  #     end
  #   end
  
  end
  
end
# alias_task "mack:update", "mack:update:rackup"

private 

# ----- Helper methods for Configuration Updater -------- #
def convert_config_file(file)
  print "Converting: #{File.basename(file)}..."
  dest_file = file.gsub(".yml", ".rb").gsub('app_config', 'configatron')
  bak_file  = file
  hash = YAML.load(File.read(file))
  config_list = (hash) ? hash_to_configatron(hash) : []
  data = ""
  config_list.each do |line|
    line = update_data(line)
    data += (line + "\n")
  end
  FileUtils.mkdir_p(File.dirname(dest_file))
  File.open(dest_file, "w") { |f| f.write(data.to_s) }
  puts "done."
end

def update_data(old_data)
  updates = {
    "configatron.log_level" => "configatron.log.level",
    "configatron.run_remote_tests" => "configatron.mack.run_remote_tests",
    "configatron.log.db_color" => "configatron.log.colors.db",
    "configatron.log.error_color" => "configatron.log.colors.error",
    "configatron.log.completed_color" => "configatron.log.colors.completed",
    "configatron.base_language" => "configatron.mack.localization.base_language",
    "configatron.supported_languages" => "configatron.mack.localization.supported_languages",
    "configatron.char_encoding" => "configatron.mack.localization.char_encoding",
    "configatron.dynamic_translation" => "configatron.mack.localization.dynamic_translation",
    "configatron.content_expiry" => "configatron.mack.localization.content_expiry",
    "configatron.mack.share_routes" => "configatron.mack.distributed.share_routes",
    "configatron.mack.share_objects" => "configatron.mack.distributed.share_objects",
    "configatron.mack.share_views" => "configatron.mack.distributed.share_views",
    "configatron.mack.distributed_app_name" => "configatron.mack.distributed.app_name",
    "configatron.mack.distributed_site_domain" => "configatron.mack.distributed.site_domain",
    "configatron.mack.drb_timeout" => "configatron.mack.distributed.timeout"
  }
  
  key = old_data.split("=").first
  if updates.has_key?(key)
    return old_data.gsub(key, updates[key])
  else
    return old_data
  end
end

def cleanup_key(key)
  if key.is_a?Symbol
    mod_key = key.to_s.gsub("::", ".").to_sym
  else
    mod_key = key.gsub("::", ".")
  end
end

def hash_to_configatron(hash, configs = [], current_config = "configatron")
  hash.each_key do |key|
    if hash[key].is_a?Hash
      hash_to_configatron(hash[key], configs, (current_config + ".#{cleanup_key(key)}"))
    else
      configs << current_config + ".#{cleanup_key(key)} = #{hash[key].inspect}"
    end
  end
  return configs
end
# ----- END:: Helper methods for Configuration Updater -------- #
