require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::FormHelpers do
  include Mack::ViewHelpers
  
  describe "form" do
    include CommonHelpers
    
    it "should generate proper form tags" do
      tmp = <<-EOF
<% form("http://www.mackframework.com") do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" method=\"post\">\nHello\n</form>"
      tmp = <<-EOF
<% form("http://www.mackframework.com", :multipart => true) do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" enctype=\"multipart/form-data\" method=\"post\">\nHello\n</form>"
      tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form") do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"post\">\nHello\n</form>"
      
      tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form", :method => :get) do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"get\">\nHello\n</form>"
      tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form", :method => :put) do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"post\">\n<input name=\"_method\" type=\"hidden\" value=\"put\" />\nHello\n</form>"
    end
    
  end
  
  describe "submit_tag" do
    
    it "should build a simple submit tag" do
      submit_tag.should == %{<input type="submit" value="Submit" />}
    end
    
    it "should allow you to change the value" do
      submit_tag("Login").should == %{<input type="submit" value="Login" />}
    end
    
    it "should take options" do
      submit_tag("Login", {:class => :foo}).should == %{<input class="foo" type="submit" value="Login" />}
    end
    
  end
  
end
