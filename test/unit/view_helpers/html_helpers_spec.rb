require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

module HTMLSpecHelpers
  include Mack::ViewHelpers::HtmlHelpers
  
  def my_url
    return "http://www.mackframework.com"
  end
  
end

describe Mack::ViewHelpers::HtmlHelpers do
  include HTMLSpecHelpers
      
  describe "a" do
    
    it "should return content when a(...) is called" do
      link_to(my_url).should_not be_nil
      link_to(my_url).should_not be_empty
    end
    
    it "should return proper html when called without options" do
      a(my_url).should == %{<a href="#{my_url}">#{my_url}</a>}
    end
    
    it "should return proper html when called with options" do
      a("Mack", :href => my_url).should == %{<a href="#{my_url}">Mack</a>}
      a("Mack", :href => my_url, :target => "_blank").should == %{<a href="#{my_url}" target=\"_blank">Mack</a>}
      
      result = %{<a href="#{my_url}" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var s = document.createElement('input'); s.setAttribute('type', 'hidden'); s.setAttribute('name', '_method'); s.setAttribute('value', 'delete'); f.appendChild(s);f.submit();return false;">Mack</a>}
      a("Mack", :href => my_url, :method => :delete).should == result
             
      result = %{<a href="#{my_url}" onclick="if (confirm('Are you sure?')) { var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var s = document.createElement('input'); s.setAttribute('type', 'hidden'); s.setAttribute('name', '_method'); s.setAttribute('value', 'update'); f.appendChild(s);f.submit() } ;return false;">Mack</a>}
      link = a("Mack", :href => my_url, :method => :update, :confirm => "Are you sure?")
      link.should == result
    end
  end
  
  describe "link_to" do
    it "should return content when link_to(...) is called" do
      a(my_url).should_not be_nil
      a(my_url).should_not be_empty
    end
    
    it "should return proper html when link_to(...) is called" do
      link_to(my_url).should == a(my_url)
      link_to("Mack", my_url).should == a("Mack", :href => my_url)
      link_to("Mack", my_url, :target => "_blank").should == a("Mack", :href => my_url, :target => "_blank")
      link_to("Mack", my_url, :method => :delete).should == a("Mack", :href => my_url, :method => :delete)
      link_to("Mack", my_url, :method => :update, :confirm => "Are you sure?").should ==  
            a("Mack", :href => my_url, :method => :update, :confirm => "Are you sure?")
    end
  end
  
  describe "rss_tag" do
    it "should return content when rss() is called" do
      rss_tag("foo_bar").should_not be_nil
      rss_tag("foo_bar").should_not be_empty
    end
    
    it "should return proper tag when called" do
      rss_tag(tst_resources_index_url(:format => :xml)).should == %{<link rel="alternate" type="application/rss+xml" title="RSS" href="/tst_resources.xml">}
    end
  end
  
  describe "link_image_to" do

    it "should return content when link_to_image to is called" do
      link_image_to("foo.jpg", "foo.com").should_not be_nil
      link_image_to("foo.jpg", "foo.com").should_not be_empty
    end
    
    it "should be able to generate proper image url when no options are specified" do
      link = link_image_to("/images/foo.jpg", "foo.com")
      link.should == %{<a href="foo.com"><img src="/images/foo.jpg" /></a>}
    end
    
    it "should generate proper image url when options are specified" do
      link = link_image_to("/images/foo.jpg", "foo.com", 
                           {:class => "foo", :alt => "This is an image!", :border => 0}, {:class => "bar"})
      link.should == %{<a class="bar" href="foo.com"><img alt="This is an image!" border="0" class="foo" src="/images/foo.jpg" /></a>}
      
      link = link_image_to("/images/foo.jpg", "foo.com", {:border => 0, :alt => "This is an image!"})
      link.should == %{<a href="foo.com"><img alt="This is an image!" border="0" src="/images/foo.jpg" /></a>}
    end
  end
  
  describe "img" do
    it "should generate content when img is called" do
      img("foo.jpg").should_not be_nil
      img("foo.jpg").should_not be_empty
    end
    
    it "should generate proper img tag" do
      img("/images/foo.jpg").should == %{<img src="/images/foo.jpg" />}
      img("/images/foo.jpg", :border => 0).should == %{<img border="0" src="/images/foo.jpg" />}
    end
  end
  
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
end
