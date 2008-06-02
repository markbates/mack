require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "render(:action)" do
  
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

  end # erb
  
  describe "haml" do

    it "should render with a default layout" do
      get maggie_html_haml_with_layout_url
      body = %{<html>
  <head>
    <title>Application Layout</title>
  </head>
  <body>
    <div id='name'>Maggie Simpson</div>
<div id='type'>HTML, HAML</div>

  </body>
</html>}
      response.body.should == body
    end

    it "should render with a special layout if told to do so" do
      get maggie_html_haml_with_special_layout_url
      body = %{<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    <div id='name'>Maggie Simpson</div>
<div id='type'>HTML, HAML</div>

  </body>
</html>}
      response.body.should == body
    end

    it "should render with no layout if told to do so" do
      get maggie_html_haml_without_layout_url
      response.body.should == "<div id='name'>Maggie Simpson</div>\n<div id='type'>HTML, HAML</div>\n"
    end

  end # haml
  
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

  end # markaby
  
end