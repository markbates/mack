require 'net/http'
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
  
  # Handles rendering calls both in the controller and in the view.
  # For full details of render examples see Mack::Controller::Base render.
  # Although the examples there are all in controllers, they idea is still
  # the same for views.
  # 
  # Examples in the view:
  #   <%= render(:text => "Hello") %>
  #   <%= render(:action => "show") %>
  #   <%= render(:partial => :latest_news) %>
  def render(options = {})
    if options[:action]
      begin
        # Try to render the action:
        return render_file(options[:action], options)
      rescue Errno::ENOENT => e
        begin
          # If the action doesn't exist on disk, try to render it from the public directory:
          t = render_file(options[:action], {:dir => MACK_PUBLIC, :ext => ".html", :layout => false}.merge(options))
          # Because it's being served from public don't wrap a layout around it!
          # self.controller.instance_variable_get("@render_options").merge!({:layout => false})
          return t
        rescue Errno::ENOENT => ex
        end
        # Raise the original exception because something bad has happened!
        raise e
      end
    elsif options[:text]
      return Mack::ViewBinder.render(options[:text], self.controller, options)
    elsif options[:partial]
      return render_file(options[:partial], {:is_partial => true}.merge(options))
    elsif options[:public]
      t = render_file(options[:public], {:dir => MACK_PUBLIC, :ext => ".html", :layout => false}.merge(options))
      # self.controller.instance_variable_get("@render_options").merge!({:layout => false})
      return t
    elsif options[:url]
      return render_url(options)
    else
      raise Mack::Errors::UnknownRenderOption.new(options)
    end
  end
  
  private
  def render_url(options = {})
    options = {:method => :get, :domain => app_config.mack.default_domain, :raise_exception => false}.merge(options)
    case options[:method]
    when :get
      do_render_url(options) do |uri, options|
        unless options[:parameters].empty?
          uri = uri.to_s
          uri << "?"
          options[:parameters].each_pair do |k,v|
            uri << URI.encode(k.to_s)
            uri << "="
            uri << URI.encode(v.to_s)
            uri << "&"
          end
          uri.gsub!(/&$/, "")
          uri = URI.parse(uri)
        end
        Net::HTTP.get_response(uri)
      end
    when :post
      do_render_url(options) do |uri, options|
        Net::HTTP.post_form(uri, options[:parameters] || {})
      end
    else
      raise Mack::Errors::UnsupportRenderUrlMethodType.new(options[:method])
    end
  end
  
  def do_render_url(options)
    Timeout::timeout(app_config.mack.render_url_timeout || 5) do
      url = options[:url]
      unless url.match(/^[a-zA-Z]+:\/\//)
        url = File.join(options[:domain], options[:url])
      end
      uri = URI.parse(url)
      response = yield uri, options
      if response.code == "200"
        return response.body
      else
        if options[:raise_exception]
          raise Mack::Errors::UnsuccessfulRenderUrl.new(uri, response)
        else
          return ""
        end
      end
    end
  end
  
  def render_file(f, options = {})
    options = {:is_partial => false, :ext => ".html.erb", :dir => MACK_VIEWS}.merge(options)
    partial = f.to_s
    parts = partial.split("/")
    if parts.size == 1
      # it's local to this controller
      partial = "_" << partial if options[:is_partial]
      partial = File.join(options[:dir], self.controller.controller_name, partial + options[:ext])
    else
      # it's elsewhere
      parts[parts.size - 1] = "_" << parts.last if options[:is_partial]
      partial = File.join(options[:dir], parts.join("/") + options[:ext])
    end
    return Mack::ViewBinder.render(File.open(partial).read, self.controller, options)
  end
  
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
      return ERB.new(io).result(vb.view_binding)
      # return Erubis::Eruby.new(io).result(vb.view_binding)
    end
    
  end
  
end