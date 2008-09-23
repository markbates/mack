require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::AssetsManager do
  
  describe "kernel" do
    it "should respond to 'assets' method" do
      respond_to?('assets').should == true
    end
  end
  
  describe "javascript" do
    before(:all) do
      assets.reset!
      assets.test do |a|
        a.add_js ['a', 'b']
        a.add_js "abc"
        a.add_js :def
      end
      assets.foo do |a|
        a.add_js "abc"
      end
    end
    
    it "should accept array" do
      assets.javascripts('test').include?('a.js').should == true
      assets.javascripts(:test).include?('b.js').should == true
    end
    
    it "should accept string" do 
      assets.javascripts('test').include?('abc.js').should == true
    end
    
    it "should accept symbol" do
      assets.javascripts('test').include?('def.js').should == true
    end
    
    it "should manage groups" do
      assets.javascripts('test').should_not be_nil
      assets.javascripts('foo').should_not be_nil
    end
    
    it "should append .js to file name" do
      ['test', 'foo'].each do |group|
        assets.javascripts(group).each do |file|
          file.end_with?('.js').should == true
        end
      end
    end
  end
  
  describe "stylesheets" do
    before(:each) do 
      assets.reset!
      assets.test do |a|
        a.add_css ['a', 'b']
        a.add_css "abc"
        a.add_css :def
      end
      assets.foo do |a|
        a.add_css "abc"
      end
    end
    
    it "should accept array" do
      assets.stylesheets('test').include?('a.css').should == true
      assets.stylesheets(:test).include?('b.css').should == true
    end
    
    it "should accept string" do 
      assets.stylesheets('test').include?('abc.css').should == true
    end
    
    it "should accept symbol" do
      assets.stylesheets('test').include?('def.css').should == true
    end
    
    it "should manage groups" do
      assets.stylesheets('test').should_not be_nil
      assets.stylesheets('foo').should_not be_nil
    end
    
    it "should append .css to file name" do
      ['test', 'foo'].each do |group|
        assets.stylesheets(group).each do |file|
          file.end_with?('.css').should == true
        end
      end
    end
  end
  
end