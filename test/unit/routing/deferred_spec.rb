require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Routes do
  
  describe 'deferred?' do
    
    Mack::Routes.build do |r|
      r.i_am_deferred '/i/am/deferred', :controller => :default, :action => :index, :deferred? => true, :method => :post
      r.i_am_not_deferred '/i/am/not/deferred', :controller => :default, :action => :index
    end
    
    it 'should mark a request as deferred' do
      runner = Mack::Runner.new
      runner.should be_deferred(Rack::MockRequest.env_for('/i/am/deferred', :method => :post))
      runner.should_not be_deferred(Rack::MockRequest.env_for('/i/am/not/deferred'))
      Mack::Routes.retrieve('/i/am/deferred', :post).should == {:controller => :default, :action => :index, :method => :post, :format => "html"}
      Mack::Routes.retrieve('/i/am/not/deferred').should == {:controller => :default, :action => :index, :method => :get, :format => "html"}
    end
    
    it 'should return false if configured to not use deferred routes' do
      configatron.temp do 
        configatron.mack.use_deferred_routes = false
        runner = Mack::Runner.new
        runner.should_not be_deferred(Rack::MockRequest.env_for('/i/am/deferred', :method => :post))
        runner.should_not be_deferred(Rack::MockRequest.env_for('/i/am/not/deferred'))
      end
    end
    
  end
  
end