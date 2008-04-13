#--
# setup ORM:
#++

$using_active_record = false
$using_data_mapper = false

# Returns true if the system is setup to use ActiveRecord
def using_active_record?
  $using_active_record
end

# Returns true if the system is setup to use DataMapper
def using_data_mapper?
  $using_data_mapper
end

module ActiveRecord # :nodoc:
end
module DataMapper # :nodoc:
end

unless app_config.orm.nil?
  dbs = YAML::load(ERB.new(IO.read(File.join(MACK_CONFIG, "database.yml"))).result)
  case app_config.orm
  when 'active_record'
    require 'activerecord'
    ActiveRecord::Base.establish_connection(dbs[MACK_ENV])
    class ArSchemaInfo < ActiveRecord::Base # :nodoc:
      set_table_name :schema_info
    end
    $using_active_record = true
    $using_data_mapper = false # set to false, in case we're flipping back and forth
  when 'data_mapper'
    require 'data_mapper'
    DataMapper::Database.setup(dbs[MACK_ENV])
    class DmSchemaInfo < DataMapper::Base # :nodoc:
      set_table_name "schema_info"
      property :version, :integer, :default => 0
    end
    $using_data_mapper = true
    $using_active_record = false # set to false, in case we're flipping back and forth
  else
    MACK_DEFAULT_LOGGER.warn("Attempted to configure an unknown ORM: #{app_config.orm}")
  end
else
  MACK_DEFAULT_LOGGER.warn("No ORM has been configured!")
end