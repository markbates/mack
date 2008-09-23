module Mack
  module Utils

    module ForgeryDetector # :nodoc:
      
      module ClassMethods
        
        #
        # By default the framework will try to validate incoming
        # HTTP request (other than GET) by validating a secret token
        # stored as hidden field in the posted form.
        #
        # There are 2 ways of disabling this feature:
        # 1.  Globally disabling this feature by setting mack::disable_forgery_detector to true in app_config
        # 2.  In a controller, call this method (disable_forgery_detector) to disable the detection
        #     for a specified set of methods.
        #
        # Supported options:
        # :only => list_of_methods.
        #    This directive will tell the framework only disable the detection for the specified list of methods.
        # :except => list_of_methods
        #    This directive will tell the framework to disable the detection for all methods except the ones specified.
        #
        # Example:
        # class MyController
        #   include Mack::Controller
        #   disable_forgery_detector :only => [:test1, :test2]
        #
        #   def test1
        #   end
        #
        #   def test2
        # end
        #
        # Notes:
        # - This method will not work properly if both :only and :except options are passed in
        # - In inherited case, the following behavior is to be expected:
        #   * If the super class declare that it wants to disable detection for all methods, and the
        #     subclass declare that it wants to disable detection for only a set of methods, then
        #     when the subclass is run, the "disable all detection" from the parent class will be overwritten
        #   * On the other hand, if the super class declare that it wants to disable a set of methods,
        #     and the subclass also declare it wants to disable a set of methods from its own set.  Then
        #     the "only" list will be the combination of both
        #   * The first rule apply in inheritance; this method will not work properly if superclass declear
        #     "except" list, and subclass declare "only" list
        #
        def disable_forgery_detector(options = {})
          hash = self.ignored_actions
          hash[:all] = true and return if options.empty?

          # TODO: should raise error if type is invalid
          type = options[:only] ? :only : (options[:except] ? :except : :unknown)
          list = options[:only] ? [options[:only]].flatten : (options[:except] ? [options[:except]].flatten : [])
          if !list.empty?
            hash[type] ||= []
            hash[type] << list
            hash[type].flatten!
            hash[type].uniq!
            hash[:all] = false
          end
        end
        
        def ignored_actions # :nodoc:
          unless @ignored_actions
            @ignored_actions = {}
            sc = self.superclass
            if sc.class_is_a?(Mack::Controller)
              sc_hash = sc.ignored_actions
              if sc_hash[:only]
                @ignored_actions[:only] ||= []
                @ignored_actions[:only] << sc_hash[:only]
                @ignored_actions[:only].flatten!
              elsif sc_hash[:except]
                @ignored_actions[:except] ||= []
                @ignored_actions[:except] << sc_hash[:except]
                @ignored_actions[:except].flatten!
              elsif sc_hash[:all]
                @ignored_actions[:all] = sc_hash[:all]
              end
            end
          end
          return @ignored_actions
        end
      end
      
      #
      # This method will be added as "before-filter" for all controllers.
      # 
      # This method will filter the incoming request, and raise an exception
      # if it thinks that the incoming request is a forged request.
      #
      # The requirement for a request to be considered a forged:
      # -  It must not be a GET request
      # -  The forgery detection is not disabled globally
      # -  The current action is not part of the "disabled" list
      # -  The authenticity token in the request param is valid
      # -  All of the above must be true
      #
      def detect_forgery
        valid_request? || raise(Mack::Errors::InvalidAuthenticityToken.new(request.params[:__authenticity_token] || "unknown token"))
      end

      protected
      
      def symbolize_list_elements(list = []) # :nodoc:
        list.collect { |x| x.to_sym }
      end
          
      def skip_action? # :nodoc:
        return true if self.class.ignored_actions[:all] and self.class.ignored_actions.empty?
        return false if !self.class.ignored_actions[:all] and self.class.ignored_actions.empty? 
        
        skip = true
        action = request.params[:action]        
        hash   = self.class.ignored_actions
        if hash[:only]
          list = [hash[:only]].flatten
          list = symbolize_list_elements(list)
          skip = false if !list.include?action.to_sym
        elsif hash[:except]
          list = [hash[:except]].flatten
          list = symbolize_list_elements(list)
          skip = false if list.include?action.to_sym
        end
        return skip
      end
      
      def valid_request? # :nodoc:
        return true if !self.class.ignored_actions.empty? and self.skip_action?        
        return configatron.mack.disable_forgery_detector ||
                self.skip_action? ||
                request.params[:method].to_sym == :get ||
                (request.params[:__authenticity_token] == authenticity_token)
      end
      
      def authenticity_token # :nodoc:
        Mack::Utils::AuthenticityTokenDispenser.instance.dispense_token(request.session.id)
      end
    end
    
    class AuthenticityTokenDispenser # :nodoc:
      include Singleton

      def dispense_token(key) # :nodoc:
        salt = configatron.mack.retrieve(:request_authenticity_token_salt, "shh, it's a secret")
        salt = "shh, it's a secret" if salt.empty?
        string_to_hash = key.to_s + salt.to_s
        Digest::SHA1.hexdigest(string_to_hash)
      end
    end
  end
end
