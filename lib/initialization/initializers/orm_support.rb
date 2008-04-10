# setup ORM:

[:active_record, :data_mapper].each do |orm|
  eval("def using_#{orm}?; false; end")
end

unless app_config.orm.nil?
  dbs = YAML::load(ERB.new(IO.read(File.join(MACK_CONFIG, "database.yml"))).result)
  case app_config.orm
  when 'active_record'
    require 'activerecord'
    ActiveRecord::Base.establish_connection(dbs[MACK_ENV])
    
    class SchemaInfo < ActiveRecord::Base
    end
    
    eval("def using_active_record?; true; end")
  when 'data_mapper'
    require 'data_mapper'
    DataMapper::Database.setup(dbs[MACK_ENV])
    class SchemaInfo < DataMapper::Base
      property :version, :integer, :default => 0
    end
    eval("def using_data_mapper?; true; end")
  else
    MACK_DEFAULT_LOGGER.warn("Attempted to configure an unknown ORM: #{app_config.orm}")
  end
else
  MACK_DEFAULT_LOGGER.warn("No ORM has been configured!")
end