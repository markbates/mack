module Mack
  module ViewHelpers # :nodoc:
    
    def get_resource_root(resource)
      path = ""
      path = "#{configatron.mack.distributed.site_domain}" unless configatron.mack.distributed.site_domain.nil?
      path = Mack::Assets::Helpers.instance.asset_hosts(resource) if path.empty?
      return path
    end

    # Used to easily include all Mack::ViewHelpers. It will NOT include itself!
    # This is primarily used to aid in testing view helpers.
    def self.included(base)
      base.class_eval do
        Mack::ViewHelpers.constants.each do |c|
          mod = "Mack::ViewHelpers::#{c}".constantize
          include mod unless base.is_a?(mod)
        end
      end # class_eval
    end # included
    
  end # ViewHelpers
end # Mack