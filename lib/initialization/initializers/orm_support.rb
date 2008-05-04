#--
# setup ORM:
#++
orm = app_config.orm || 'data_mapper'
require "mack-#{orm}"
require "mack-#{orm}_tasks"
# gem "data_objects", "0.2.0"
# gem 'datamapper', "0.3.2"
# require 'data_mapper'
# 
# dbs = YAML::load(Erubis::Eruby.new(IO.read(File.join(MACK_CONFIG, "database.yml"))).result)
# 
# unless dbs.nil?
#   settings = dbs[MACK_ENV]
#   settings.symbolize_keys!
#   if settings[:default]
#     settings.each do |k,v|
#       DataMapper::Database.setup(k, v.symbolize_keys)
#     end
#   else
#     DataMapper::Database.setup(settings)
#   end
# end
# 
# class DmSchemaInfo # :nodoc:
#   include DataMapper::Persistence
#   
#   set_table_name "schema_info"
#   property :version, :integer, :default => 0
# end