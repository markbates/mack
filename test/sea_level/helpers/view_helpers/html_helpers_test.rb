require File.dirname(__FILE__) + '/../../../test_helper.rb'

class HtmlHelpersTest < Test::Unit::TestCase
  
  include Mack::ViewHelpers::HtmlHelpers
  
  def test_link
    assert_equal Mack::Utils::Html.href("http://www.mackframework.com"), link_to("http://www.mackframework.com")
    
    assert_equal Mack::Utils::Html.href("Mack", "http://www.mackframework.com"), link_to("Mack", "http://www.mackframework.com")
    
    assert_equal Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :target => "_blank"), link_to("Mack", "http://www.mackframework.com", :target => "_blank")
    
    assert_equal Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :method => :delete), link_to("Mack", "http://www.mackframework.com", :method => :delete)
    
    assert_equal Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :method => :update, :confirm => "Are you sure?"), link_to("Mack", "http://www.mackframework.com", :method => :update, :confirm => "Are you sure?")
  end
  
  def test_html
    assert_equal Mack::Utils::Html.b("hello"), html.b("hello")
  end
  
  def test_rss
    assert_equal Mack::Utils::Html.rss(tst_resources_index_url(:format => :xml)), rss_tag(tst_resources_index_url(:format => :xml))
  end
  
  def test_link_image_to
    var1 = "<a href=\"foo.com\" class=\"bar\"><img src=\"/images/foo.jpg\" border=\"0\" class=\"foo\" alt=\"This is an image!\"></a>"
    var2 = "<a href=\"foo.com\" class=\"bar\"><img src=\"/images/foo.jpg\" class=\"foo\" alt=\"This is an image!\" border=\"0\"></a>"
    var3 = "<a href=\"foo.com\" class=\"bar\"><img src=\"/images/foo.jpg\" class=\"foo\" border=\"0\" alt=\"This is an image!\"></a>"
    var4 = "<a href=\"foo.com\" class=\"bar\"><img src=\"/images/foo.jpg\" alt=\"This is an image!\" class=\"foo\" border=\"0\"></a>"
    
    link = link_image_to("/images/foo.jpg", "foo.com", {:class => "foo", :alt => "This is an image!", :border => 0}, {:class => "bar"})
    assert((link == var1 || link == var2 || link == var3 || link == var4), link)
    
    var1 = "<a href=\"foo.com\"><img src=\"/images/foo.jpg\" alt=\"This is an image!\" border=\"0\"></a>"
    var2 = "<a href=\"foo.com\"><img src=\"/images/foo.jpg\" border=\"0\" alt=\"This is an image!\"></a>"
    
    link = link_image_to("/images/foo.jpg", "foo.com", {:border => 0, :alt => "This is an image!"})
    assert(link == var1 || var2)
    
    assert_equal "<a href=\"foo.com\"><img src=\"/images/foo.jpg\"></a>", link_image_to("/images/foo.jpg", "foo.com")
        
    assert_equal Mack::Utils::Html.href(Mack::Utils::Html.image_tag("/images/foo.jpg", {:border=>0}), "foo.com", {:class => "foo"}), link_image_to("/images/foo.jpg", "foo.com", {:border => 0}, {:class => "foo"})
  end
  
end