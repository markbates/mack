class GemHelper # :nodoc:
  include Singleton
  
  attr_accessor :project
  attr_accessor :package
  attr_accessor :gem_name
  attr_accessor :version
  
  def initialize
    self.project = "magrathea"
    self.package = "mack"
    self.gem_name = "mack"
    self.version = "0.4.6.100"
  end
  
  def gem_name_with_version
    "#{self.gem_name}-#{self.version}"
  end
  
  def full_gem_name
    "#{self.gem_name_with_version}.gem"
  end
  
  def release
    begin
      rf = RubyForge.new
      rf.login
      begin
        rf.add_release(self.project, self.package, self.version, File.join("pkg", full_gem_name))
      rescue Exception => e
        if e.message.match("Invalid package_id") || e.message.match("no <package_id> configured for")
          puts "You need to create the package!"
          rf.create_package(self.project, self.package)
          rf.add_release(self.project, self.package, self.version, File.join("pkg", full_gem_name))
        else
          raise e
        end
      end
    rescue Exception => e
      puts e
    end
  end
  
  def install
    puts `sudo gem install #{File.join("pkg", full_gem_name)}`
  end
  
end