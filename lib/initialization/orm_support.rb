orm = app_config.orm || 'data_mapper'
unless orm.nil? 
  MACK_DEFAULT_LOGGER.info "Initializing #{orm} orm..."
  require "mack-#{orm}"
  require "mack-#{orm}_tasks"
end