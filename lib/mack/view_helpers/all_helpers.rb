module Mack
  module ViewHelpers # :nodoc:
    
    def get_resource_root(resource)
      path = ""
      path = Mack::Assets::Helpers.instance.asset_hosts(resource) if path.empty?
      path = "#{configatron.mack.distributed.site_domain}" unless !path.empty? or configatron.mack.distributed.site_domain.nil?
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