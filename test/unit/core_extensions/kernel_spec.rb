require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Kernel do
  
  describe 'search_path' do
    
    it 'should return a search path for a key' do
      search_path(:foo).should == []
    end
    
    it 'should try to append a Mack::Paths value, if it exists' do
      search_path(:app).should == [Mack::Paths.app]
      add_search_path(:app, '/Users/foo')
      search_path(:app).should == ['/Users/foo', Mack::Paths.app]
    end
    
  end
  
  describe 'add_search_path' do
    
    it 'should append to the current search path for the key' do
      add_search_path(:app, '/Users/foo')
      search_path(:app).should == ['/Users/foo', Mack::Paths.app]
    end
    
    it 'should create a search path for the key if it does not exist' do
      add_search_path(:foo, '/Users/foo')
      search_path(:foo).should == ['/Users/foo']
    end
    
  end
  
end