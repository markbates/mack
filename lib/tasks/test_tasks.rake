desc "Run test code."
Rake::TestTask.new(:default) do |t|
  # Rake::Task["log:clear"].invoke
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

alias_task :test, :default
