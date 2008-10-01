require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Response do
  
  describe 'attachment' do
    
    it 'should set the Content-Disposition header correctly' do
      res = Mack::Response.new
      res['Content-Disposition'].should be_nil
      res.attachment = 'foo.csv'
      res['Content-Disposition'].should == 'attachment; filename=foo.csv'
    end
    
  end
  
  describe 'content_type' do
    
    it 'should set and return the content_type correctly' do
      res = Mack::Response.new
      res.content_type = 'xml'
      res.content_type.should == 'xml'
    end
    
  end
  
end