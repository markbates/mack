module Mack
  module Utils

    module RequestAuthenticityValidator
      
      module ClassMethods
        def disable_request_validation(options = {})
          @ignored_actions[:only] = options.delete(:only)
          @ignored_actions[:except] = options.delete(:except)
        end
        def ignored_actions
          @ignored_actions ||= {}
        end
        def skip_action?
          return false if ignored_actions.empty?
          skip = true
          action = request.params[:action]
          if ignored_actions[:only]
            list = [ignored_actions[:only]].flatten
            list.each { |i| skip = false if i.to_s == action.to_s }
          elsif ignored_actions[:except]
            list = [ignored_actions[:except]].flatten
            list.each { |i| skip = false if i.to_s != action.to_s }
          end
          return skip
        end
      end
      
      def forgery_shield(state, options = {})
        valid_request? || raise(Mack::Errors::InvalidAuthenticityToken.new(request.params[:authenticity_token] || "unknown token"))
      end


      protected
      
      def valid_request?
        return app_config.disable_request_validation ||
        #self.skip_action? ||
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
