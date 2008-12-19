require File.join_from_here('all_helpers')
require File.join_from_here('form_helpers')
module Mack
  module View # :nodoc:
    # FormBuilders are a great way to encapsulate reusable form formatting.
    # To help keep a consistent look and feel across the forms on your site,
    # simply wrap them with a custom FormBuilder.
    # 
    # Example:
    #   # app/form_builders/my_site_form_builder.rb:
    #   class MySiteFormBuilder
    #     include Mack::View::FormBuilder
    #   
    #     partial :password_field, 'form_partials/password_field'
    #   
    #     def text_field(*args)
    #       "<h1>#{element(:text_field, *args)}</h1>"
    #     end
    #   
    #     def all(sym, *args)
    #       "<p>#{element(sym, *args)}</p>"
    #     end
    #   end
    # 
    #   # form_partials/_password_field.html.erb:
    #   <h2><%= form_element %></h2>
    #   
    #   # some_view.html.erb:
    #   <% my_site_form('/foo', :method => :post) do |f| %>
    #     <%= f.text_field :username %> # => '<h1><input id="username" name="username" type="text" /></h1>'
    #     <%= f.password_field :password %> # => '<h2><input id="password" name="password" type="password" /></h2>'
    #     <%= f.hidden_field :token, :value => '123' %> # => '<p><input id="token" name="token" type="hidden" value="123" /></p>'
    #   <% end %>
    # 
    #   # some_view.html.erb (alternative):
    #   <% form('/foo', :method => :post, :builder => MySiteFormBuilder.new(self)) do |f| %>
    #     <%= f.text_field :username %> # => '<h1><input id="username" name="username" type="text" /></h1>'
    #     <%= f.password_field :password %> # => '<h2><input id="password" name="password" type="password" /></h2>'
    #     <%= f.hidden_field :token, :value => '123' %> # => '<p><input id="token" name="token" type="hidden" value="123" /></p>'
    #   <% end %>
    module FormBuilder
      
      # Requires a Mack::Rendering::ViewTemplate instance.
      def initialize(view)
        @_view = view
      end
      
      # Returns the Mack::Rendering::ViewTemplate instance.
      def view
        @_view
      end
      
      # This is the catch all method for form elements that aren't overridden.
      # Override and make your own.
      def all(sym, *args)
        self.view.send(sym, *args)
      end
      
      def method_missing(sym, *args) # :nodoc:
        self.all(sym, *args)
      end
      
      # Returns the actual form element from the Mack::ViewHelpers::FormHelper module.
      # This should be used in any method you override in a FormBuilder.
      # 
      # Example:
      #   element(:text_field, :username, :value => 'fubar') # => <input id="username" name="username" type="text" value="fubar" />
      def element(name, *args)
        self.view.send(name, *args)
      end
      
      # Creates a method named after the class that's including Mack::View::FormBuilder
      # 
      # Example:
      #   class SweetFormBuilder
      #     include Mack::View::FormBuilder
      #   end
      # 
      # This creates the following method available in views:
      #   sweet_form('/someurl', :method => :post) do |f|
      #     # ...
      #   end
      # 
      # This could also have been written like this:
      #   form('/someurl', :method => :post, :builder => SweetFormBuilder.new(self)) do |f|
      #     # ...
      #   end
      # 
      # As you can see the helper method is a lot nicer to use. :)
      def self.included(base)
        klass = base.to_s
        klass = klass.gsub('Builder', '').gsub('Form', '')
        mod = Module.new do
          eval %{
            def #{klass.methodize}_form(action, options = {}, &block)
              self.form(action, options.merge(:builder => #{base}.new(self)), &block)
            end
          }
        end # Module.new

        Mack::Rendering::ViewTemplate.class_eval do
          include mod
        end
        
        base.extend Mack::View::FormBuilder::ClassMethods
      end # included
      
      module ClassMethods
        
        # Defines the path to a partial to use for a form element.
        # 
        # Example:
        #   class MySiteFormBuilder
        #     include Mack::View::FormBuilder
        #   
        #     partial :password_field, 'form_partials/password_field'
        #   end
        def partial(element_name, partial)
          define_method(element_name) do |*args|
            if element_name == :all
              val = element(*args)
            else
              val = element(element_name, *args)
            end
            self.view.render(:partial, partial, :locals => {:form_element => val})
          end
        end
        
      end # ClassMethods
      
    end # FormBuilder
  end # View
end # Mack