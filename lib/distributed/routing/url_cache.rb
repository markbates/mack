module Mack
  module Distributed
    module Routes
      class UrlCache < Cachetastic::Caches::Base
        
        # class << self
        #   def get(app_name)
        #     super(app_name) do
        #       set(app_name, Mack::Distributed::Routes::Urls.new)
        #     end
        #   end
        # end
        
      end # UrlCache
    end # Routes
  end # Distributed
end # Mack