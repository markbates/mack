require File.join(File.dirname(__FILE__), "base")
module Mack
  module RunnerHelpers # :nodoc:
    class Session < Mack::RunnerHelpers::Base
      
      attr_accessor :sess_id
      
      def start(request, response, cookies)
        if app_config.mack.use_sessions
          sess_id = retrieve_session_id(request, response, cookies)
          unless sess_id
            sess_id = create_new_session(request, response, cookies)
          else
            sess = Cachetastic::Caches::MackSessionCache.get(sess_id)
            if sess
              request.session = sess
            else
              # we couldn't find it in the store, so we need to create it:
              sess_id = create_new_session(request, response, cookies)
            end
          end
        end
      end
      
      def complete(request, response, cookies)
        unless response.redirection?
          request.session[:tell] = nil
        end
        Cachetastic::Caches::MackSessionCache.set(sess_id, request.session) if app_config.mack.use_sessions
      end
      
      private
      def retrieve_session_id(request, response, cookies)
        cookies[app_config.mack.session_id]
      end
      
      def create_new_session(request, response, cookies)
        id = String.randomize(40).downcase
        cookies[app_config.mack.session_id] = {:value => id, :expires => nil}
        sess = Mack::Session.new(id)
        request.session = sess
        Cachetastic::Caches::MackSessionCache.set(id, sess)
        id
      end
      
    end # Session
  end # RunnerHelpers
end # Mack