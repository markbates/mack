module Mack
  
  module Portlet # :nodoc:
    
    class << self
      
      attr_accessor :portlet_spec # :nodoc:
      
      def clean # :nodoc:
        FileUtils.rm_rf(Mack::Paths.portlet_package, :verbose => configatron.mack.portlet.verbose)
      end
    
      def prepare # :nodoc:
        unless File.exists?(Mack::Paths.portlet_config)
          PortletGenerator.run
        end
        load Mack::Paths.portlet_config('portlet.spec')
        FileUtils.mkdir_p(Mack::Paths.portlet_package('lib'), :verbose => configatron.mack.portlet.verbose)
        files = []
        File.open(Mack::Paths.portlet_package('lib', "#{@portlet_spec.name}.rb"), 'w') do |f|
          
          f.puts %{
Mack.add_search_path(:app, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'app'))
Mack.add_search_path(:controllers, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'app', 'controllers'))
Mack.add_search_path(:helpers, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'app', 'helpers'))
Mack.add_search_path(:models, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'app', 'models'))
Mack.add_search_path(:views, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'app', 'views'))
Mack.add_search_path(:config, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'config'))
Mack.add_search_path(:configatron, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'config', 'configatron'))
Mack.add_search_path(:initializers, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'config', 'initializers'))
Mack.add_search_path(:db, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'db'))
Mack.add_search_path(:lib, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'lib'))
Mack.add_search_path(:public, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'public'))
Mack.add_search_path(:vendor, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'vendor'))
Mack.add_search_path(:plugins, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}', 'vendor', 'plugins'))

Mack.set_base_path(:#{@portlet_spec.name}, File.join(File.dirname(__FILE__), '#{@portlet_spec.name}'))
          }.strip
          
        end # File.open
        
        files << Dir.glob(Mack::Paths.app('**/*.*'))
        files << Dir.glob(Mack::Paths.config('**/*.*'))
        files << Dir.glob(Mack::Paths.db('**/*.*'))
        files << Dir.glob(Mack::Paths.lib('**/*.*'))
        files << Dir.glob(Mack::Paths.public('**/*.*'))
        files << Dir.glob(Mack::Paths.plugins('**/*.*'))
        
        files.flatten.compact.uniq.each do |file|
          copy_file(file)
        end
        
        Dir.glob(Mack::Paths.bin('**/*')).each do |file|
          copy_bin_file(file)
        end
        
        copy_bin_file(Mack::Paths.root('README'))
        
      end # prepare
      
      def package # :nodoc:
        FileUtils.rm_rf(Mack::Paths.root('pkg'), :verbose => configatron.mack.portlet.verbose)
        FileUtils.cd(Mack::Paths.portlet_package, :verbose => configatron.mack.portlet.verbose)
        load Mack::Paths.portlet_config('portlet.spec')
        Rake::GemPackageTask.new(Mack::Portlet.portlet_spec) do |pkg|
          pkg.need_zip = configatron.mack.portlet.need_zip
          pkg.need_tar = configatron.mack.portlet.need_tar
          pkg.package_dir = Mack::Paths.root('pkg')
        end
        Rake::Task['package'].invoke
        FileUtils.cd(Mack.root, :verbose => configatron.mack.portlet.verbose)
      end
      
      private
      def copy_file(file)
        n_path = file.gsub(Mack.root, '')
        n_path = Mack::Paths.portlet_package('lib', @portlet_spec.name, n_path)
        FileUtils.mkdir_p(File.dirname(n_path), :verbose => configatron.mack.portlet.verbose)
        FileUtils.cp(file, n_path, :verbose => configatron.mack.portlet.verbose)
      end
      
      def copy_bin_file(file)
        n_path = file.gsub(Mack.root, '')
        n_path = Mack::Paths.portlet_package(n_path)
        FileUtils.mkdir_p(File.dirname(n_path), :verbose => configatron.mack.portlet.verbose)
        FileUtils.cp(file, n_path, :verbose => configatron.mack.portlet.verbose)
      end
      
    end # class << self
    
  end # Portlet
  
end # Mack