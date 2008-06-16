orm = app_config.orm || 'data_mapper'
unless orm.nil? 
  Mack.logger.info "Initializing #{orm} orm..."
  require "mack-#{orm}"
  require "mack-#{orm}_tasks"
end