require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "Gem Manager" do
  include CommonHelpers
  
  before(:each) do
    puts "before(:all)"
    @required_gems = gem_manager.required_gem_list.dup
    gem_manager.required_gem_list = []
  end
  
  after(:each) do
    puts "after(:all)"
    gem_manager.required_gem_list = @required_gems
  end
  
  it "should be able to add gems" do
    g = add_gem(:gem_1)
    g.to_s.should == "gem_1"
    g.libs?.should_not == true

    g = add_gem(:gem_2, :version => "1.2.2")
    g.to_s.should == "gem_2-1.2.2"
    g.libs?.should_not == true
     
    g = add_gem(:gem_2, :version => "1.2.2", :libs => :gem_2)
    g.to_s.should ==  "gem_2-1.2.2"
    g.libs?.should == true
  end
  
  it "should be able to properly install gem libraries" do
    g = add_gem(:gem_1)
    g.libs?.should_not == true
    g.libs.should == []
    
    g = add_gem(:gem_1, :libs => :foo)
    g.libs?.should == true
    g.libs.should == [:foo]
    
    g = add_gem(:gem_1, :libs => [:foo])
    g.libs?.should == true
    g.libs.should == [:foo]
    
    g = add_gem(:gem_1, :libs => [:foo, "bar"])
    g.libs?.should == true
    g.libs.should == [:foo, "bar"]
  end
  
  it "should be able to properly install gem with version" do
    g = add_gem(:gem_1)
    g.version?.should_not == true
    
    g = add_gem(:gem_1, :version => "1.0.0")
    g.version?.should == true
    g.version.should == "1.0.0"
  end
  
  it "should be able to properly install gem with source" do 
    g = add_gem(:gem_1)
    g.source?.should_not == true
    
    g = add_gem(:gem_1, :source => "http://gems.rubyforge.org")
    g.source?.should == true
    g.source.should == "http://gems.rubyforge.org"
  end
  
  it "should be able to get the correct installed gem's name (name + version if exists)" do
    g = add_gem(:gem_1)
    g.to_s.should == "gem_1"
    
    g = add_gem(:gem_1, :version => "1.0.0")
    g.to_s.should == "gem_1-1.0.0"
  end
  
  it "should be able to handle do_requires properly when called" do
    g = add_gem(:termios)
    g.to_s.should == "termios"
    gem_manager.do_requires
    g = add_gem(:redgreen, :version => "1.2.2")
    g = add_gem(:redgreen, :version => "1.2.3", :libs => :redgreen)
    gem_manager.required_gem_list.last.to_s.should == "redgreen-1.2.3"
    lambda { gem_manager.do_requires }.should raise_error(Gem::LoadError)
  end
  
  private
  
  def add_gem(name, options = {})
    ret_val = nil
    # the following construct is the same as assert_difference
    lambda {
      require_gems {|g| g.add(name, options) }
      ret_val = gem_manager.required_gem_list.last
    }.should change { gem_manager.required_gem_list.size }.by(1) 
    return ret_val
  end

  def gem_manager
    Mack::Utils::GemManager.instance
  end
  
end
