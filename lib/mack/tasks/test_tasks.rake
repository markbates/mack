require 'rake'
require 'pathname'
require 'spec'
require 'spec/rake/spectask'
require 'fileutils'
require 'mack-facets'
namespace :test do
  
  task :setup do
  end
  
  desc "Run test code."
  Rake::TestTask.new(:test_case) do |t|
    require File.join_from_here('..', 'boot', 'configuration.rb')
    t.libs << 'test'
    t.pattern = configatron.mack.send("#{configatron.mack.testing_framework}_file_pattern")
    t.verbose = true
  end
  
  desc 'Run specifications'
  Spec::Rake::SpecTask.new(:rspec) do |t|
    require File.join_from_here('..', 'boot', 'configuration.rb')
    t.spec_opts << '--options' << 'test/spec.opts' if File.exists?('test/spec.opts')
    t.spec_files = Dir.glob(configatron.mack.send("#{configatron.mack.testing_framework}_file_pattern"))
  end
  
  desc "Report code statistics (KLOCs, etc) from the application. Requires the rcov gem."
  task :stats do |t|
    res = common_coverage
    res.each do |line|
      case line
      when /^\+[\+\-]*\+$/, /^\|.*\|$/, /\d+\sLines\s+\d+\sLOC/
        puts line
      end
    end
  end
  
  desc "Generates test coverage from the application. Requires the rcov gem."
  task :coverage do |t|
    common_coverage

    unless PLATFORM['i386-mswin32'] 
      system("open coverage/index.html") if PLATFORM['darwin'] 
    else 
      system("\"C:/Program Files/Mozilla Firefox/firefox.exe\" " + 
      "coverage/index.html") 
    end
  end
  
  task :empty do |t|
    ENV["TEST:EMPTY"] = "true"
  end
  
  task :raise_exception do |t|
    raise "Oh No!"
  end
  
  private
  def common_coverage
    ENV['MACK_ENV'] = 'test'
    Rake::Task["mack:environment"].invoke
    Rake::Task["test:setup"].invoke
    
    rm_f Mack::Paths.root("coverage")
    rm_f Mack::Paths.root("coverage.data")
    unless PLATFORM['i386-mswin32'] 
      rcov = "rcov --sort coverage --rails --aggregate coverage.data " + 
      "--text-summary -Ilib -T -x gems/*,rcov*,lib/tasks/*,Rakefile" 
    else 
      rcov = "rcov.cmd --sort coverage --rails --aggregate coverage.data " + 
      "--text-summary -Ilib -T" 
    end
    
    puts "Generating... please wait..."
    res = `#{rcov} --html #{configatron.mack.send("#{configatron.mack.testing_framework}_file_pattern")}`
    res
  end
  
end

task :default do
  require File.join_from_here('..', 'boot', 'configuration.rb')
  tf = "rspec"
  begin
    tf = configatron.mack.testing_framework
  rescue Exception => e
  end
  Rake::Task["test:setup"].invoke
  Rake::Task["test:#{tf}"].invoke
end

alias_task :stats, "test:stats"
alias_task :coverage, "test:coverage"
