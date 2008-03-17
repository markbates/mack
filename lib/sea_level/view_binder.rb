require 'builder'
# require 'erubis'
# This class is used to do all the view level bindings.
# It allows for seperation between the controller and the view levels.
class Mack::ViewBinder
  
  attr_accessor :controller # Allows access to the controller.
  attr_accessor :options # Allows access to any options passed into the Binder.
  
  def initialize(cont, opts = {})
    self.controller = cont
    self.options = {:locals => {}}.merge(opts)
    transfer_vars(@controller)
    @xml_output = ""
    @xml = Builder::XmlMarkup.new(:target => @xml_output, :indent => 1)
  end
  
  # Returns the binding for this class.
  def view_binding
    binding
  end
  
  # If a method can not be found then the :locals key of
  # the options is used to find the variable.
  def method_missing(sym, *args)
    self.options[:locals][sym]
  end
  
  # Maps to the controller's param method. See also Mack::Controller::Base params.
  def params(key)
    self.controller.params(key)
  end
  
  def xml
    @xml
  end
  
  # Handles rendering calls both in the controller and in the view.
  # For full details of render examples see Mack::Controller::Base render.
  # Although the examples there are all in controllers, they idea is still
  # the same for views.
  # 
  # Examples in the view:
  #   <%= render(:text => "Hello") %>
  #   <%= render(:action => "show") %>
  #   <%= render(:partial => :latest_news) %>
  #   <%= render(:url => "http://www.mackframework.com") %>
  def render(options = {})
    app_config.mack.rendering_systems.each do |render_option|
      if options[render_option]
        begin
          rc = "Mack::Rendering::#{render_option.to_s.camelcase}".constantize.new(self, options)
        rescue Exception => e
          raise Mack::Errors::UnknownRenderOption.new(options)
        end
        return rc.render
      end
    end
    raise Mack::Errors::UnknownRenderOption.new(options)
  end
  
  private
  
  # Transfer instance variables from the controller to the view.
  def transfer_vars(x)
    x.instance_variables.each do |v|
      self.instance_variable_set(v, x.instance_variable_get(v))
    end
  end
  
  class << self
    
    # Creates a Mack::ViewBinder and then passes the io through ERB
    # and returns a String. The io can be either an IO object or a String.
    def render(io, controller, options = {})
      vb = Mack::ViewBinder.new(controller, options)
      if (controller.params(:format).to_sym == :xml) && options[:action]
        return eval(io, vb.view_binding)
      else
        return ERB.new(io).result(vb.view_binding)
      end
      # return Erubis::Eruby.new(io).result(vb.view_binding)
    end
    
  end
  
end