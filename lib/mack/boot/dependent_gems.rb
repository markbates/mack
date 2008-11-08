run_once do
  Dir.glob(File.join(File.dirname(__FILE__), 'gems', '*')).each do |gem|
    puts "File.expand_path(File.join(gem, 'lib')): #{File.expand_path(File.join(gem, 'lib'))}"
    $:.insert(0, File.expand_path(File.join(gem, 'lib')))
  end
end