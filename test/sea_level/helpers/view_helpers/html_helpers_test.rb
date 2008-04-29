require File.dirname(__FILE__) + '/../../../test_helper.rb'

class HtmlHelpersTest < Test::Unit::TestCase
  
  include Mack::ViewHelpers::HtmlHelpers
  
  class HelpMeController < Mack::Controller::Base
    
    def b_tag
    end
    
  end
  
  Mack::Routes.build do |r|
    r.b_tag "/html_helpme_b", :controller => "html_helpers_test/help_me", :action => :b_tag
  end
  
  def test_b_tag_in_view
    get b_tag_url
    assert_response :success
    assert_match "<b>Hello</b>", response.body
  end
  
  def test_link
    assert_equal Mack::Utils::Html.href("http://www.mackframework.com"), link_to("http://www.mackframework.com")
    
    assert_equal Mack::Utils::Html.href("Mack", :href => "http://www.mackframework.com"), link_to("Mack", "http://www.mackframework.com")
    
    assert_equal Mack::Utils::Html.href("Mack", :href => "http://www.mackframework.com", :target => "_blank"), link_to("Mack", "http://www.mackframework.com", :target => "_blank")
    
    assert_equal Mack::Utils::Html.href("Mack", :href => "http://www.mackframework.com", :method => :delete), link_to("Mack", "http://www.mackframework.com", :method => :delete)
    
    assert_equal Mack::Utils::Html.href("Mack", :href => "http://www.mackframework.com", :method => :update, :confirm => "Are you sure?"), link_to("Mack", "http://www.mackframework.com", :method => :update, :confirm => "Are you sure?")
  end
  
  def test_html
    assert_equal Mack::Utils::Html.b("hello"), html.b("hello")
  end
  
  def test_rss
    assert_equal Mack::Utils::Html.rss(tst_resources_index_url(:format => :xml)), rss_tag(tst_resources_index_url(:format => :xml))
  end
  
  def test_link_image_to
    link = link_image_to("/images/foo.jpg", "foo.com", {:class => "foo", :alt => "This is an image!", :border => 0}, {:class => "bar"})
    assert_equal "<a class=\"bar\" href=\"foo.com\"><img alt=\"This is an image!\" border=\"0\" class=\"foo\" src=\"/images/foo.jpg\" /></a>", link
    
    link = link_image_to("/images/foo.jpg", "foo.com", {:border => 0, :alt => "This is an image!"})
    assert_equal "<a href=\"foo.com\"><img alt=\"This is an image!\" border=\"0\" src=\"/images/foo.jpg\" /></a>", link
    
    assert_equal "<a href=\"foo.com\"><img src=\"/images/foo.jpg\" /></a>", link_image_to("/images/foo.jpg", "foo.com")
        
    link_img = link_image_to("/images/foo.jpg", "foo.com", {:border => 0}, {:class => "foo"})
        
    assert_equal Mack::Utils::Html.href(Mack::Utils::Html.img("/images/foo.jpg", {:border=>0}), :href => "foo.com", :class => "foo"), link_img
  end
  
  def test_form
    f = form("http://www.mackframework.com") {"Hello"}
    hf = Mack::Utils::Html.form(:action => "http://www.mackframework.com") {"Hello"}
    assert_equal hf, f
  end
  
end