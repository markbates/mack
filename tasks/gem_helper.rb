require File.join(File.dirname(__FILE__), "..", "lib", "mack", "version")
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
    self.version = Mack::VERSION
  end
  
  def gem_name_with_version
    "#{self.gem_name}-#{self.version}"
  end
  
  def full_gem_name
    "#{self.gem_name_with_version}.gem"
  end
  
  def release
    begin
      ac_path = File.join(ENV["HOME"], ".rubyforge", "auto-config.yml")
      if File.exists?(ac_path)
        fixed = File.open(ac_path).read.gsub("  ~: {}\n\n", '')
        fixed.gsub!(/    !ruby\/object:Gem::Version \? \n.+\n.+\n\n/, '')
        puts "Fixing #{ac_path}..."
        File.open(ac_path, "w") {|f| f.puts fixed}
      end
      rf = RubyForge.new
      rf.configure
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
      if e.message == "You have already released this version."
        puts e
      else
        raise e
      end
    end
  end
  
  def install
    sudo = ENV['SUDOLESS'] == 'true' || RUBY_PLATFORM =~ /win32|cygwin/ ? '' : 'sudo'
    sh %{#{sudo} gem install --local #{File.join("pkg", full_gem_name)} --no-update-sources}
  end
  
end