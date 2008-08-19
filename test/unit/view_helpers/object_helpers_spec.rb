require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::ObjectHelpers do
  include Mack::ViewHelpers
  
  describe "debug" do
    
    it "should pp the inspect of an object and wrap it in pre tags" do
      debug(1).should == "<pre>1\n</pre>"
      debug(:foo => :bar).should == "<pre>{:foo=>:bar}\n</pre>"
    end
    
  end
  
end