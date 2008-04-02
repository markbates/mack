module Mack
  module Controller
    # A wrapper class to hold calls to filter methods for Controllers.
    # This class should never be called by itself. Instead there are helper
    # methods in Mack::Controller::Base to do this for.
    # 
    # Examples:
    #   class MyAwesomeController < Mack::Controller::Base
    #     # all actions in this controller will have this filter run:
    #     before_filter: authenticate
    #     # only the show and index actions in this controller will have this filter run:
    #     before_filter: load_side_bar, :only => [:show, :index]
    #     # all actions, except for the create action will have this filter run.
    #     after_filter: write_to_log, :except => :create
    #   end
    # 
    # Filter methods need to be scoped to the controller that is to run them.
    # There are three different filters available: <tt>before</tt>, <tt>after</tt> and <tt>after_render</tt>.
    # 
    # <tt>before</tt> filters get run before an action is called. This is a great place to set up common
    # elements needed for your action. Things like authentication should be done here, etc...
    # 
    # <tt>after</tt> filters get run after an action has been called. This is a great place to set up common
    # elements for a view, that depend on stuff from inside your action. Because nothing has been 'rendered'
    # yet, you still can add new instance variables, and alter ones created in the action.
    # 
    # <tt>after_render</tt> filters get run after the rendering of the action has happened. At this point
    # there is an instance variable, <tt>@final_rendered_action</tt>, that is available on which work can be done.
    # This variable will have any layouts rendered to, any ERB will have been processed, etc... It should be the final
    # String that will get rendered to the screen. This is a great place to do things like write a log, gzip, etc...
    class Filter
  
      attr_reader :filter_method
      attr_reader :action_list
  
      def initialize(filter_method, klass, action_list = {})
        @filter_method = filter_method
        clean_action_list(action_list)
        @klass = klass
      end
  
      def run?(action)
        return true if action_list.empty?
        if action_list[:only]
          return action_list[:only].include?(action)
        elsif action_list[:except]
          return !action_list[:except].include?(action)
        end
        return false
      end
      
      def to_s
        "#{@klass}.#{filter_method}"
      end
      
      def ==(other)
        self.to_s == other.to_s
      end
      
      def eql?(other)
        self.to_s == other.to_s
      end
      
      def hash
        self.to_s.hash
      end
    
      private
      def clean_action_list(action_list)
        if action_list[:only]
          action_list[:only] = [action_list[:only]].flatten
        elsif action_list[:except]
          action_list[:except] = [action_list[:except]].flatten
        end
        @action_list = action_list
      end
  
    end # Fitler
  end # Controller
end # Mack