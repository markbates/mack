namespace :gem do
  
  task :list do
    
    puts Mack::Utils::GemManager.instance.required_gem_list
  end # list
  
  task :install do
    
  end # install
  
end # gem