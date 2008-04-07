class CreateCars < DataMapper::Migration
  
  def self.up
    
    create_table :cars do |t|
      t.column :name, :string
      t.column :color, :string
      t.column :wheel_count, :integer, :default => 4
    end
    
    Car.create(:name => "Ford", :color => "black")
    Car.create(:name => "Mack Truck", :color => "red", :wheel_count => 16)
    
  end
  
  def self.down
    drop_table :cars
  end
  
end
