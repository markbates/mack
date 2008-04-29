#--
# setup ORM:
#++

unless app_config.orm.nil?
  dbs = YAML::load(Erubis::Eruby.new(IO.read(File.join(MACK_CONFIG, "database.yml"))).result)
  case app_config.orm
  when 'active_record'
  when 'data_mapper'
  else
    MACK_DEFAULT_LOGGER.warn("Attempted to configure an unknown ORM: #{app_config.orm}")
  end
else
  MACK_DEFAULT_LOGGER.warn("No ORM has been configured!")
end

if app_config.orm == 'active_record'
  
  begin
  
    module ActiveRecord # :nodoc:
    end
  
    require 'activerecord'

    ActiveRecord::Base.establish_connection(dbs[MACK_ENV])
    class ArSchemaInfo < ActiveRecord::Base # :nodoc:
      set_table_name :schema_info
    end

  rescue Exception => e
  end

end

begin
  
  module DataMapper # :nodoc:
  end
  
  require 'data_mapper'
  
  settings = dbs[MACK_ENV]
  if settings["default"]
    settings.each do |k,v|
      DataMapper::Database.setup(k.to_sym, v)
    end
  else
    DataMapper::Database.setup(settings)
  end
  
  DataMapper::Database.setup(dbs[MACK_ENV])
  class DmSchemaInfo # :nodoc:
    include DataMapper::Persistence
    
    set_table_name "schema_info"
    property :version, :integer, :default => 0
  end
  
rescue Exception => e
end


# Returns true if the system is setup to use ActiveRecord
def using_active_record?
  app_config.orm == 'active_record'
end

# Returns true if the system is setup to use DataMapper
def using_data_mapper?
  app_config.orm == 'data_mapper'
end