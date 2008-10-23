require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "Asset Hosts" do
  include Mack::ViewHelpers
  
  describe "Stylesheet" do
    before(:all) do
      Mack::Assets::Helpers.instance.reset!
    end
    
    it "should use default host if asset host is not defined" do
      s = stylesheet('foo')
      stylesheet('foo').should == %{<link href="/stylesheets/foo.css?#{configatron.mack.assets.stamp}" media="screen" rel="stylesheet" type="text/css" />\n}
    end
    
    it "should use asset host even if site_domain is specified" do
      temp_app_config(:mack => {:assets => {:hosts => "http://assets.foo.com"}, :distributed => { :site_domain => 'http://localhost:3001'}}) do
        data = stylesheet('foo')
        data.should_not match(/localhost:3001/)
        data.should match(/assets.foo.com/)
      end
    end
    
    it "should use host defined in app config" do
      temp_app_config(:mack => {:assets => {:hosts => "http://assets.foo.com"}}) do
        stylesheet('foo').should == %{<link href="http://assets.foo.com/stylesheets/foo.css?#{configatron.mack.assets.stamp}" media="screen" rel="stylesheet" type="text/css" />\n}
      end
    end
    
    it "should distribute host" do
      temp_app_config(:mack => {:assets => {:hosts => "http://asset%d.foo.com"}}) do
        stylesheet('foo').should match(/asset(0|1|2|3|4).foo.com/)
      end
    end
    
    it "should use max distribution defined in app config" do
      temp_app_config(:mack => {:assets => {:hosts => "http://asset%d.foo.com", :max_distribution => 2}}) do
        stylesheet('foo').should match(/asset(0|1|2).foo.com/)
        stylesheet('foo').should_not match(/asset(3|4).foo.com/)
      end
    end
    
    it "should override configatron setting if asset host is set by calling setter in AssetHelpers" do
      temp_app_config(:mack => {:assets => {:hosts => 'http://www.foo.com'}}) do
        Mack::Assets::Helpers.instance.asset_hosts="http://asset%d.foo.com"
        stylesheet('foo').should match(/asset(0|1|2|3|4).foo.com/)
      end
    end
    
    it "should take a proc for the asset host generator" do
      Mack::Assets::Helpers.instance.asset_hosts = Proc.new { |source| 'asset.foo.com' }
      stylesheet('foo').should match(/asset.foo.com/)
    end
  end
  
  describe "Javascript" do
    before(:all) do
      Mack::Assets::Helpers.instance.reset!
    end
    
    it "should use default host if asset host is not defined" do
      javascript('foo').should_not match(/http/)
    end
    
    it "should use asset host if specifed and even if site_domain is defined" do
      temp_app_config(:mack => {:assets => {:hosts => "http://assets.foo.com"}, :distributed => { :site_domain => 'http://localhost:3001'}}) do
        data = javascript('foo')
        data.should_not match(/localhost:3001/)
        data.should match(/assets.foo.com/)
      end
    end
    
    it "should use host defined in app config" do
      temp_app_config(:mack => {:assets => {:hosts => "http://assets.foo.com"}}) do
        javascript('foo').should match(/assets.foo.com/)
      end
    end
    
    it "should distribute host" do
      temp_app_config(:mack => {:assets => {:hosts => "http://asset%d.foo.com"}}) do
        javascript('foo').should match(/asset(0|1|2|3|4).foo.com/)
      end
    end
    
    it "should use max distribution defined in app config" do
      temp_app_config(:mack => {:assets => {:hosts => "http://asset%d.foo.com", :max_distribution => 2}}) do
        javascript('foo').should match(/asset(0|1|2).foo.com/)
        javascript('foo').should_not match(/asset(3|4).foo.com/)
      end
    end
    
    it "should override configatron setting if asset host is set by calling setter in AssetHelpers" do
      temp_app_config("asset_hosts" => 'http://www.foo.com') do
        Mack::Assets::Helpers.instance.asset_hosts="http://asset%d.foo.com"
        javascript('foo').should match(/asset(0|1|2|3|4).foo.com/)
      end
    end
    
    it "should take a proc for the asset host generator" do
      Mack::Assets::Helpers.instance.asset_hosts = Proc.new { |source| 'asset.foo.com' }
      javascript('foo').should match(/asset.foo.com/)
    end
  end
  
end