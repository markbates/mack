require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "render(:inline)" do
  
  describe "erb" do

    it "should render with a default layout" do
      get lisa_inline_erb_with_layout_url
      body = %{<html>
  <head>
    <title>Application Layout</title>
  </head>
  <body>
    Lisa Simpson: INLINE, ERB
  </body>
</html>}
      response.body.should == body
    end

    it "should render with a special layout if told to do so" do
      get lisa_inline_erb_with_special_layout_url
      body = %{<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    Lisa Simpson: INLINE, ERB
  </body>
</html>}
      response.body.should == body
    end

    it "should render with no layout if told to do so" do
      get lisa_inline_erb_without_layout_url
      response.body.should == "Lisa Simpson: INLINE, ERB"
    end

  end # erb
  
end