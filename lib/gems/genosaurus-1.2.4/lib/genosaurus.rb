require 'rubygems'
require 'fileutils'
require 'erb'
require 'yaml'
require 'erubis'

class String
  def underscore
    camel_cased_word = self.dup
    camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
end

class Genosaurus

  include FileUtils
  
  class << self
    
    # Instantiates a new Genosaurus, passing the ENV hash as options into it, runs the generate method, and returns the Genosaurus object.
    def run(options = ENV.to_hash)
      gen = self.new(options)
      gen.generate
      gen
    end
    
    # Describes the generator.
    def describe
      text = ["#{self}:"]
      required_params.each do |p|
        text << "Required Parameter: '#{p.to_s.downcase}'"
      end
      dd = description_detail
      unless dd.nil? || dd == ''
        text << "---------------"
        text << dd
      end
      text.join("\n")
    end
    
    # Override this method in your generator to append to the describe method.
    def description_detail
      ''
    end
    
  end
  
  # Takes any options needed for this generator. If the generator requires any parameters an ArgumentError exception will be
  # raised if those parameters are found in the options Hash. The setup method is called at the end of the initialization.
  def initialize(options = {})
    unless options.is_a?(Hash)
      opts = [options].flatten
      options = {}
      self.class.required_params.each_with_index do |p, i|
        options[p.to_s] = opts[i]
      end
    end
    @options = options
    self.class.required_params.each do |p|
      raise ::ArgumentError.new("The required parameter '#{p.to_s.upcase}' is missing for this generator!") unless param(p)
    end
    @generator_name = self.class.name
    @generator_name_underscore = @generator_name.underscore #String::Style.underscore(@generator_name)#.underscore
    @templates_directory_path = nil
    @manifest_path = nil
    $".each do |f|
      if f.match(/#{@generator_name_underscore}\.rb$/)
        @templates_directory_path = File.join(File.dirname(f), "templates")
        @manifest_path = File.join(File.dirname(f), "manifest.yml")
      end
    end
    setup
  end
  
  # Returns the path to the templates directory.
  # IMPORTANT: The location of the templates_directory_path is VERY important! Genosaurus will attempt to find this location
  # automatically, HOWEVER, if there is a problem, or you want to be special, you can override this method in your generator
  # and have it return the correct path.
  def templates_directory_path
    @templates_directory_path
  end
  
  # Returns the path to the manifest.yml. This is only used if you have a manifest.yml file, if there is no file, or this
  # method returns nil, then an implied manifest is used based on the templates_directory_path contents.
  # IMPORTANT: Genosaurus will attempt to find this location automatically, HOWEVER, if there is a problem, or you want to 
  # be special, you can override this method in your generator and have it return the correct path.
  def manifest_path
    @manifest_path
  end
  
  # To be overridden in subclasses to do any setup work needed by the generator.
  def setup
    # does nothing, unless overridden in subclass.
  end
  
  # To be overridden in subclasses to do work before the generate method is run.
  def before_generate
  end
  
  # To be overridden in subclasses to do work after the generate method is run.
  # This is a simple way to call other generators.
  def after_generate
  end
  
  # Returns the manifest for this generator, which is used by the generate method to do the dirty work.
  # If there is a manifest.yml, defined by the manifest_path method, then the contents of that file are processed
  # with ERB and returned. If there is not manifest.yml then an implied manifest is generated from the contents
  # of the templates_directory_path.
  def manifest
    if templates_directory_path.nil? || manifest_path.nil?
      raise "Unable to dynamically figure out your templates_directory_path and manifest_path!\nPlease implement these methods and let Genosaurus know where to find these things. Thanks."
    end
    if File.exists?(manifest_path)
      # run using the yml file
      template = ERB.new(File.open(manifest_path).read, nil, "->")
      man = YAML.load(template.result(binding))
    else
      files = Dir.glob(File.join(templates_directory_path, "**/*.template"))
      man = {}
      files.each_with_index do |f, i|
        output_path = f.gsub(templates_directory_path, "")
        output_path.gsub!(".template", "")
        output_path.gsub!(/^\//, "")
        man["template_#{i+1}"] = {
          "type" => File.directory?(f) ? "directory" : "file",
          "template_path" => f,
          "output_path" => Erubis::Eruby.new(output_path, :pattern => '% %').result(binding)
        }
      end
    end
    # puts man.inspect
    man
  end
  
  # Used to define arguments that are required by the generator.
  def self.require_param(*args)
    required_params << args
    required_params.flatten!
  end
  
  # Returns the required_params array.
  def self.required_params
    @required_params ||= []
  end

  # Returns a parameter from the initial Hash of parameters.
  def param(key)
    (@options[key.to_s.downcase] ||= @options[key.to_s.upcase])
  end

  # Takes an input_file runs it through ERB and 
  # saves it to the specified output_file. If the output_file exists it will
  # be skipped. If you would like to force the writing of the file, use the
  # :force => true option.
  def template(input_file, output_file, options = @options)
    output_file = template_copy_common(output_file, options)
    unless output_file.nil?
      # File.open(output_file, "w") {|f| f.puts ERB.new(File.open(input_file).read, nil, "->").result(binding)}
      File.open(output_file, "w") {|f| f.puts ERB.new(input_file, nil, "->").result(binding)}
      puts "Wrote: #{output_file}"
    end
  end
  
  # Creates the specified directory.
  def directory(output_dir, options = @options)
    if $genosaurus_output_directory
      output_dir = File.join($genosaurus_output_directory, output_dir) 
    end
    if File.exists?(output_dir)
      puts "Exists: #{output_dir}"
      return
    end
    mkdir_p(output_dir)
    puts "Created: #{output_dir}"
  end
  
  def copy(input_file, output_file, options = @options)
    output_file = template_copy_common(output_file, options)
    FileUtils.cp(input_file, output_file)
    puts "Copied: #{output_file}"
  end
  
  # This does the dirty work of generation.
  def generate
    generate_callbacks do
      manifest.each_value do |info|
        case info["type"]
        when "file"
          template(File.open(info["template_path"]).read, info["output_path"])
        when "directory"
          directory(info["output_path"])
        when "copy"
          copy(info["template_path"], info["output_path"])
        else
          raise "Unknown 'type': #{info["type"]}!"
        end
      end
    end
  end
  
  def method_missing(sym, *args)
    p = param(sym)
    return p if p
    raise NoMethodError.new(sym)
  end
  
  private
  def generate_callbacks
    before_generate
    yield
    after_generate
  end
  
  def template_copy_common(output_file, options)
    # incase the directory doesn't exist, let's create it.
    directory(File.dirname(output_file))
    if $genosaurus_output_directory
      output_file = File.join($genosaurus_output_directory, output_file) 
    end
    if File.exists?(output_file)
      unless options[:force]
        puts "Skipped: #{output_file}"
        return nil
      end
    end
    output_file
  end
  
end # Genosaurus