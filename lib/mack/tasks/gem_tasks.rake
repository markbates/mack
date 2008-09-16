
namespace :gems do
  
  desc "lists all the gem required for this application."
  task :list do
    Mack::Utils::GemManager.instance.required_gem_list.each do |g|
      puts g
    end
  end # list
  
  desc "installs the gems needed for this application."
  task :install do
    Mack::Utils::GemManager.instance.required_gem_list.each do |g|
      params = ["install", g.name.to_s]
      params << "--version=#{g.version}" if g.version?
      params << "--source=#{g.source}" if g.source?
      sh "gem #{params.join(" ")}"
    end
  end # install
  
  task :freeze do
    puts "gems:freeze"
    add_dependencies = ENV['DEP'] || ENV['DEPS'] || 'false'
    Mack::Utils::GemManager.instance.required_gem_list.each do |g|
      version = g.version? ? g.version : '> 0.0.0'
      ENV['gem_name'] = g.name.to_s
      ENV['version'] = version
      sh('rake gems:install_and_freeze')
    end
  end
  
  task :install_and_freeze do
    require 'rubygems/gem_runner'
    require 'ruby-debug'
    
    add_dependencies = ENV['DEP'] || ENV['DEPS'] || false
    version = ENV['version'] || ENV['VERSION'] || ENV['ver'] || ENV['VER'] || '> 0.0.0'
    gem_name = ENV['gem_name']
    
    dep_msg = "and its dependencies" if add_dependencies
    puts "\nTask: freezing #{gem_name} #{dep_msg} to #{local_gem_dir}."
    puts "Phase 1: Collecting information..."
    collect_dependencies(gem_name, version)
    processed_gems.uniq!
    puts "Phase 2: Checking installation states..."
    check_installation
    puts "Phase 3: Freezing Gems..."
    freeze_gems
    # processed_gems.clear
    # check_installation(gem_name, version, add_dependencies)
    # processed_gems.clear
    # freeze_gem(gem_name, version, add_dependencies)
    puts "\nTotal of #{processed_gems.size} gems frozen to #{local_gem_dir}"
    
    puts "Phase 4: validating data..."
    processed_gems.each do |gem|
      msg "."
      if !File.exists?(File.join(local_gem_dir, gem.name))
        puts "  ** Warning: #{gem.name} was skipped"
      end
    end
    puts "Done."
  end
end # gem

private

def local_gem_dir
  dir = Mack::Paths.vendor('gems')
  mkdir(dir) if !File.exists?(dir)
  return dir
end

def processed_gems
  @gem_list ||= []
  return @gem_list
end

def collect_dependencies(gem_name, version)
  gem = LocalGem.new(gem_name, version)
  
  if !processed_gems.include?gem
    processed_gems << gem
    do_dependencies(gem_name, version) do |dep_gem|
      collect_dependencies(dep_gem.name, dep_gem.version_requirements.to_s)
    end
  end
end

def check_installation
  processed_gems.each do |gem|
    res = Gem.cache.search(/^#{gem.name}$/i, gem.version)
    if !res or res.empty?
      msg "  ** #{gem.name} not installed.  Installing #{gem.name} - #{gem.version}"
      # sh("sudo gem install #{gem_name} -v #{gem.version}")
    else
      msg "  ** #{gem.name} has been installed."
    end
  end
end

def freeze_gems
  processed_gems.each do |gem|
    if File.exists?(File.join(local_gem_dir, gem.name))
      msg "  ** #{gem.name} is already frozen, skipping it."
    else
      chdir(local_gem_dir) do
        begin
          Gem::GemRunner.new.run(["unpack", gem.name, "--version", gem.version])
          mv(Dir.glob("#{gem.name}*").first, gem.name)
        rescue Exception => ex
          puts ex
        end        
      end
    end
  end
end

def do_dependencies(gem_name, version = "> 0.0.0", &block)
  raise "Block expected!" if !block_given?
  source_indexes = Gem::SourceIndex.from_installed_gems
  deps = source_indexes.find_name(gem_name, version)[0].dependencies
  msg "  ** Found #{deps.size} dependencies for #{gem_name}"
  deps.each do |dep_gem|
    yield(dep_gem)
  end  
end

def msg(msg)
  verbose = ENV['VERBOSE'] || ENV['verbose'] || false
  puts msg if verbose
  print "." if !verbose
end

class LocalGem
  attr_accessor :name
  attr_accessor :version
  
  def initialize(name, version)
    self.name = name
    self.version = version
  end
  
  def to_s
    "#{name}-#{version}"
  end
  
  def ==(other)
    other.to_s == self.to_s
  end
  
  def eql?(other)
    puts "eql? called"
    other.to_s == self.to_s
  end
  
  def hash
    puts "hash is called"
    self.to_s.hash
  end
end