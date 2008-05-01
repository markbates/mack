#--
# setup ORM:
#++

require 'data_mapper'

dbs = YAML::load(Erubis::Eruby.new(IO.read(File.join(MACK_CONFIG, "database.yml"))).result)

unless dbs.nil?
  settings = dbs[MACK_ENV]
  if settings["default"]
    settings.each do |k,v|
      DataMapper::Database.setup(k.to_sym, v)
    end
  else
    DataMapper::Database.setup(settings)
  end
end

class DmSchemaInfo # :nodoc:
  include DataMapper::Persistence
  
  set_table_name "schema_info"
  property :version, :integer, :default => 0
end