require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplateTest < Test::Unit::TestCase
  
  class ViewTemplateController < Mack::Controller::Base
    
    def bart_html_erb_with_layout
      render(:action => "bart")
    end
    
    def bart_html_erb_with_special_layout
      render(:action => "bart", :layout => "my_cool")
    end
    
    def bart_html_erb_without_layout
      render(:action => "bart", :layout => false)
    end
    
    def lisa_text_erb_with_layout
      render(:text => %{Lisa <%= "Simpson" %>: TEXT, ERB})
    end
    
    def lisa_text_erb_with_special_layout
      render(:text => %{Lisa <%= "Simpson" %>: TEXT, ERB}, :layout => "my_cool")
    end
    
    def lisa_text_erb_without_layout
      render(:text => %{Lisa <%= "Simpson" %>: TEXT, ERB}, :layout => false)
    end
    
    def homer_xml_with_layout
      @name = "Homer Simpson"
      render(:xml => "homer")
    end
    
    def homer_xml_without_layout
      @name = "Homer Simpson"
      render(:xml => "homer", :layout => false)
    end
    
    def homer_xml_with_special_layout
      @name = "Homer Simpson"
      render(:xml => "homer", :layout => "my_cool")
    end
    
  end
  
  Mack::Routes.build do |r|
    r.with_options(:controller => "view_template_test/view_template") do |map|
      map.bart_html_erb_with_layout "/vtt/bart_html_erb_with_layout", :action => :bart_html_erb_with_layout
      map.bart_html_erb_without_layout "/vtt/bart_html_erb_without_layout", :action => :bart_html_erb_without_layout
      map.bart_html_erb_with_special_layout "/vtt/bart_html_erb_with_special_layout", :action => :bart_html_erb_with_special_layout
      map.lisa_text_erb_with_layout "/vtt/lisa_text_erb_with_layout", :action => :lisa_text_erb_with_layout
      map.lisa_text_erb_without_layout "/vtt/lisa_text_erb_without_layout", :action => :lisa_text_erb_without_layout
      map.lisa_text_erb_with_special_layout "/vtt/lisa_text_erb_with_special_layout", :action => :lisa_text_erb_with_special_layout
    end
  end
  
  def test_action_html_erb_with_layout
    get bart_html_erb_with_layout_url
    body = <<-EOF
<html>
  <head>
    <title>Application Layout</title>
  </head>
  <body>
    Bart Simpson: HTML, ERB
  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end
  
  def test_action_html_erb_with_special_layout
    get bart_html_erb_with_special_layout_url
    body = <<-EOF
<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    Bart Simpson: HTML, ERB
  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end
  
  def test_action_html_erb_with_layout_url
    get bart_html_erb_without_layout_url
    assert_equal "Bart Simpson: HTML, ERB", response.body
  end
  
  def test_text_erb_with_layout
    get lisa_text_erb_with_layout_url
    body = <<-EOF
<html>
  <head>
    <title>Application Layout</title>
  </head>
  <body>
    Lisa Simpson: TEXT, ERB
  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end

  def test_text_erb_with_special_layout
    get lisa_text_erb_with_special_layout_url
    body = <<-EOF
<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    Lisa Simpson: TEXT, ERB
  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end

  def test_text_erb_with_layout_url
    get lisa_text_erb_without_layout_url
    assert_equal "Lisa Simpson: TEXT, ERB", response.body
  end
  
end