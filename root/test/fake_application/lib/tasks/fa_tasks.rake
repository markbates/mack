task :t_env => :environment do
  puts "foo.to_param: #{"foo".to_param}"
  puts "app_config.mack.session_id: #{app_config.mack.session_id}"
end

task :t_no_env do
  puts "foo.to_param: #{"foo".to_param}"
end