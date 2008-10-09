require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent.parent + 'spec_helper'

describe Mack::Paths do
  
  describe "public" do
    
    it "should give the path to the public directory" do
      Mack::Paths.public.should == File.expand_path(File.join(Mack.root, "public"))
    end
    
    it "should join the file name given with the public directory path" do
      Mack::Paths.public("index.html").should == File.expand_path(File.join(Mack.root, "public", "index.html"))
    end
    
    it "should join the file names given with the public directory path" do
      Mack::Paths.public("foo", "index.html").should == File.expand_path(File.join(Mack.root, "public", "foo", "index.html"))
    end
    
  end
  
  describe 'search_path' do
    
    it 'should return a search path for a key' do
      Mack.search_path(:foo).should == []
    end
    
    it 'should try to append a Mack::Paths value, if it exists' do
      Mack.search_path(:app).should == [Mack::Paths.app]
      Mack.add_search_path(:app, '/Users/foo')
      Mack.search_path(:app).should == ['/Users/foo', Mack::Paths.app]
    end
    
  end
  
  describe 'add_search_path' do
    
    it 'should append to the current search path for the key' do
      Mack.add_search_path(:app, '/Users/foo')
      Mack.search_path(:app).should == ['/Users/foo', Mack::Paths.app]
    end
    
    it 'should create a search path for the key if it does not exist' do
      Mack.add_search_path(:foo, '/Users/foo')
      Mack.search_path(:foo).should == ['/Users/foo']
    end
    
  end
  
end