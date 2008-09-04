module Mack
  module Utils

    module ForgeryDetector
      
      module ClassMethods
        def disable_forgery_detector(options = {})
          # cannot set both :only and :except
          self.ignored_actions.clear
          
          # if no options provided, then assume we're disabling all forgery protection for all actions
          self.ignored_actions[:all] = true and return if options.empty?
          
          if (the_list = options.delete(:only))
            self.ignored_actions[:only] = the_list
          elsif (the_list = options.delete(:except))
            self.ignored_actions[:except] = the_list
          end
        end
        
        def ignored_actions
          @ignored_actions ||= {}
        end
      end
      
      def detect_forgery
        valid_request? || raise(Mack::Errors::InvalidAuthenticityToken.new(request.params[:authenticity_token] || "unknown token"))
      end

      protected
          
      def skip_action?
        return true if self.class.ignored_actions[:all]
        return false if self.class.ignored_actions.empty?
        skip = true
        action = request.params[:action]        
        
        if self.class.ignored_actions[:only]
          list = [self.class.ignored_actions[:only]].flatten
          skip = false if !list.include?action
        elsif self.class.ignored_actions[:except]
          list = [self.class.ignored_actions[:except]].flatten
          skip = false if list.include?action
        end
        return skip
      end
      
      def valid_request?
        return true if !self.class.ignored_actions.empty? and self.skip_action?        
        return app_config.mack.disable_forgery_detector ||
        self.skip_action? ||
        request.params[:method] == "get" ||
        (request.params[:authenticity_token] == authenticity_token)
      end
      
      def authenticity_token
        Mack::Utils::AuthenticityTokenDispenser.instance.dispense_token(request.session.id)
      end
    end

    class AuthenticityTokenDispenser
      include Singleton

      def dispense_token(key)
        salt = app_config.request_authenticity_token_salt || "shh, it's a secret"
        salt = "shh, it's a secret" if salt.empty?
        string_to_hash = key.to_s + salt.to_s
        Digest::SHA1.hexdigest(string_to_hash)
      end
    end
  end
end
