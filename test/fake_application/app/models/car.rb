class Car < DataMapper::Base
  property :name, :string, :nullable => false
  property :color, :string, :nullable => false
  property :wheel_count, :integer, :default => 4
end