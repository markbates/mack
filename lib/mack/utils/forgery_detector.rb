module Mack
  module Utils

    module ForgeryDetector
      
      module ClassMethods
        
        def disable_forgery_detector(options = {})
          hash = self.ignored_actions
          hash[:all] = true and return if options.empty?

          # TODO: should raise error if type is invalid
          type = options[:only] ? :only : (options[:except] ? :except : :unknown)
          list = options[:only] ? options[:only] : (options[:except] ? options[:except] : [])
          if !list.empty?
            hash[type] ||= []
            hash[type] << list
            hash[type].flatten!
            hash[type].uniq!
            hash[:all] = false
          end
        end
        
        # also get the options from superclass
        def ignored_actions
          unless @ignored_actions
            @ignored_actions = {}
            sc = self.superclass
            if sc.class_is_a?(Mack::Controller)
              sc_hash = sc.ignored_actions
              if sc_hash[:only]
                @ignored_actions[:only] ||= []
                @ignored_actions[:only] << sc_hash[:only]
              elsif sc_hash[:except]
                @ignored_actions[:except] ||= []
                @ignored_actions[:except] << sc_hash[:except]
              elsif sc_hash[:all]
                @ignored_actions[:all] = sc_hash[:all]
              end
            end
          end
          return @ignored_actions
        end
      end
      
      def detect_forgery
        valid_request? || raise(Mack::Errors::InvalidAuthenticityToken.new(request.params[:authenticity_token] || "unknown token"))
      end

      protected
          
      def skip_action?
        return true if self.class.ignored_actions[:all] and self.class.ignored_actions.empty?
        return false if !self.class.ignored_actions[:all] and self.class.ignored_actions.empty? 
        
        skip = true
        action = request.params[:action]        
        hash   = self.class.ignored_actions
        if hash[:only]
          list = [hash[:only]].flatten
          skip = false if !list.include?action
        elsif hash[:except]
          list = [hash[:except]].flatten
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
