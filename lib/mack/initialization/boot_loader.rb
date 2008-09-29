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
          raise e
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