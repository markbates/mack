require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::StringHelpers do
  include Mack::ViewHelpers::StringHelpers
  
  describe "Inflection" do
    it "should be able to pluralize word" do
      pluralize_word(1, "error").should == "1 error"
      pluralize_word(2, "error").should == "2 errors"
      pluralize_word(0, "error").should == "0 errors"
      pluralize_word(1, "errors").should == "1 error"
      pluralize_word(2, "errors").should == "2 errors"
      pluralize_word(0, "errors").should == "0 errors"
    end
  end
  
end
