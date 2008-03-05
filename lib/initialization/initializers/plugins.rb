plugins = [] # a list of all plugins
Dir.glob(File.join(MACK_PLUGINS, "*")).each do |d|
  plugins << d
  $: << File.join(d, "lib") # add the lib for this plugin to the global load path
end
plugins.sort.each do |plug|
  begin
    require File.join(plug, "init.rb") # load the init.rb for each plugin.
  rescue Exception => e
    puts e.message
  end
  $:.delete(File.join(plug, "lib")) # remove the plugins lib directory from the global load path.
end