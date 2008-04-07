class Tree < DataMapper::Base
  property :leaf_color, :string, :nullable => false
  property :height, :decimal, :nullable => false
end