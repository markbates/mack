require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Routes do

  describe 'build' do
    
    it 'should yield up a Mack::Routes::RouteMap instance' do
      Mack::Routes.build do |r|
        r.should be_is_a(Mack::Routes::RouteMap)
      end
    end
    
  end
  
  describe 'RouteMap' do
    
    describe 'resource' do
      
      describe 'nested' do
        
        it 'should create nested resources' do
          
          Mack::Routes.build do |r|
            r.resource :universes do |u|
              u.resource :planets do |p|
                p.foo 'foo'
                p.bar 'planets/bar'
                p.fubar '/planets/fubar'
                p.resource :moons, :controller => :moonies
              end
            end
          end
          
          moons_show_url(:id => 'cheese', :planet_id => 'earth', :universe_id => 'milky_way').should == '/universes/milky_way/planets/earth/moons/cheese'
          Mack::Routes.retrieve('/universes/milky_way/planets/earth/moons/cheese').should == {:controller => :moonies, :action => :show, :method => :get, :format => 'html', :id => 'cheese', :planet_id => 'earth', :universe_id => 'milky_way'}
          planets_show_url(:id => 'earth', :universe_id => 'milky_way').should == '/universes/milky_way/planets/earth'
          Mack::Routes.retrieve('/universes/milky_way/planets/earth').should == {:controller => :planets, :action => :show, :method => :get, :format => 'html', :id => 'earth', :universe_id => 'milky_way'}
          planets_foo_url.should == '/universes/:universe_id/planets/foo'
          planets_bar_url.should == '/universes/:universe_id/planets/bar'
          planets_fubar_url.should == '/universes/:universe_id/planets/fubar'
        end
        
      end
      
      it 'should create a set of resource urls' do
        Mack::Routes.build {|r| r.resource :users}
        [:show, :edit, :update, :delete, :index, :new, :create].each do |m|
          self.methods.should include("users_#{m}_url")
        end
        users_show_url(:id => 1).should == '/users/1'
        users_edit_url(:id => 1).should == '/users/1/edit'
        users_update_url(:id => 1).should == '/users/1'
        users_delete_url(:id => 1).should == '/users/1'
        users_index_url.should == '/users'
        users_new_url.should == '/users/new'
        users_create_url.should == '/users'
        Mack::Routes.retrieve('/users/1').should == {:controller => :users, :action => :show, :id => '1', :method => :get, :format => 'html'}
        Mack::Routes.retrieve('/users/1/edit').should == {:controller => :users, :action => :edit, :id => '1', :method => :get, :format => 'html'}
        Mack::Routes.retrieve('/users/1', :put).should == {:controller => :users, :action => :update, :id => '1', :method => :put, :format => 'html', :format => 'html'}
        Mack::Routes.retrieve('/users/1', :delete).should == {:controller => :users, :action => :delete, :id => '1', :method => :delete, :format => 'html'}
        Mack::Routes.retrieve('/users').should == {:controller => :users, :action => :index, :method => :get, :format => 'html'}
        Mack::Routes.retrieve('/users/new').should == {:controller => :users, :action => :new, :method => :get, :format => 'html'}
        Mack::Routes.retrieve('/users', :post).should == {:controller => :users, :action => :create, :method => :post, :format => 'html'}
      end
      
      it 'should take a block to create extra urls before the resource urls' do
        Mack::Routes.build do |r|
          r.resource :zoos do |zoo|
            zoo.foo '/zoos/foo', :action => :foo
            zoo.fubar 'zoos/fubar', :action => :fubar
            zoo.bar 'bar', :action => :bar
            zoo.hello '/hello/:id', :action => :hello, :method => :put
          end
        end
        [:show, :edit, :update, :delete, :index, :new, :create, :foo, :hello].each do |m|
          self.methods.should include("zoos_#{m}_url")
        end
        zoos_show_url(:id => 1).should == '/zoos/1'
        zoos_edit_url(:id => 1).should == '/zoos/1/edit'
        zoos_update_url(:id => 1).should == '/zoos/1'
        zoos_delete_url(:id => 1).should == '/zoos/1'
        zoos_index_url.should == '/zoos'
        zoos_new_url.should == '/zoos/new'
        zoos_create_url.should == '/zoos'
        zoos_foo_url.should == '/zoos/foo'
        zoos_fubar_url.should == '/zoos/fubar'
        zoos_bar_url.should == '/zoos/bar'
        zoos_hello_url(:id => 1).should == '/zoos/hello/1'
        Mack::Routes.retrieve('/zoos/hello/1.xml', :put).should == {:controller => :zoos, :action => :hello, :method => :put, :format => 'xml', :id => '1'}
        Mack::Routes.retrieve('/zoos/foo').should == {:controller => :zoos, :action => :foo, :method => :get, :format => 'html'}
        Mack::Routes.retrieve('/zoos/1').should == {:controller => :zoos, :action => :show, :id => '1', :method => :get, :format => 'html'}
        Mack::Routes.retrieve('/zoos/1', :delete).should == {:controller => :zoos, :action => :delete, :id => '1', :method => :delete, :format => 'html'}
      end
      
      it 'should take options' do
        Mack::Routes.build do |r|
          r.resource :mars, :host => 'www.lifeonmars.com'
          r.resource :herbs, :controller => :spices
        end
        mars_index_url.should == 'http://www.lifeonmars.com/mars'
        mars_show_url(:id => 1).should == 'http://www.lifeonmars.com/mars/1'
        req = Mack::Request.new(Rack::MockRequest.env_for("http://www.lifeonmars.com/mars/1"))
        Mack::Routes.retrieve(req).should == {:controller => :mars, :action => :show, :id => '1', :method => :get, :format => 'html', :host => 'www.lifeonmars.com'}
        Mack::Routes.retrieve('/herbs/1').should == {:controller => :spices, :action => :show, :id => '1', :method => :get, :format => 'html'}
        herbs_show_url(:id => 1).should == '/herbs/1'
      end
      
      # it 'should mask routes' do
      #   Mack::Routes.build do |r|
      #     r.resource :colors, :as => :colours
      #     r.resource :coats, :as => {:mask => :jackets, :redirect => 302}
      #   end
      #   colors_show_url(:id => 1).should == '/colours/1'
      #   colours_show_url(:id => 1).should == '/colours/1'
      #   Mack::Routes.retrieve('/colours/1').should == {:controller => :colors, :action => :show, :id => '1', :method => :get, :format => 'html'}
      #   Mack::Routes.retrieve('/colors/1').should == {:controller => :colors, :action => :show, :id => '1', :method => :get, :format => 'html'}
      #   
      #   Mack::Routes.retrieve('/coats/1').should == {:controller => :coats, :action => :show, :id => '1', :method => :get, :format => 'html'}
      #   Mack::Routes.retrieve('/jackets/1').should == {:controller => :coats, :action => :show, :id => '1', :method => :get, :format => 'html'}
      #   
      #   coats_show_url(:id => 1).should == '/jackets/1'
      #   jackets_show_url(:id => 1).should == '/jackets/1'
      #   
      #   get coats_show_url(:id => 1)
      #   response.should be_redirected_to(jackets_show_url(:id => 1))
      # end
      
    end
    
    describe 'connect' do
      
      it 'should map a url to a set a of options' do 
        Mack::Routes.build do |r| 
          r.connect '/routing', :controller => :default, :action => :index
          r.connect '/foo', :controller => :default, :action => :foo, :method => :post
        end
        Mack::Routes.retrieve('/routing').should == {:controller => :default, :action => :index, :method => :get, :format => 'html'}
        Mack::Routes.retrieve('/foo', :post).should == {:controller => :default, :action => :foo, :method => :post, :format => 'html'}
      end
      
      it 'should take a block that can be used at runtime' do
        blck = Proc.new do |req, res|
          'hi'
        end
        Mack::Routes.build do |r|
          r.connect '/routing/block', :controller => :default, :action => :index, &blck
        end
        Mack::Routes.retrieve('/routing/block').should == {:controller => :default, :action => :index, :method => :get, :runner_block => blck, :format => 'html'}
      end
      
      it 'should take a regex for the url' do
        Mack::Routes.build do |r| 
          r.connect(/[a-z]{4}\|\D{2}\|cool/, :controller => :coolness, :action => :mark)
        end
        Mack::Routes.retrieve('mark|is|cool').should == {:controller => :coolness, :action => :mark, :method => :get, :format => 'html'}
        lambda{Mack::Routes.retrieve('mark|is|uncool')}.should raise_error(Mack::Errors::UndefinedRoute)
      end
      
    end
    
    describe 'method_missing' do
      
      it 'should create a named url' do
        Mack::Routes.build do |r|
          r.dog '/dog', :controller => :animals, :action => :dog
        end
        self.methods.should include('dog_url')
        dog_url.should == '/dog'
      end
      
      it 'should take a block that can be used at runtime' do
        Mack::Routes.build do |r|
          r.cat('/dog', {:controller => :animals, :action => :dog}) do |req, res|
            'hi cat'
          end
        end
      end
      
    end
    
    describe 'defaults' do
      
      it 'should create a set of default options' do
        Mack::Routes.build {|r| r.defaults}
        Mack::Routes.retrieve('/routing_users/show/1').should == {:controller => 'routing_users', :action => 'show', :id => '1', :method => :get, :format => 'html'}
        Mack::Routes.retrieve('/routing_users/show/1', :post).should == {:controller => 'routing_users', :action => 'show', :id => '1', :method => :post, :format => 'html'}
        Mack::Routes.retrieve('/routing_users/show.xml').should == {:controller => 'routing_users', :action => 'show', :method => :get, :format => 'xml'}
        Mack::Routes.retrieve('/routing_users/show', :post).should == {:controller => 'routing_users', :action => 'show', :method => :post, :format => 'html'}
      end
      
    end
    
    describe 'handle_error' do
      
      it 'should map an error to a set of options' do
        Mack::Routes.build do |r|
          r.handle_error TypeError, :controller => :errors, :action => :type
        end
        Mack::Routes.retrieve_from_error(TypeError).should == {:controller => :errors, :action => :type}
      end
      
    end
    
    describe 'retrieve' do
      
      before(:each) do
        Mack::Routes.build do |r|
          r.connect '/movies/:id', :controller => :movies, :action => :show
          r.connect '/theaters/:id', :controller => :theaters, :action => :show, :format => :xml
        end
      end
      
      it 'should match independent of format, if a format is not specified' do
        Mack::Routes.retrieve('/movies/1').should == {:controller => :movies, :action => :show, :id => '1', :method => :get, :format => 'html'}
        Mack::Routes.retrieve('/movies/1.xml').should == {:controller => :movies, :action => :show, :id => '1', :method => :get, :format => 'xml'}
      end
      
      it 'should match only if the formats match' do
        lambda{Mack::Routes.retrieve('/theaters/malden/02148/1')}.should raise_error(Mack::Errors::UndefinedRoute)
        Mack::Routes.retrieve('/theaters/1.xml').should == {:controller => :theaters, :action => :show, :id => '1', :method => :get, :format => 'xml'}
      end
      
      it 'should always return defaults last' do
        Mack::Routes.build do |r|
          r.defaults
          r.resource :users
        end
        Mack::Routes.retrieve('/users/1').should == {:controller => :users, :action => :show, :id => '1', :method => :get, :format => 'html'}
        Mack::Routes.retrieve('/foo/bar').should == {:controller => 'foo', :action => 'bar', :method => :get, :format => 'html'}
      end
      
      it 'should return the proper route for a String representation of a url' do
        Mack::Routes.retrieve('/movies/1').should == {:controller => :movies, :action => :show, :id => '1', :method => :get, :format => 'html'}
      end
      
      it 'should return the proper route for a Request object' do
        req = Mack::Request.new(Rack::MockRequest.env_for(""))
        req.path_info = '/movies/1'
        Mack::Routes.retrieve(req).should == {:controller => :movies, :action => :show, :id => '1', :method => :get, :format => 'html'}
      end
      
      it 'should match the host if specified' do
        Mack::Routes.build do |r|
          r.dog '/routing/test/animals/dog', :controller => :animals, :action => :dog, :host => 'www.mackframework.com'
        end
        req = Mack::Request.new(Rack::MockRequest.env_for("/routing/test/animals/dog"))
        lambda{Mack::Routes.retrieve(req)}.should raise_error(Mack::Errors::UndefinedRoute)
        req = Mack::Request.new(Rack::MockRequest.env_for("http://www.mackframework.com/routing/test/animals/dog"))
        Mack::Routes.retrieve(req).should == {:controller => :animals, :action => :dog, :host => 'www.mackframework.com', :method => :get, :format => 'html'}
      end
      
      it 'should return embedded parameters on for host' do
        Mack::Routes.build do |r|
          r.doggy '/routing/test/animals/doggy', :controller => :animals, :action => :dog, :host => ':dog_type.mackframework.com'
        end
        req = Mack::Request.new(Rack::MockRequest.env_for("http://poodle.mackframework.com/routing/test/animals/doggy"))
        Mack::Routes.retrieve(req).should == {:controller => :animals, :action => :dog, :dog_type => 'poodle', :host => 'poodle.mackframework.com', :method => :get, :format => 'html'}
        doggy_url(:dog_type => 'spaniel').should == 'http://spaniel.mackframework.com/routing/test/animals/doggy'
      end
      
      it 'should match the scheme if specified' do
        Mack::Routes.build do |r|
          r.cat '/routing/test/animals/cat', :controller => :animals, :action => :cat, :scheme => 'https'
        end
        req = Mack::Request.new(Rack::MockRequest.env_for("/routing/test/animals/cat"))
        lambda{Mack::Routes.retrieve(req)}.should raise_error(Mack::Errors::UndefinedRoute)
        req = Mack::Request.new(Rack::MockRequest.env_for("https://www.mackframework.com/routing/test/animals/cat"))
        Mack::Routes.retrieve(req).should == {:controller => :animals, :action => :cat, :scheme => 'https', :method => :get, :format => 'html'}
      end
      
      it 'should match the port if specified' do
        Mack::Routes.build do |r|
          r.hamster '/routing/test/animals/hamster', :controller => :animals, :action => :hamster, :port => 8080
        end
        req = Mack::Request.new(Rack::MockRequest.env_for("/routing/test/animals/hamster"))
        lambda{Mack::Routes.retrieve(req)}.should raise_error(Mack::Errors::UndefinedRoute)
        req = Mack::Request.new(Rack::MockRequest.env_for("http://www.mackframework.com:8080/routing/test/animals/hamster"))
        Mack::Routes.retrieve(req).should == {:controller => :animals, :action => :hamster, :port => 8080, :method => :get, :format => 'html'}
      end
      
      it 'should return proper wildcard parameters on a request' do
        Mack::Routes.build do |r|
          r.connect '/chapters/*chaps', :controller => :chapters, :action => :show
          r.chapters '/a/*authors/z', :controller => :books, :action => :peeps
        end
        Mack::Routes.retrieve('/chapters/1/2/3').should == {:controller => :chapters, :action => :show, :method => :get, :chaps => ['1', '2', '3'], :format => 'html'}
        Mack::Routes.retrieve('/chapters/1').should == {:controller => :chapters, :action => :show, :method => :get, :chaps => ['1'], :format => 'html'}
        Mack::Routes.retrieve('/a/me/z').should == {:controller => :books, :action => :peeps, :method => :get, :authors => ['me'], :format => 'html'}
        Mack::Routes.retrieve('/a/me/you/z').should == {:controller => :books, :action => :peeps, :method => :get, :authors => ['me', 'you'], :format => 'html'}
        chapters_url(:authors => ['me', 'you']).should == '/a/me/you/z'
      end
      
      it 'should run a block at a runtime and return if :finished is thrown' do
        Mack::Routes.build do |r|
          r.connect '/i/am/a/runner/block/that/finishes' do |request, response, cookies|
            response.write('Hello')
            throw :finished
          end
        end
        get '/i/am/a/runner/block/that/finishes'
        response.body.should == 'Hello'
      end
      
      it 'should run a block at runtime' do
        Mack::Routes.build do |r|
          r.connect '/i/am/a/runner/block/that/doesnt/finish', :controller => :tst_another, :action => :fun_runner_block do |request, response, cookies|
            request.params[:fun] = 'Hell Yeah!'
          end
        end
        get '/i/am/a/runner/block/that/doesnt/finish'
        response.body.should == 'Hell Yeah!'
      end
      
      it 'should raise a Mack::Errors::UndefinedRoute if there is not route defined' do
        lambda{Mack::Routes.retrieve('/asdfd/assd/af/asdf/asdf/asfd/asd/asdfa/sasf/dasdf/ad')}.should raise_error(Mack::Errors::UndefinedRoute)
      end
      
    end
    
  end

end
