require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Routes do
  
  describe 'deferred?' do
    
    configatron.mack.use_deferred_routes = true
    
    Mack::Routes.build do |r|
      r.i_am_deferred '/i/am/deferred', :controller => :default, :action => :index, :deferred? => true, :method => :post
      r.i_am_not_deferred '/i/am/not/deferred', :controller => :default, :action => :index
      r.i_am_deferred_w_host '/i/am/deferred_w_host', :controller => :default, :action => :index, :deferred? => true, :host => 'www.example.com'
      r.i_am_deferred_w_port '/i/am/deferred_w_port', :controller => :default, :action => :index, :deferred? => true, :port => 8080
      r.i_am_deferred_w_scheme '/i/am/deferred_w_scheme', :controller => :default, :action => :index, :deferred? => true, :scheme => 'https'
      r.i_am_deferred_w_all '/i/am/deferred_w_all', :controller => :default, :action => :index, :deferred? => true, :host => 'www.example.com', :port => 6969, :scheme => 'https'
      r.resource :deferred_default_res, :deferred? => true
      r.resource :deferred_res_special, :deferred? => [:edit, :show, :new]
      r.resource :vampire
    end
    
    it 'should not have any effect on a regular resource' do
      runner = Mack::Runner.new
      runner.should_not be_deferred(Rack::MockRequest.env_for('/vampires', :method => :post)) # create
      runner.should_not be_deferred(Rack::MockRequest.env_for('/vampires/1', :method => :put)) # update
      runner.should_not be_deferred(Rack::MockRequest.env_for('/vampires/1', :method => :get)) # show
      runner.should_not be_deferred(Rack::MockRequest.env_for('/vampires/1/edit', :method => :get)) # edit
      runner.should_not be_deferred(Rack::MockRequest.env_for('/vampires', :method => :get)) # index
      runner.should_not be_deferred(Rack::MockRequest.env_for('/vampires/new', :method => :get)) # new
      runner.should_not be_deferred(Rack::MockRequest.env_for('/vampires/1', :method => :delete)) # delete
    end
    
    it 'should mark parts of a resource as deferred' do
      runner = Mack::Runner.new
      runner.should be_deferred(Rack::MockRequest.env_for('/deferred_default_res', :method => :post)) # create
      runner.should be_deferred(Rack::MockRequest.env_for('/deferred_default_res/1', :method => :put)) # update
      runner.should_not be_deferred(Rack::MockRequest.env_for('/deferred_default_res/1', :method => :get)) # show
      runner.should_not be_deferred(Rack::MockRequest.env_for('/deferred_default_res/1/edit', :method => :get)) # edit
      runner.should_not be_deferred(Rack::MockRequest.env_for('/deferred_default_res', :method => :get)) # index
      runner.should_not be_deferred(Rack::MockRequest.env_for('/deferred_default_res/new', :method => :get)) # new
      runner.should_not be_deferred(Rack::MockRequest.env_for('/deferred_default_res/1', :method => :delete)) # delete
    end
    
    it 'should mark particular parts of a resource as deferred' do
      runner = Mack::Runner.new
      runner.should_not be_deferred(Rack::MockRequest.env_for('/deferred_res_special', :method => :post)) # create
      runner.should_not be_deferred(Rack::MockRequest.env_for('/deferred_res_special/1', :method => :put)) # update
      runner.should be_deferred(Rack::MockRequest.env_for('/deferred_res_special/1', :method => :get)) # show
      runner.should be_deferred(Rack::MockRequest.env_for('/deferred_res_special/1/edit', :method => :get)) # edit
      runner.should be_deferred(Rack::MockRequest.env_for('/deferred_res_special/new', :method => :get)) # new
      runner.should_not be_deferred(Rack::MockRequest.env_for('/deferred_res_special', :method => :get)) # index
      runner.should_not be_deferred(Rack::MockRequest.env_for('/deferred_res_special/1', :method => :delete)) # delete
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
    
    it 'should handle port, scheme, host, etc...' do
      runner = Mack::Runner.new
      runner.should be_deferred(Rack::MockRequest.env_for('http://www.example.com/i/am/deferred_w_host'))
      runner.should be_deferred(Rack::MockRequest.env_for('http://www.example.com:8080/i/am/deferred_w_port'))
      runner.should be_deferred(Rack::MockRequest.env_for('https://www.example.com/i/am/deferred_w_scheme'))
      runner.should be_deferred(Rack::MockRequest.env_for('https://www.example.com:6969/i/am/deferred_w_all'))
      
      runner.should_not be_deferred(Rack::MockRequest.env_for('http://www.foo.com/i/am/deferred_w_host'))
      runner.should_not be_deferred(Rack::MockRequest.env_for('http://www.example.com:8181/i/am/deferred_w_port'))
      runner.should_not be_deferred(Rack::MockRequest.env_for('http://www.example.com/i/am/deferred_w_scheme'))
      runner.should_not be_deferred(Rack::MockRequest.env_for('http://www.foo.com:9696/i/am/deferred_w_all'))
    end
    
  end
  
end