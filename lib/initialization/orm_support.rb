orm = app_config.orm || 'data_mapper'
 
require "mack-#{orm}"
require "mack-#{orm}_tasks"