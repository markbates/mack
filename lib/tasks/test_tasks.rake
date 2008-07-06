require 'rake'
require 'pathname'
require 'spec'
require 'spec/rake/spectask'

task :default  => "test:rspec" #["test:test_case", "test:spec"]

namespace :test do
  
  desc "Run test code."
  Rake::TestTask.new(:test_case) do |t|
    # Rake::Task["log:clear"].invoke
    t.libs << "test"
    t.pattern = 'test/**/*_test.rb'
    t.verbose = true
  end
  
  desc 'Run specifications'
  Spec::Rake::SpecTask.new(:rspec) do |t|
    t.spec_opts << '--options' << 'test/spec.opts' if File.exists?('test/spec.opts')
    t.spec_files = Dir.glob('test/**/*_spec.rb')
  end
  
  desc "Report code statistics (KLOCs, etc) from the application. Requires the rcov gem."
  task :stats do |t|
    x = `rcov test/**/*_test.rb -T --no-html -x Rakefile,config\/`
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
    `rcov test/**/*_test.rb -x Rakefile,config\/`
    `open coverage/index.html`
  end
  
  task :empty do |t|
    ENV["TEST:EMPTY"] = "true"
  end
  
  task :raise_exception do |t|
    raise "Oh No!"
  end
  
end


# alias_task :default, ["test:test_case", "test:spec"]
alias_task :stats, "test:stats"
alias_task :coverage, "test:coverage"
