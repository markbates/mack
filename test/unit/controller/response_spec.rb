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
  
end