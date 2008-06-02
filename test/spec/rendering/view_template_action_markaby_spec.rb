require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "markaby" do
  
  it "should render with a default layout" do
    get marge_html_markaby_with_layout_url
    body = %{<html>
  <head>
    <title>Application Layout</title>
  </head>
  <body>
    <div><h1>Marge Simpson</h1><h2>HTML, MARKABY</h2></div>
  </body>
</html>}
    response.body.should == body
  end
  
  it "should render with a special layout if told to do so" do
    get marge_html_markaby_with_special_layout_url
    body = %{<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    <div><h1>Marge Simpson</h1><h2>HTML, MARKABY</h2></div>
  </body>
</html>}
    response.body.should == body
  end
  
  it "should render with no layout if told to do so" do
    get marge_html_markaby_without_layout_url
    response.body.should == "<div><h1>Marge Simpson</h1><h2>HTML, MARKABY</h2></div>"
  end
  
end