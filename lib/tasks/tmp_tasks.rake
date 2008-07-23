namespace :tmp do
  
  desc "Clears out your tmp directory"
  task :clear do
    FileUtils.rm_rf(File.join(FileUtils.pwd, "tmp"))
  end
  
end