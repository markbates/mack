desc "Run test code."
Rake::TestTask.new(:default) do |t|
  # Rake::Task["log:clear"].invoke
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

namespace :test do
  
  task :empty do |t|
    ENV["TEST:EMPTY"] = "true"
    puts ENV["TEST:EMPTY"]
  end
  
  task :raise_exception do |t|
    raise "Oh No!"
  end
  
end

alias_task :test, :default
