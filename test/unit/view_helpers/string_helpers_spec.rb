require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::StringHelpers do
  include Mack::ViewHelpers
  
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
  
  describe "simple_format" do
    
    it "should format a string with simple p and br tags" do
      simple_format("hello\n\ngoodbye\nhello, goodbye").should == "<p>hello</p>\n\n<p>goodbye\n<br />\nhello, goodbye</p>"
    end
    
  end
  
  describe "sanitize_html" do
    
    it "should sanitize all html by defaul" do
      sanitize_html("<script>foo;</script>hello <b>mark</b>").should == "&gt;script>foo;&gt;/script>hello &gt;b>mark&gt;/b>"
      sanitize_html("<script>foo;</script>hello <b>mark</b>", :tags => :script).should == "&gt;script>foo;&gt;/script>hello <b>mark</b>"
      sanitize_html("< script>foo;</ script>hello <b>mark</b>", :tags => :script).should == "&gt;script>foo;&gt;/script>hello <b>mark</b>"
      sanitize_html("<script>foo;</script>hello <b>mark</b>").should == s("<script>foo;</script>hello <b>mark</b>")
    end
    
  end
  
end
