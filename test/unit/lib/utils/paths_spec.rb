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

    it 'should not return the Mack::Paths value if told not to' do
      Mack.search_path(:test).should == [Mack::Paths.test]
      Mack.search_path(:test, false).should == []
    end

  end

  describe 'search_path_local_first' do

    it 'should try to append a Mack::Paths value, if it exists' do
      Mack.search_path_local_first(:app).should == [Mack::Paths.app, '/Users/foo']
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

  describe 'set_base_path' do
    it 'should set base path for a key' do
      Mack.set_base_path(:my_app, '/foo')
      Mack.base_path(:my_app).should == '/foo'
    end

    it 'should return Mack.root if key is invalid' do
      Mack.base_path(:my_foo_app).should == Mack.root
    end

    it 'should return Mack.root if key == local' do
      Mack.base_path(:local).should == Mack.root
    end
    
    it 'should not let user overwrite :local' do
      Mack.set_base_path(:local, '/foo')
      Mack.base_path(:local).should == Mack.root
    end
  end

end