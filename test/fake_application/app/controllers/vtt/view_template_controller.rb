class Vtt::ViewTemplateController < Mack::Controller::Base
  
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