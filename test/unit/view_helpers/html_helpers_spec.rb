require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::HtmlHelpers do
  include Mack::ViewHelpers
  
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
  
  describe 'google_analytics' do
    
    it 'should generate google analytics code for you' do
      google_analytics(12345).should == %{
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("12345");
pageTracker._trackPageview();
</script>}.strip
    end
    
  end
  
end
