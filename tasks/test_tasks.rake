require 'rake'
namespace :test do
  
  Rake::TestTask.new(:render) do |t|
    # Rake::Task["log:clear"].invoke
    t.libs << "test"
    t.pattern = 'test/rendering/*_test.rb'
    t.verbose = true
  end
  
end