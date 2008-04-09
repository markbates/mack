class People < DataMapper::Migration
  
  def self.up
    
    create_table "people" do |t|
      t.column :name, :string
      t.column :birthday, :date
    end
    
  end
  
  def self.down
    drop_table "people"
  end
  
end
