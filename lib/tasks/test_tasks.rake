desc "Run test code."
Rake::TestTask.new(:default) do |t|
  # Rake::Task["log:clear"].invoke
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

namespace :test do
  
  desc "Report code statistics (KLOCs, etc) from the application. Requires the rcov gem."
  task :stats do |t|
    x = `rcov test/**/*_test.rb -T --no-html`
    @print = false
    x.each do |line|
      puts line if @print
      unless @print
        if line.match(/\d+ tests, \d+ assertions, \d+ failures, \d+ errors/)
          @print = true
        end
      end
    end
  end
  
  desc "Generates test coverage from the application. Requires the rcov gem."
  task :coverage do |t|
    `rcov test/**/*_test.rb`
    `open coverage/index.html`
  end
  
  task :empty do |t|
    ENV["TEST:EMPTY"] = "true"
    puts ENV["TEST:EMPTY"]
  end
  
  task :raise_exception do |t|
    raise "Oh No!"
  end
  
end

alias_task :test, :default
alias_task :stats, "test:stats"
alias_task :coverage, "test:coverage"
