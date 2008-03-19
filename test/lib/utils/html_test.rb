require File.dirname(__FILE__) + '/../../test_helper.rb'

class HtmlHelpersTest < Test::Unit::TestCase
  
  def test_href
    assert_equal "<a href=\"http://www.mackframework.com\">http://www.mackframework.com</a>", Mack::Utils::Html.href("http://www.mackframework.com")
    
    assert_equal "<a href=\"http://www.mackframework.com\">Mack</a>", Mack::Utils::Html.href("Mack", "http://www.mackframework.com")
    
    assert_equal "<a href=\"http://www.mackframework.com\" target=\"_blank\">Mack</a>", Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :target => "_blank")
    
    assert_equal %{<a href="http://www.mackframework.com" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var s = document.createElement('input'); s.setAttribute('type', 'hidden'); s.setAttribute('name', '_method'); s.setAttribute('value', 'delete'); f.appendChild(s);f.submit();return false;">Mack</a>}, Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :method => :delete)
    
    assert_equal %{<a href=\"http://www.mackframework.com\" onclick=\"if (confirm('Are you sure?')) { var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var s = document.createElement('input'); s.setAttribute('type', 'hidden'); s.setAttribute('name', '_method'); s.setAttribute('value', 'update'); f.appendChild(s);f.submit() } ;return false;\">Mack</a>}, Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :method => :update, :confirm => "Are you sure?")
  end
  
  def test_method_missing
    assert_equal "<b >hello</b>", Mack::Utils::Html.b("hello")
    assert_equal "<b >hello</b>", Mack::Utils::Html.b { "hello" }
    assert_equal %{<div class="foo">Hello World</div>}, Mack::Utils::Html.div(:class => :foo) {"Hello World"}
    assert_equal Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :method => :update, :confirm => "Are you sure?"), Mack::Utils::Html.a("Mack", "http://www.mackframework.com", :method => :update, :confirm => "Are you sure?")
  end
  
  def test_rss
    assert_equal "<link rel=\"alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"/tst_resources.xml\">", Mack::Utils::Html.rss(tst_resources_index_url(:format => :xml))
  end
  
end