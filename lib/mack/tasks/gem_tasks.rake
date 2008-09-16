
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
    puts "\Freezing: #{gem_name} #{dep_msg} to #{local_gem_dir}.  This could take a while."
    processed_gems.clear
    check_installation(gem_name, version, add_dependencies)
    processed_gems.clear
    freeze_gem(gem_name, version, add_dependencies)
    puts "Done"
  end
end # gem

private

def local_gem_dir
  dir = Mack::Paths.vendor('gems')
  mkdir(dir) if !File.exists?(dir)
  return dir
end

def freeze_gem(gem_name, version, add_dep = false)
  msg "  ** Freezing #{gem_name}" # and its dependencies"
  if File.exists?(File.join(local_gem_dir, gem_name))
    msg "  ** #{gem_name} is already frozen, skipping it."
  else
    chdir(local_gem_dir) do
      begin
        Gem::GemRunner.new.run(["unpack", gem_name, "--version", version])
        mv(Dir.glob("#{gem_name}*").first, gem_name)

        if !processed_gems.include?(gem_name) # prevent circular dependencies
          processed_gems << gem_name 
          do_dependencies(gem_name) do |dep_gem|
            freeze_gem(dep_gem.name, dep_gem.version_requirements.to_s, add_dep)
          end if add_dep
        end
      rescue Exception => ex
        puts ex
      end
    end
  end  
end

def processed_gems
  @gem_list ||= []
  return @gem_list
end

def check_installation(gem_name, version = "> 0.0.0", add_dep = false)
  msg "  ** Checking to see if #{gem_name} is already installed **"
  res = Gem.cache.search(gem_name)
  if !res or res.empty?
    msg "  ** ** #{gem_name} not installed.  Installing #{gem_name}"
    sh("sudo gem install #{gem_name}")
  else
    msg "  ** ** #{gem_name} has been installed."
  end

  if !processed_gems.include?(gem_name) # prevent circular dependencies
    processed_gems << gem_name
    do_dependencies(gem_name) do |dep_gem|
      check_installation(dep_gem.name, dep_gem.version_requirements, add_dep)
    end if add_dep
  end
end

def do_dependencies(gem_name, &block)
  raise "Block expected!" if !block_given?
  source_indexes = Gem::SourceIndex.from_installed_gems
  deps = source_indexes.search(gem_name)[0].dependencies
  msg "  ** ** Found #{deps.size} dependencies for #{gem_name}"
  deps.each do |dep_gem|
    yield(dep_gem)
  end  
end

def msg(msg)
  verbose = ENV['VERBOSE'] || ENV['verbose'] || false
  puts msg if verbose
  print "." if !verbose
end