require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

class ParameterTestController
  include Mack::Controller
  
  def index
    @iv_params = params
    render(:text, 'hi')
  end
  
end

Mack::Routes.build do |r|
  r.with_options(:controller => :parameter_test, :action => :index) do |m|
    m.connect '/parameter_test', :method => :get
    m.connect '/parameter_test', :method => :put
    m.connect '/parameter_test', :method => :post
    m.connect '/parameter_test', :method => :delete
  end
end

describe Mack::Request::Parameters do
  
  it 'should take a symbol or a string for the key' do
    params = Mack::Request::Parameters.new
    params[:foo] = :bar
    params[:foo].should == 'bar'
    params['foo'].should == 'bar'
  end
  
  it 'should set keys as symbols' do
    params = Mack::Request::Parameters.new
    params['foo'] = 1
    params.has_key?('foo').should == false
    params.has_key?(:foo).should == true
  end
  
  it 'should be case insensitive' do
    req = Mack::Request.new(Rack::MockRequest.env_for("http://www.example.com?foo=BAR&Apple=Good&User[userName]=MarkBates&user[first_Name]=Mark"))
    req.params[:foo].should == 'BAR'
    req.params['FOO'].should == 'BAR'
    req.params[:apple].should == 'Good'
    req.params['aPPle'].should == 'Good'
    req.params[:user].should == {:username => 'MarkBates', :first_name => 'Mark'}
    req.params['UsEr'].should == {:username => 'MarkBates', :first_name => 'Mark'}
  end
  
  it 'should return hashed nested parameters' do
    [:get, :post, :delete, :put].each do |meth|
      puts "#{meth.to_s.upcase}: ----------------------------"
      send(meth, '/parameter_test', {:foo => :bar, :user => {:name => 'Mark Bates'}})
      puts "request.params: #{request.params.inspect}"
      response.should be_successful
      request.params[:method].should == meth.to_s
      request.params.should be_kind_of(Hash)
      request.params[:foo].should == 'bar'
      request.params[:user][:name].should == 'Mark Bates'
    end
  end
  
end