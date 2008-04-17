class ModelGenerator < Mack::Generator::Base
  
  require_param :name
  
  def generate
    directory(File.join(MACK_APP, "models"))
    
    @columns = ""
    cols = (param(:cols) || param(:columns))
    if cols
      cols = cols.split("|")
      cols.each_with_index do |v, i|
        x = v.split(":")
        @columns << "property :#{x.first}, :#{x.last}\n  "
      end
      @columns.strip!
    end
    
    template(File.join(File.dirname(__FILE__), "templates", "app", "models", "#{app_config.orm}.rb.template"), File.join(MACK_APP, "models", "#{param(:name).singular.underscore}.rb"))
    MigrationGenerator.new(@env.merge({"name" => "create_#{param(:name)}"})).generate
  end
  
end