class Vtt::ViewTemplateController
  include Mack::Controller
  
  def bart_html_erb_with_layout
    render(:action, "bart")
  end
  
  def bart_html_erb_with_special_layout
    render(:action, "bart", :layout => "my_cool")
  end
  
  def bart_html_erb_without_layout
    render(:action, "bart", :layout => false)
  end
    
  def lisa_inline_erb_with_layout
    render(:inline, %{Lisa <%= "Simpson" %>: INLINE, ERB})
  end
  
  def lisa_inline_erb_with_special_layout
    render(:inline, %{Lisa <%= "Simpson" %>: INLINE, ERB}, :layout => "my_cool")
  end
  
  def lisa_inline_erb_without_layout
    render(:inline, %{Lisa <%= "Simpson" %>: INLINE, ERB}, :layout => false)
  end
  
  def homer_xml_with_layout
    render(:xml, "homer")
    @name = "Homer Simpson"
  end
  
  def homer_xml_without_layout
    @name = "Homer Simpson"
    render(:xml, "homer", :layout => false)
  end
  
  def homer_xml_with_special_layout
    @name = "Homer Simpson"
    render(:xml, "homer", :layout => "my_cool")
  end
  
  def good_get_url
    render(:url, "http://testing.mackframework.com/render_url_get_test.php", :parameters => {:age => 31})
  end
  
  def bad_get_url
    render(:url, "http://testing.mackframework.com/i_dont_exist.html", :parameters => {:age => 31})
  end
  
  def bad_with_raise_url
    render(:url, "http://testing.mackframework.com/i_dont_exist.html", :raise_exception => true, :parameters => {:age => 31})
  end
  
  def good_post_url
    render(:url, "http://testing.mackframework.com/render_url_post_test.php", :method => :post, :parameters => {:age => 31})
  end
  
  def bad_post_url
    render(:url, "http://testing.mackframework.com/i_dont_exist.php", :method => :post, :parameters => {:age => 31})
  end
  
  def bad_post_with_raise_url
    render(:url, "http://testing.mackframework.com/i_dont_exist.php", :raise_exception => true, :method => :post, :parameters => {:age => 31})
  end
  
  def good_put_url
    render(:url, "http://testing.mackframework.com/render_url_post_test.php", :method => :put, :parameters => {:age => 31})
  end
  
  def good_delete_url
    render(:url, "http://testing.mackframework.com/render_url_post_test.php", :method => :delete, :parameters => {:age => 31})
  end
  
  def say_hi
    render(:text, "Hello", :layout => false)
  end
  
  def public_found
    render(:public, "vtt_public_test")
  end
  
  def public_not_found
    render(:public, "vtt_public_not_found_test")
  end
  
  def public_found_nested
    render(:public, "vtt/vtt_public_nested_test")
  end
  
  def public_with_extension
    render(:public, 'vtt/vtt_public_with_extension_test.txt')
  end
  
  def partial_local
    render(:partial, :local_part)
  end
  
  def partial_outside
    render(:partial, "application/outside_part")
  end
  
end