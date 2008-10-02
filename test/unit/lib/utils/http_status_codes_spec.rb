require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent.parent + 'spec_helper'


describe Mack::Utils::HttpStatusCodes do
  
  it 'should return a String representing the status code' do
    Mack::Utils::HttpStatusCodes.get(200).should == 'OK'
    Mack::Utils::HttpStatusCodes.get('307').should == 'Temporary Redirect'
    Mack::Utils::HttpStatusCodes.get(299).should == 'UNKNOWN HTTP STATUS'
  end
  
end