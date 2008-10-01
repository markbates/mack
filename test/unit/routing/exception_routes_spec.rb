require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

class HellError < StandardError
  def initialize(x = "Oh Hell!!")
    super(x)
  end
end

class DrunkError < StandardError
end

class ExceptForMeController
  include Mack::Controller

  def raise_hell
    raise HellError.new
  end

  def raise_drunk
    raise DrunkError.new
  end

end

class HandleErrorsController
  include Mack::Controller

  def handle_hell_errors
    render(:text, "We're sorry for your hell: #{caught_exception.message}", :layout => false, :status => 500)
  end

end


describe "Routes Exceptions" do
  
  before(:all) do
    Mack::Routes.build do |r|
      r.raise_hell "/except_for_me/raise_hell", :controller => "except_for_me", :action => :raise_hell
      r.raise_drunk "/except_for_me/raise_drunk", :controller => "except_for_me", :action => :raise_drunk
      r.handle_error ::HellError, :controller => "handle_errors", :action => :handle_hell_errors
      r.connect '/i/am/nowhere' do |req, res, cookies|
        raise Mack::Errors::ResourceNotFound.new('/i/am/nowhere')
      end
      r.connect '/i/raise/hell' do |req, res, cookies|
        raise 'Hell!'
      end
    end
  end
  
  it "should catch and handle a raised exception" do
    get raise_hell_url
    response.body.should == "We're sorry for your hell: Oh Hell!!"
    response.should be_server_error
  end
  
  it "should not catch and handle a raised exception if it's not supposed to" do
    lambda { get raise_drunk_url }.should raise_error(DrunkError)
  end
  
  describe 'ResourceNotFound' do
    
    before(:each) do
      $mack_app = Rack::Recursive.new(Mack::HandleExceptions.new(Mack::Runner.new))
      @fof = Mack::Paths.public('404.html')
    end

    after(:each) do
      $mack_app = Rack::Recursive.new(Mack::Runner.new)
      FileUtils.rm_rf(@fof)
    end
  
    it 'should look for 404.html and return it if found and set the status to 404' do
      File.open(@fof, 'w') {|f| f.puts 'Oops... We could not find your page!'}
      configatron.temp do
        configatron.mack.show_exceptions = false
        get '/i/am/nowhere'
        response.body.should == "Oops... We could not find your page!\n"
        response.status.should == 404
      end
    end
  
    it 'should return a string if no 404.html file is found and set the status to 404' do
      configatron.temp do
        configatron.mack.show_exceptions = false
        get '/i/am/nowhere'
        response.body.should == "Page Not Found!"
        response.status.should == 404
      end
    end
    
    it 'should also work for Mack::Errors::UndefinedRoute' do
      configatron.temp do
        configatron.mack.show_exceptions = false
        get '/i-am-nowhere'
        response.body.should == "Page Not Found!"
        response.status.should == 404
      end
    end
    
  end
  
  describe 'Non handle error' do
    
    before(:each) do
      $mack_app = Rack::Recursive.new(Mack::HandleExceptions.new(Mack::Runner.new))
      @fof = Mack::Paths.public('500.html')
    end

    after(:each) do
      $mack_app = Rack::Recursive.new(Mack::Runner.new)
      FileUtils.rm_rf(@fof)
    end
    
    it 'should look for 500.html and return it if found and set the status to 500' do
      File.open(@fof, 'w') {|f| f.puts 'Oops... There has been a server error!'}
      configatron.temp do
        configatron.mack.show_exceptions = false
        get '/i/raise/hell'
        response.body.should == "Oops... There has been a server error!\n"
        response.status.should == 500
      end
    end
  
    it 'should return a string if no 500.html file is found and set the status to 500' do
      configatron.temp do
        configatron.mack.show_exceptions = false
        get '/i/raise/hell'
        response.body.should == 'Server Error!'
        response.status.should == 500
      end
    end
    
  end
  
end