require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::LinkHelpers do
  include Mack::ViewHelpers
  
  def my_url
    return "http://www.mackframework.com"
  end
  
  describe "mail_to" do
    
    it "should use the 'text' parameter for the email parameter if one isn't given" do
      mail_to("iii.blick.randy@langworthtowne.co.uk").should == %{<script>document.write(String.fromCharCode(60,97,32,104,114,101,102,61,34,109,97,105,108,116,111,58,105,105,105,46,98,108,105,99,107,46,114,97,110,100,121,64,108,97,110,103,119,111,114,116,104,116,111,119,110,101,46,99,111,46,117,107,34,62,105,105,105,46,98,108,105,99,107,46,114,97,110,100,121,64,108,97,110,103,119,111,114,116,104,116,111,119,110,101,46,99,111,46,117,107,60,47,97,62));</script>}.strip
    end
    
    it "should build a javascript link by default" do
      mail_to("Randy Blick III", "iii.blick.randy@langworthtowne.co.uk").should == %{<script>document.write(String.fromCharCode(60,97,32,104,114,101,102,61,34,109,97,105,108,116,111,58,105,105,105,46,98,108,105,99,107,46,114,97,110,100,121,64,108,97,110,103,119,111,114,116,104,116,111,119,110,101,46,99,111,46,117,107,34,62,82,97,110,100,121,32,66,108,105,99,107,32,73,73,73,60,47,97,62));</script>}.strip
    end
    
    it "should generate a 'plain' version of the link if specified" do
      mail_to("Randy Blick III", "iii.blick.randy@langworthtowne.co.uk", :format => :plain).should == link_to("Randy Blick III", "mailto:iii.blick.randy@langworthtowne.co.uk")
    end
    
  end
  
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
  
  describe "stylesheet" do
    it "should generate stylesheet link without domain info if not specified" do
      temp_app_config("mack::distributed_site_domain" => nil) do
        stylesheet("foo").should_not match(/localhost/)
      end
    end
    
    it "should generate stylesheet link with domain info if specified" do
      temp_app_config("mack::distributed_site_domain" => 'http://localhost:3001') do
        stylesheet("foo").should match(/localhost/)
      end
    end
    
    it "should generate .css link if not specified" do
      stylesheet("foo").should match(/foo.css/)
    end
    
    it "should generate proper css tag" do
      stylesheet("foo").should == %{<link href="/stylesheets/foo.css" media="screen" rel="stylesheet" type="text/css" />\n}
    end
    
    it "should generate multiple css tags if given a list of names" do
      stylesheet("foo", "bar", "hello.css").should == %{<link href="/stylesheets/foo.css" media="screen" rel="stylesheet" type="text/css" />\n<link href="/stylesheets/bar.css" media="screen" rel="stylesheet" type="text/css" />\n<link href="/stylesheets/hello.css" media="screen" rel="stylesheet" type="text/css" />\n}
    end
    
  end

end
