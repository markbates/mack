require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "erb" do
  
  it "should render with a default layout" do
    get bart_html_erb_with_layout_url
    body = %{<html>
  <head>
    <title>Bart's Page!</title>
  </head>
  <body>
    Bart Simpson: HTML, ERB

  </body>
</html>}
    response.body.should == body
  end
  
  it "should render with a special layout if told to do so" do
    get bart_html_erb_with_special_layout_url
    body = %{<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    Bart Simpson: HTML, ERB

  </body>
</html>}
    response.body.should == body
  end
  
  it "should render with no layout if told to do so" do
    get bart_html_erb_without_layout_url
    response.body.should == "Bart Simpson: HTML, ERB\n"
  end
  
end