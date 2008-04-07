class CreateTrees < DataMapper::Migration
  
  def self.up
    create_table :trees do |t|
      t.column :leaf_color, :string
      t.column :height, :decimal
    end
  end
  
  def self.down
    drop_table :trees
  end
  
end
