require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

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
  
end