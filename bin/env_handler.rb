if ARGV.include?("-e")
  ENV["MACK_ENV"] = ARGV[ARGV.index("-e") + 1] unless ENV["MACK_ENV"]
end

@mack_gem_version = nil
begin
  rakefile = File.read(File.join(FileUtils.pwd, 'Rakefile'))
  @mack_gem_version = rakefile.match(/gem.['"]mack['"].+['"](.+)['"]/).captures.first
rescue Exception => e
end