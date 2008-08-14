require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::FormHelpers do
  include Mack::ViewHelpers
  
  class Cop
    attr_accessor :full_name
    attr_accessor :level
    attr_accessor :tos
    attr_accessor :bio_file
  end

  before(:each) do
    @cop = Cop.new
    @cop.full_name = "ness"
    @cop.level = 1
    @cop.bio_file = "~/bio.doc"
    @simple = "hi"
    @default_file = "~/resume.doc"
    @select_options = [["one", 1], ["two", 2], ["three", 3]]
  end
  
  describe "check_box" do
    
    it "should create a nested checkbox for a model" do
      check_box(:cop, :tos).should == %{<input id="cop_tos" name="cop[tos]" type="checkbox" />}
    end
    
    it "should create a non-nested checkbox for a simple object" do
      check_box(:simple).should == %{<input checked="checked" id="simple" name="simple" type="checkbox" />}
    end
    
    it "should create a non-nested checkbox for just a symbol" do
      check_box(:unknown).should == %{<input id="unknown" name="unknown" type="checkbox" />}
    end
    
    it "should be checked if the value is true" do
      @cop.tos = true
      check_box(:cop, :tos).should == %{<input checked="checked" id="cop_tos" name="cop[tos]" type="checkbox" />}
    end
    
    it "should be unchecked if the value is false" do
      @cop.tos = false
      check_box(:cop, :tos).should == %{<input id="cop_tos" name="cop[tos]" type="checkbox" />}
    end
    
  end
  
  describe "file_field" do
    
    it "should create a nested file_field for a model" do
      file_field(:cop, :bio_file).should == %{<input id="cop_bio_file" name="cop[bio_file]" type="file" value="~/bio.doc" />}
    end
    
    it "should create a non-nested file_field for a simple object" do
      file_field(:default_file).should == %{<input id="default_file" name="default_file" type="file" value="~/resume.doc" />}
    end
    
    it "should create a non-nested file_field for just a symbol" do
      file_field(:unknown).should == %{<input id="unknown" name="unknown" type="file" />}
    end

    it "should create a nested file_field for a model with an empty value if value is false" do
      @cop.bio_file = nil
      file_field(:cop, :bio_file).should == %{<input id="cop_bio_file" name="cop[bio_file]" type="file" value="" />}
    end
    
  end
  
  describe "hidden_field" do
    
    it "should create a nested hidden_field for a model" do
      hidden_field(:cop, :full_name).should == %{<input id="cop_full_name" name="cop[full_name]" type="hidden" value="ness" />}
    end
    
    it "should create a non-nested hidden_field for a simple object" do
      hidden_field(:simple).should == %{<input id="simple" name="simple" type="hidden" value="hi" />}
    end
    
    it "should create a non-nested hidden_field for just a symbol" do
      hidden_field(:unknown).should == %{<input id="unknown" name="unknown" type="hidden" />}
    end

    it "should create a nested hidden_field for a model with an empty value if value is false" do
      @cop.full_name = nil
      hidden_field(:cop, :full_name).should == %{<input id="cop_full_name" name="cop[full_name]" type="hidden" value="" />}
    end
    
  end
  
  describe "password_field" do
    
    it "should create a nested password_field for a model" do
      password_field(:cop, :full_name).should == %{<input id="cop_full_name" name="cop[full_name]" type="password" value="ness" />}
    end
    
    it "should create a non-nested password_field for a simple object" do
      password_field(:simple).should == %{<input id="simple" name="simple" type="password" value="hi" />}
    end
    
    it "should create a non-nested password_field for just a symbol" do
      password_field(:unknown).should == %{<input id="unknown" name="unknown" type="password" />}
    end

    it "should create a nested password_field for a model with an empty value if value is false" do
      @cop.full_name = nil
      password_field(:cop, :full_name).should == %{<input id="cop_full_name" name="cop[full_name]" type="password" value="" />}
    end
    
  end
  
  describe "image_submit" do
    
    it "should create an image submit tag" do
      image_submit("login.png").should == %{<input src="/images/login.png" type="image" />}
      image_submit("purchase.png", :disabled => true).should == %{<input disabled="disabled" src="/images/purchase.png" type="image" />}
      image_submit("search.png", :class => 'search-button').should == %{<input class="search-button" src="/images/search.png" type="image" />}
    end
    
  end
  
  describe "label" do
    
    it "should create a nested label for a model" do
      label(:cop, :full_name).should == %{<label for="cop_full_name">Full name</label>}
    end
    
    it "should create a non-nested label for a simple object" do
      label(:simple).should == %{<label for="simple">Simple</label>}
    end
    
    it "should create a non-nested label for just a symbol" do
      label(:unknown).should == %{<label for="unknown">Unknown</label>}
    end
    
    it "should create a non-nested label for just a symbol" do
      label(:unknown).should == %{<label for="unknown">Unknown</label>}
    end
    
    it "should create a non-nested label and use :value for it's content" do
      label(:unknown, :value => "My Label").should == %{<label for="unknown">My Label</label>}
    end
    
    it "should create a non-nested label and use :for for it's for" do
      label(:unknown, :for => "my_label").should == %{<label for="my_label">Unknown</label>}
    end
    
  end
  
  describe "radio_button" do
    
    it "should create a nested radio_button for a model" do
      radio_button(:cop, :tos).should == %{<input id="cop_tos" name="cop[tos]" type="radio" />}
    end
    
    it "should create a non-nested radio_button for a simple object" do
      radio_button(:simple).should == %{<input checked="checked" id="simple" name="simple" type="radio" />}
    end
    
    it "should create a non-nested radio_button for just a symbol" do
      radio_button(:unknown).should == %{<input id="unknown" name="unknown" type="radio" />}
    end
    
    it "should be checked if the value is true" do
      @cop.tos = true
      radio_button(:cop, :tos).should == %{<input checked="checked" id="cop_tos" name="cop[tos]" type="radio" />}
    end
    
    it "should be unchecked if the value is false" do
      @cop.tos = false
      radio_button(:cop, :tos).should == %{<input id="cop_tos" name="cop[tos]" type="radio" />}
    end
    
  end
  
  describe "select" do
    
    it "should create a nested select tag for a model" do
      select(:cop, :level).should == %{<select id="cop_level" name="cop[level]"></select>}
    end
    
    it "should create a non-nested select tag for a simple model" do
      select(:simple).should == %{<select id="simple" name="simple"></select>}
    end
    
    it "should build the options from a given array of arrays" do
      select(:simple, :options => @select_options).should == %{<select id="simple" name="simple"><option value="1" >one</option><option value="2" >two</option><option value="3" >three</option></select>}
    end
    
    it "should build the options from a given hash" do
      select(:simple, :options => {"one" => 1, "two" => 2, "three" => 3}).should == %{<select id="simple" name="simple"><option value="1" >one</option><option value="3" >three</option><option value="2" >two</option></select>}
    end
    
    it "should mark an option as selected if the model has it seleceted" do
      select(:cop, :level, :options => @select_options).should == %{<select id="cop_level" name="cop[level]"><option value="1" selected>one</option><option value="2" >two</option><option value="3" >three</option></select>}
    end
    
    it "should mark an option as selected if the selected options is available" do
      select(:simple, :options => @select_options, :selected => 1).should == %{<select id="simple" name="simple"><option value="1" selected>one</option><option value="2" >two</option><option value="3" >three</option></select>}
    end
    
  end
  
  describe "text_area" do
    
    it "should create a nested text_area for a model" do
      text_area(:cop, :full_name).should == %{<textarea id="cop_full_name" name="cop[full_name]">ness</textarea>}
    end
    
    it "should create a non-nested text_area for a simple object" do
      text_area(:simple).should == %{<textarea id="simple" name="simple">hi</textarea>}
    end
    
    it "should create a non-nested text_area for just a symbol" do
      text_area(:unknown).should == %{<textarea id="unknown" name="unknown"></textarea>}
    end

    it "should create a nested text_area for a model with an empty value if value is false" do
      @cop.full_name = nil
      text_area(:cop, :full_name).should == %{<textarea id="cop_full_name" name="cop[full_name]"></textarea>}
    end
    
  end
  
  describe "text_field" do
    
    it "should create a nested text_field for a model" do
      text_field(:cop, :full_name).should == %{<input id="cop_full_name" name="cop[full_name]" type="text" value="ness" />}
    end
    
    it "should create a non-nested text_field for a simple object" do
      text_field(:simple).should == %{<input id="simple" name="simple" type="text" value="hi" />}
    end
    
    it "should create a non-nested text_field for just a symbol" do
      text_field(:unknown).should == %{<input id="unknown" name="unknown" type="text" />}
    end

    it "should create a nested text_field for a model with an empty value if value is false" do
      @cop.full_name = nil
      text_field(:cop, :full_name).should == %{<input id="cop_full_name" name="cop[full_name]" type="text" value="" />}
    end
    
  end
  
  
  describe "form" do
    include CommonHelpers
    
    it "should generate proper form tags" do
      tmp = <<-EOF
<% form("http://www.mackframework.com") do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" method=\"post\">\nHello\n</form>"
      tmp = <<-EOF
<% form("http://www.mackframework.com", :multipart => true) do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" enctype=\"multipart/form-data\" method=\"post\">\nHello\n</form>"
      tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form") do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"post\">\nHello\n</form>"
      
      tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form", :method => :get) do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"get\">\nHello\n</form>"
      tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form", :method => :put) do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"post\">\n<input name=\"_method\" type=\"hidden\" value=\"put\" />\nHello\n</form>"
    end
    
  end
  
  describe "submit" do
    
    it "should build a simple submit tag" do
      submit.should == %{<input type="submit" value="Submit" />}
    end
    
    it "should allow you to change the value" do
      submit("Login").should == %{<input type="submit" value="Login" />}
    end
    
    it "should take options" do
      submit("Login", {:class => :foo}).should == %{<input class="foo" type="submit" value="Login" />}
    end
    
  end
  
end
