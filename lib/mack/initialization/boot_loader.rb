module Kernel
  
  def boot_load(name, *dependencies, &block)
    Mack::BootLoader.instance.add(name, *dependencies, &block)
  end
  
end


module Mack
  class BootLoader
    include Singleton
    
    attr_accessor :sequences
    
    def initialize
      self.sequences = {}
    end
    
    def add(name, *dependencies, &block)
      self.sequences[name.to_sym] = Mack::BootLoader::Loader.new(name.to_sym, *dependencies, &block)
    end
    
    def self.run(*args)
      args.each do |a|
        begin
          Mack::BootLoader.instance.sequences[a.to_sym].run
        rescue Exception => e
          puts "[#{a}]: #{e.message}"
          puts e.backtrace
        end
      end
    end
    
    def self.run!(*args)
      args.each do |a|
        Mack::BootLoader.instance.sequences[a.to_sym].run!
      end
    end
    
    private
    class Loader
      
      attr_accessor :name
      attr_accessor :dependencies
      attr_accessor :sequence
      
      def initialize(name, *dependencies, &block)
        self.name = name.to_sym
        self.dependencies = dependencies
        self.sequence = block
        @run = false
      end
      
      def run
        return if @run
        self.dependencies.each do |dep|
          Mack::BootLoader.run(dep)
        end
        self.sequence.call
        @run = true
      end
      
      def run!
        self.dependencies.each do |dep|
          Mack::BootLoader.run!(dep)
        end
        self.sequence.call
      end
      
    end
  end
end

# module Mack
#   class BootLoader
#     include Singleton
#     include Extlib::Hook
#     
#     attr_accessor :steps
#     attr_accessor :additional_procs
#     
#     def initialize
#       self.steps = [:initializers, :gems, :plugins, :libs, :default_controller, :routes, :app, :additional]
#       self.additional_procs = []
#     end
#     
#     def start
#       Mack.logger.debug "Starting boot loader sequence...."
#     end
#     
#     def initializers
#       # set up initializers:
#       Mack.logger.debug "Initializing custom initializers..." unless configatron.log.disable_initialization_logging
#       Dir.glob(Mack::Paths.initializers("**/*.rb")) do |d|
#         require d
#       end
#     end
#     
#     def gems
#       Mack.logger.debug "Initializing custom gems..." unless configatron.log.disable_initialization_logging
#       Mack::Utils::GemManager.instance.do_requires
#     end
#     
#     def plugins
#       # require 'plugins':
#       Mack.logger.debug "Initializing plugins..." unless configatron.log.disable_initialization_logging
#       require File.join(File.dirname(__FILE__), "plugins.rb")
#     end
#     
#     def libs
#       # require 'lib' files:
#       Mack.logger.debug "Initializing lib classes..." unless configatron.log.disable_initialization_logging
#       Dir.glob(Mack::Paths.lib("**/*.rb")).each do |d|
#         require d
#       end
#     end
#     
#     def default_controller
#       # make sure that default_controller is available to other controllers
#       path = Mack::Paths.controllers("default_controller.rb")
#       require path if File.exists?(path)
#     end
#     
#     def routes
#       # set up routes:
#       Mack.logger.debug "Initializing routes..." unless configatron.log.disable_initialization_logging
#       require Mack::Paths.config("routes")
#     end
#     
#     def app
#       # require 'app' files:
#       Mack.logger.debug "Initializing 'app' classes..." unless configatron.log.disable_initialization_logging
#       Dir.glob(Mack::Paths.app("**/*.rb")).each do |d|
#         # puts "d: #{d}"
#         begin
#           require d
#         rescue NameError => e
#           if e.message.match("uninitialized constant")
#             mod = e.message.gsub("uninitialized constant ", "")
#             x =%{
#               module ::#{mod}
#               end
#             }
#             eval(x)
#             require d
#           else
#             raise e
#           end
#         end
#       end
#     end
#     
#     def additional
#       self.additional_procs.each do |p|
#         puts "p: #{p.inspect}"
#         p.call
#       end
#     end
#     
#     def finish
#       Mack.logger.debug "...Finished boot loader sequence."
#     end
#     
#     def self.run
#       Mack::BootLoader.instance.start
#       Mack::BootLoader.instance.steps.each do |step|
#         Mack::BootLoader.instance.send(step)
#       end
#       Mack::BootLoader.instance.finish
#     end
#     
#   end
# end