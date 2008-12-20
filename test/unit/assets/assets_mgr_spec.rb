require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Assets::Manager do
  
  describe "kernel" do
    it "should respond to 'assets' method" do
      respond_to?('assets_mgr').should == true
    end
  end
  
  describe "javascript" do
    before(:all) do
      assets_mgr.test do |a|
        a.add_js ['a', 'b']
        a.add_js "abc"
        a.add_js :def
      end
      assets_mgr.my_bundle do |a|
        a.add_js "abc"
      end
    end
    
    it "should accept array" do
      assets_mgr.assets(:javascripts, 'test').include?('a.js').should == true
      assets_mgr.assets(:javascripts, :test).include?('b.js').should == true
    end
    
    it "should accept string" do 
      assets_mgr.assets(:javascripts, 'test').include?('abc.js').should == true
    end
    
    it "should accept symbol" do
      assets_mgr.assets(:javascripts, 'test').include?('def.js').should == true
    end
    
    it "should manage groups" do
      assets_mgr.assets(:javascripts, 'test').should_not be_nil
      assets_mgr.assets(:javascripts, 'my_bundle').should_not be_nil
    end
    
    it "should append .js to file name" do
      ['test', 'my_bundle'].each do |group|
        assets_mgr.assets(:javascripts, group).each do |file|
          file.end_with?('.js').should == true
        end
      end
    end
    
    it "should support bundle reset" do
      assets_mgr.test_reset do |a|
        a.add_js "foo"
      end
      
      assets_mgr.assets(:javascripts, 'test_reset').should_not be_empty
      assets_mgr.test_reset.reset!
      assets_mgr.assets(:javascripts, 'test_reset').should be_empty
    end
  end
  
  describe 'stylesheets' do
    before(:each) do 
      assets_mgr.test do |a|
        a.add_css ['a', 'b']
        a.add_css "abc"
        a.add_css :def
      end
      assets_mgr.my_bundle do |a|
        a.stylesheet "abc"
      end
    end
    
    # it "should have scaffold.css in the default group" do
    #   assets_mgr.assets(:stylesheets, 'defaults').include?('scaffold.css').should == true
    # end
    
    it "should accept array" do
      assets_mgr.assets(:stylesheets, 'test').include?('a.css').should == true
      assets_mgr.assets(:stylesheets, :test).include?('b.css').should == true
    end
    
    it "should accept string" do 
      assets_mgr.assets(:stylesheets, 'test').include?('abc.css').should == true
    end
    
    it "should accept symbol" do
      assets_mgr.assets(:stylesheets, 'test').include?('def.css').should == true
    end
    
    it "should manage groups" do
      assets_mgr.assets(:stylesheets, 'test').should_not be_nil
      assets_mgr.assets(:stylesheets, 'my_bundle').should_not be_nil
    end
    
    it "should append .css to file name" do
      ['test', 'my_bundle'].each do |group|
        assets_mgr.assets(:stylesheets, group).each do |file|
          file.end_with?('.css').should == true
        end
      end
    end
  end
  
end