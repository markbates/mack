require File.dirname(__FILE__) + '/../../../test_helper.rb'

class HtmlHelpersTest < Test::Unit::TestCase
  
  include Mack::ViewHelpers::HtmlHelpers
  
  def test_link
    assert_equal a("http://www.mackframework.com"), link_to("http://www.mackframework.com")
    
    assert_equal a("Mack", :href => "http://www.mackframework.com"), link_to("Mack", "http://www.mackframework.com")
    
    assert_equal a("Mack", :href => "http://www.mackframework.com", :target => "_blank"), link_to("Mack", "http://www.mackframework.com", :target => "_blank")
    
    assert_equal a("Mack", :href => "http://www.mackframework.com", :method => :delete), link_to("Mack", "http://www.mackframework.com", :method => :delete)
    
    assert_equal a("Mack", :href => "http://www.mackframework.com", :method => :update, :confirm => "Are you sure?"), link_to("Mack", "http://www.mackframework.com", :method => :update, :confirm => "Are you sure?")
    
    assert_equal "<a href=\"http://www.mackframework.com\">http://www.mackframework.com</a>", a("http://www.mackframework.com")
    
    assert_equal "<a href=\"http://www.mackframework.com\">Mack</a>", a("Mack", :href => "http://www.mackframework.com")
    
    assert_equal "<a href=\"http://www.mackframework.com\" target=\"_blank\">Mack</a>", a("Mack", :href => "http://www.mackframework.com", :target => "_blank")
    
    assert_equal %{<a href="http://www.mackframework.com" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var s = document.createElement('input'); s.setAttribute('type', 'hidden'); s.setAttribute('name', '_method'); s.setAttribute('value', 'delete'); f.appendChild(s);f.submit();return false;">Mack</a>}, a("Mack", :href => "http://www.mackframework.com", :method => :delete)
    
    var1 = %{<a href="http://www.mackframework.com" onclick="if (confirm('Are you sure?')) { var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var s = document.createElement('input'); s.setAttribute('type', 'hidden'); s.setAttribute('name', '_method'); s.setAttribute('value', 'update'); f.appendChild(s);f.submit() } ;return false;">Mack</a>}
    
    link = a("Mack", :href => "http://www.mackframework.com", :method => :update, :confirm => "Are you sure?")
    assert_equal var1, link
    
  end
  
  def test_rss
    assert_equal "<link rel=\"alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"/tst_resources.xml\">", rss_tag(tst_resources_index_url(:format => :xml))
  end
  
  def test_link_image_to
    link = link_image_to("/images/foo.jpg", "foo.com", {:class => "foo", :alt => "This is an image!", :border => 0}, {:class => "bar"})
    assert_equal "<a class=\"bar\" href=\"foo.com\"><img alt=\"This is an image!\" border=\"0\" class=\"foo\" src=\"/images/foo.jpg\" /></a>", link
    
    link = link_image_to("/images/foo.jpg", "foo.com", {:border => 0, :alt => "This is an image!"})
    assert_equal "<a href=\"foo.com\"><img alt=\"This is an image!\" border=\"0\" src=\"/images/foo.jpg\" /></a>", link
    
    assert_equal "<a href=\"foo.com\"><img src=\"/images/foo.jpg\" /></a>", link_image_to("/images/foo.jpg", "foo.com")
  end
  
  def test_image
    assert_equal %{<img src="/images/foo.jpg" />}, img("/images/foo.jpg")
    assert_equal %{<img border="0" src="/images/foo.jpg" />}, img("/images/foo.jpg", :border => 0)
  end
  
  def test_form
    tmp = <<-EOF
<% form("http://www.mackframework.com") do %>
Hello
<% end %>
    EOF
    assert_equal "<form action=\"http://www.mackframework.com\" method=\"post\">\nHello\n</form>", erb(tmp)
    tmp = <<-EOF
<% form("http://www.mackframework.com", :multipart => true) do %>
Hello
<% end %>
    EOF
    assert_equal "<form action=\"http://www.mackframework.com\" enctype=\"multipart/form-data\" method=\"post\">\nHello\n</form>", erb(tmp)
    tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form") do %>
Hello
<% end %>
    EOF
    assert_equal "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"post\">\nHello\n</form>", erb(tmp)
    
    tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form", :method => :get) do %>
Hello
<% end %>
    EOF
    assert_equal "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"get\">\nHello\n</form>", erb(tmp)
    tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form", :method => :put) do %>
Hello
<% end %>
    EOF
    assert_equal "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"post\">\n<input name=\"_method\" type=\"hidden\" value=\"put\" />\nHello\n</form>", erb(tmp)
  end
  
end