require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'fileutils'

@options = OpenStruct.new
@options.environment = "development"
@options.port = 3000 # Does NOT work with Thin!! You must edit the thin.yml file!
@options.handler = "thin"
@options.daemonize = false

opts = OptionParser.new do |opts|
  opts.banner = "Usage: mackery <application_name> [options]"
  
  opts.on("-e [environment]") do |v|
    @options.environment = v
  end
  
  opts.on("-p [port]") do |v|
    @options.port = v
  end
  
  opts.on("-h [handler]") do |v|
    @options.handler = v
  end
  
  opts.on("-d [daemonize]") do |v|
    @options.daemonize = true
  end
  
end

@original_command_args = ARGV.dup

opts.parse!(ARGV)

ENV["MACK_ENV"] = @options.environment unless ENV["MACK_ENV"]

@mack_gem_version = nil

rakefile = File.read(File.join(FileUtils.pwd, 'Rakefile'))

begin
  @mack_gem_version = rakefile.match(/gem.['"]mack['"].+['"](.+)['"]/).captures.first
rescue Exception => e
end

# if @mack_gem_version
#   puts "Using Mack version: '#{@mack_gem_version}'"
# end
