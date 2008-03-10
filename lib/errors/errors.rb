module Mack
  module Errors # :nodoc:
    
    # Raised when someone calls render twice in one action
    # 
    # Example:
    #   class FooController < Mack::Controller::Base
    #     def index
    #       render(:text => "Hello World")
    #       render(:action => "edit")
    #     end
    #   end
    class DoubleRender < StandardError
    end # DoubleRender
    
    # Raised when an action returns something other then a string.
    # 
    # Example:
    #   class FooController < Mack::Controller::Base
    #     def index
    #       [1,2,3,4]
    #     end
    #   end
    class InvalidRenderType < StandardError
      # Takes the Class you are trying to render.
      def initialize(klass)
        super("You can not render a #{klass}! It must be a String.")
      end
    end # InvalidRenderType
    
    # Raised when an action tries to render a resource that can't be found.
    # 
    # Example:
    #   http://www.mackframework.com/my_missing_file.jpg
    class ResourceNotFound < StandardError
      # Takes the resource that can't be found.
      # 
      # Example:
      #   http://www.mackframework.com/my_missing_file.jpg # => my_missing_file.jpg would be the resource
      def initialize(resource)
        super(resource)
      end
    end # ResourceNotFound
    
    # Raised when a route that matches the pattern of the incoming route AND the method of the request can't be found.
    # It's important to note that BOTH the PATTERN and the HTTP METHOD HAVE to match for a route to be found!
    class UndefinedRoute < StandardError
      # Takes a request object.
      def initialize(req)
        super("#{req.path_info}; #{req.request_method}")
      end
    end # UndefinedRoute
    
    # Raised when a layout is specified that doesn't exist.
    class UnknownLayout < StandardError
      # Takes a layout name.
      def initialize(layout)
        super("Could not find layout in: #{File.join(MACK_ROOT, "app", "views", layout.to_s + ".html.erb")}")
      end
    end
    
    # Raised if an unsupported render option is supplied.
    class UnknownRenderOption < StandardError
      # Takes a render option.
      def initialize(opt)
        super("You did not specify a valid render option! '#{opt.inspect}'")
      end
    end
    
    # Raised if a Mack::Controller::Filter returns false.
    class FilterChainHalted < StandardError
      # Takes the name of the filter that returned false.
      def initialize(filter)
        super("The fitler chain was halted because of filter: '#{filter}'")
      end
    end
    
    # Raised if a Mack::Generator::Base required parameter is not supplied.
    class RequiredGeneratorParameterMissing < StandardError
      # Takes the name of the missing parameter.
      def initialize(name)
        super("The required parameter '#{name.to_s.upcase}' is missing for this generator!")
      end
    end
    
    # Potentially raised if a render(:url => "....") is a status other than 200.
    # This is only raised if :raise_exception is passed in as true to the render options.
    class UnsuccessfulRenderUrl < StandardError
      # Takes the uri trying to be rendered the Net::HTTP response object.
      def initialize(uri, response)
        super("URI: #{uri}; status: #{response.code}; body: #{response.body}")
      end
    end
    
    # Raised if an unsupported method, ie post or delete, is used with render url.
    class UnsupportRenderUrlMethodType < StandardError
      # Takes the method tried.
      def initialize(method)
        super("METHOD: #{method.to_s.upcase} is unsupported by render url.")
      end
    end
    
  end # Errors
end # Mack