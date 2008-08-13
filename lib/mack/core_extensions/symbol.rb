class Symbol
  
  def check_box(*args)
    puts caller.inspect
    fe = FormElement.new(*args)
  end
  
  def file_field(*args)
    
  end
  
  def hidden_field(*args)
    
  end
  
  def image_submit(*args)
    
  end
  
  def label(*args)
    
  end
  
  def radio_button(*args)
    
  end
  
  def select(*args)
    
  end
  
  def submit(*args)
    
  end
  
  def text_area(*args)
    
  end
  
  def text_field(*args)
    
  end
  
  private
  class FormElement
    attr_accessor :calling_method
    attr_accessor :options
    
    def initialize(*args)
      args = args.parse_splat_args
      case args
      when Symbol, String
        self.calling_method = args
      when Hash
        self.options = args
      when Array
        self.calling_method = args[0]
        self.options = args[1]
      when nil
        self.calling_method = :to_s
        self.options = {}
      else
        raise ArgumentError.new("You must provide either a Symbol, a String, a Hash, or a combination thereof.")
      end
    end
    
  end
  
end