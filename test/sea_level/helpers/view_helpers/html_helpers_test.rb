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
  
  
end