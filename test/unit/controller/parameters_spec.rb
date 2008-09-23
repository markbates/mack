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
  
end