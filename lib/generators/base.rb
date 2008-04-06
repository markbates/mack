module Mack
  module Generator # :nodoc:
    # All generator classes should extend this class if they're expected to be used by the rake generate:<generator_name> task.
    # A generator must by name in the following style: <name>Generator. 
    # 
    # Example:
    #   class MyCoolGenerator < Mack::Generator::Base
    #     require_param :name, :foo
    #     
    #     def generate
    #       # do work...
    #     end
    #   end
    # 
    #   rake generate:my_cool # => calls MyCoolGenerator
    class Base

      include FileUtils
      
      # Used to define arguments that are required by the generator.
      def self.require_param(*args)
        required_params << args
        required_params.flatten!
      end
      
      # Returns the required_params array.
      def self.required_params
        @required_params ||= []
      end
      
      # Takes a Hash of parameters.
      # Raise Mack::Errors::RequiredGeneratorParameterMissing if a required parameter
      # is missing.
      def initialize(env = {})
        @env = env
        self.class.required_params.each do |p|
          raise Mack::Errors::RequiredGeneratorParameterMissing.new(p) unless param(p)
        end
      end
      
      # Runs the generate method.
      def run
        generate
      end
      
      # Returns a parameter from the initial Hash of parameters.
      def param(key)
        (@env[key.to_s.downcase] ||= @env[key.to_s.upcase])
      end
      
      # Needs to be implemented by the subclass.
      needs_method :generate
      
      # Takes an input_file runs it through ERB and 
      # saves it to the specified output_file. If the output_file exists it will
      # be skipped. If you would like to force the writing of the file, use the
      # :force => true option.
      def template(input_file, output_file, options = {})
        if File.exists?(output_file)
          unless options[:force]
            puts "Skipped: #{output_file}"
            return
          end
        end
        File.open(output_file, "w") {|f| f.puts ERB.new(File.open(input_file).read).result(binding)}
        puts "Wrote: #{output_file}"
      end
      
      # Creates the specified directory.
      def directory(output_dir, options = {})
        if File.exists?(output_dir)
          puts "Exists: #{output_dir}"
          return
        end
        mkdir_p(output_dir)
        puts "Created: #{output_dir}"
      end
      
    end # Base
  end # Generator
end # Mack