require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::FormHelpers do
  include Mack::ViewHelpers
  
  class Lawyer
    attr_accessor :full_name
    attr_accessor :honest
    
    def error_for(name)
      return true if name.to_s == "honest"
      return false
    end
  end
  
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
    
    @lawyer = Lawyer.new
    @lawyer.full_name = "foo bar"
    @lawyer.honest = false
  end
  
  describe "error" do
    it "should add extra css to form field if there's an error" do
      text_field(:lawyer, :honest).should == %{<input class="error" id="lawyer_honest" name="lawyer[honest]" type="text" value="false" />}
    end
    
    it "should put the error class in the first class list so it doesn't override existing style definition" do
      text_field(:lawyer, :honest, :class => "foo").should == %{<input class="foo error" id="lawyer_honest" name="lawyer[honest]" type="text" value="false" />}
    end
    
    it "should let user override the error class" do
      text_field(:lawyer, :honest, :class => "foo", :error_class => "bar").should == %{<input class="foo bar" id="lawyer_honest" name="lawyer[honest]" type="text" value="false" />}
    end
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
    
    it "should create a label if asked" do
      check_box(:cop, :tos, :label => true).should == %{<label for="cop_tos">Tos</label><input id="cop_tos" name="cop[tos]" type="checkbox" />}
      check_box(:cop, :tos, :label => "TOS").should == %{<label for="cop_tos">TOS</label><input id="cop_tos" name="cop[tos]" type="checkbox" />}
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
    
    it "should create a label if asked" do
      file_field(:unknown, :label => true).should == %{<label for="unknown">Unknown</label><input id="unknown" name="unknown" type="file" />}
      file_field(:unknown, :label => "I Know").should == %{<label for="unknown">I Know</label><input id="unknown" name="unknown" type="file" />}
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
    
    it "should create a label if asked" do
      password_field(:cop, :full_name, :label => true).should == %{<label for="cop_full_name">Full name</label><input id="cop_full_name" name="cop[full_name]" type="password" value="ness" />}
      password_field(:cop, :full_name, :label => "Cop's Name").should == %{<label for="cop_full_name">Cop's Name</label><input id="cop_full_name" name="cop[full_name]" type="password" value="ness" />}
    end
    
  end
  
  describe "image_submit" do
    
    it "should create an image submit tag" do
      image_submit("login.png").should == %{<input src="/images/login.png" type="image" />}
      image_submit("purchase.png", :disabled => true).should == %{<input disabled="disabled" src="/images/purchase.png" type="image" />}
      image_submit("search.png", :class => 'search-button').should == %{<input class="search-button" src="/images/search.png" type="image" />}
    end
    
  end
  
  describe "label_tag" do
    
    it "should create a nested label for a model" do
      label_tag(:cop, :full_name).should == %{<label for="cop_full_name">Full name</label>}
    end
    
    it "should create a non-nested label for a simple object" do
      label_tag(:simple).should == %{<label for="simple">Simple</label>}
    end
    
    it "should create a non-nested label for just a symbol" do
      label_tag(:unknown).should == %{<label for="unknown">Unknown</label>}
    end
    
    it "should create a non-nested label for just a symbol" do
      label_tag(:unknown).should == %{<label for="unknown">Unknown</label>}
    end
    
    it "should create a non-nested label and use :value for it's content" do
      label_tag(:unknown, :value => "My Label").should == %{<label for="unknown">My Label</label>}
    end
    
    it "should create a non-nested label and use :for for it's for" do
      label_tag(:unknown, :for => "my_label").should == %{<label for="my_label">Unknown</label>}
    end
    
  end
  
  describe "radio_button" do
    
    it "should create a nested radio_button for a model" do
      radio_button(:cop, :level).should == %{<input checked="checked" id="cop_level" name="cop[level]" type="radio" value="1" />}
      radio_button(:cop, :level, :value => "twoa").should == %{<input id="cop_level" name="cop[level]" type="radio" value="twoa" />}
    end
    
    it "should create a non-nested radio_button for a simple object" do
      radio_button(:simple).should == %{<input checked="checked" id="simple" name="simple" type="radio" value="hi" />}
      radio_button(:simple, :value => "twob").should == %{<input id="simple" name="simple" type="radio" value="twob" />}
    end
    
    it "should create a non-nested radio_button for just a symbol" do
      radio_button(:unknown).should == %{<input id="unknown" name="unknown" type="radio" value="" />}
      radio_button(:unknown, :value => "twoc").should == %{<input id="unknown" name="unknown" type="radio" value="twoc" />}
      radio_button(:unknown, :value => "twod", :checked => true).should == %{<input checked="checked" id="unknown" name="unknown" type="radio" value="twod" />}
    end
    
    it "should create a label if asked" do
      radio_button(:cop, :level, :label => true).should == %{<label for="cop_level">Level</label><input checked="checked" id="cop_level" name="cop[level]" type="radio" value="1" />}
      radio_button(:cop, :level, :label => "The Level").should == %{<label for="cop_level">The Level</label><input checked="checked" id="cop_level" name="cop[level]" type="radio" value="1" />}
    end
    
  end
  
  describe "select_tag" do
    
    it "should create a nested select tag for a model" do
      select_tag(:cop, :level).should == %{<select id="cop_level" name="cop[level]"></select>}
    end
    
    it "should create a non-nested select tag for a simple model" do
      select_tag(:simple).should == %{<select id="simple" name="simple"></select>}
    end
    
    it "should build the options from a given array of arrays" do
      select_tag(:simple, :options => @select_options).should == %{<select id="simple" name="simple">\n<option value="1" >one</option>\n<option value="2" >two</option>\n<option value="3" >three</option></select>}
    end
    
    it "should build the options from a given hash" do
      select_tag(:simple, :options => {"one" => 1, "two" => 2, "three" => 3}).should == %{<select id="simple" name="simple">\n<option value="1" >one</option>\n<option value="3" >three</option>\n<option value="2" >two</option></select>}
    end
    
    it "should mark an option as selected if the model has it seleceted" do
      select_tag(:cop, :level, :options => @select_options).should == %{<select id="cop_level" name="cop[level]">\n<option value="1" selected>one</option>\n<option value="2" >two</option>\n<option value="3" >three</option></select>}
    end
    
    it "should mark an option as selected if the selected options is available" do
      select_tag(:simple, :options => @select_options, :selected => 1).should == %{<select id="simple" name="simple">\n<option value="1" selected>one</option>\n<option value="2" >two</option>\n<option value="3" >three</option></select>}
    end
    
    it "should create a label if asked" do
      select_tag(:cop, :level, :label => true).should == %{<label for="cop_level">Level</label><select id="cop_level" name="cop[level]"></select>}
      select_tag(:cop, :level, :label => "The Level").should == %{<label for="cop_level">The Level</label><select id="cop_level" name="cop[level]"></select>}
    end
    
  end
  
  describe "text_area" do
    
    it "should create a nested text_area for a model" do
      text_area(:cop, :full_name).should == %{<textarea cols="60" id="cop_full_name" name="cop[full_name]" rows="20">ness</textarea>}
    end
    
    it "should create a non-nested text_area for a simple object" do
      text_area(:simple).should == %{<textarea cols="60" id="simple" name="simple" rows="20">hi</textarea>}
    end
    
    it "should create a non-nested text_area for just a symbol" do
      text_area(:unknown).should == %{<textarea cols="60" id="unknown" name="unknown" rows="20"></textarea>}
      text_area(:unknown, :value => "hi there").should == %{<textarea cols="60" id="unknown" name="unknown" rows="20">hi there</textarea>}
    end

    it "should create a nested text_area for a model with an empty value if value is false" do
      @cop.full_name = nil
      text_area(:cop, :full_name).should == %{<textarea cols="60" id="cop_full_name" name="cop[full_name]" rows="20"></textarea>}
    end
    
    it "should create a label if asked" do
      text_area(:cop, :full_name, :label => true).should == %{<label for="cop_full_name">Full name</label><textarea cols="60" id="cop_full_name" name="cop[full_name]" rows="20">ness</textarea>}
      text_area(:cop, :full_name, :label => "Cop's Name").should == %{<label for="cop_full_name">Cop's Name</label><textarea cols="60" id="cop_full_name" name="cop[full_name]" rows="20">ness</textarea>}
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
    
    it "should create a label if asked" do
      text_field(:cop, :full_name, :label => true).should == %{<label for="cop_full_name">Full name</label><input id="cop_full_name" name="cop[full_name]" type="text" value="ness" />}
      text_field(:cop, :full_name, :label => "Cop's Name").should == %{<label for="cop_full_name">Cop's Name</label><input id="cop_full_name" name="cop[full_name]" type="text" value="ness" />}
    end
    
  end
  
  describe "delete_button" do
    include CommonHelpers
    
    it "should create a form and a delete button" do
      delete_button("http://www.mackframework.com").should == %{<form action="http://www.mackframework.com" method="post">\n<input id="_method" name="_method" type="hidden" value="delete" />\n<button type="submit">Delete</button>\n</form>}
      delete_button("http://www.mackframework.com", "Remove", :target => "_blank").should == %{<form action="http://www.mackframework.com" method="post" target="_blank">\n<input id="_method" name="_method" type="hidden" value="delete" />\n<button type="submit">Remove</button>\n</form>}
      delete_button("http://www.mackframework.com", "Remove", {:target => "_blank"}, {:class => "foo"}).should == %{<form action="http://www.mackframework.com" method="post" target="_blank">\n<input id="_method" name="_method" type="hidden" value="delete" />\n<button class="foo" type="submit">Remove</button>\n</form>}
      delete_button("http://www.mackframework.com", "Remove", {:target => "_blank"}, {:confirm => "really??"}).should == %{<form action="http://www.mackframework.com" method="post" target="_blank">\n<input id="_method" name="_method" type="hidden" value="delete" />\n<button onclick="if (confirm('really??')) {submit();}; return false;" type="submit">Remove</button>\n</form>}
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
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" method=\"post\">\nHello\n\n</form>"
      tmp = <<-EOF
<% form("http://www.mackframework.com", :multipart => true) do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" enctype=\"multipart/form-data\" method=\"post\">\nHello\n\n</form>"
      tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form") do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"post\">\nHello\n\n</form>"
      
      tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form", :method => :get) do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"get\">\nHello\n\n</form>"
      tmp = <<-EOF
<% form("http://www.mackframework.com", :id => "my_form", :method => :put) do %>
Hello
<% end %>
      EOF
      erb(tmp).should == "<form action=\"http://www.mackframework.com\" class=\"my_form\" id=\"my_form\" method=\"post\">\n<input name=\"_method\" type=\"hidden\" value=\"put\" />\nHello\n\n</form>"
    end
    
  end
  
  describe "submit_button" do
    
    it "should build a simple submit tag" do
      submit_button.should == %{<button type="submit">Submit</button>}
    end
    
    it "should allow you to change the value" do
      submit_button("Login").should == %{<button type="submit">Login</button>}
    end
    
    it "should take options" do
      submit_button("Login", {:class => :foo}).should == %{<button class="foo" type="submit">Login</button>}
    end
    
    it "should allow you to specify a disabled value" do
      submit_button("Login", {:disable_with => "Please wait..."}).should == %{<button onclick="this.setAttribute('originalValue', this.innerHTML);this.disabled=true;this.innerHTML='Please wait...';result = (this.form.onsubmit ? (this.form.onsubmit() ? this.form.submit() : false) : this.form.submit());if (result == false) { this.innerHTML = this.getAttribute('originalValue'); this.disabled = false };return result;" type="submit">Login</button>}
    end

    it "should allow you to keep your existing onlick settings when setting the :disable_with option" do
      submit_button("Login", {:onclick => "alert('test')", :disable_with => "Please wait..."}).should == %{<button onclick="this.setAttribute('originalValue', this.innerHTML);this.disabled=true;this.innerHTML='Please wait...';alert('test');result = (this.form.onsubmit ? (this.form.onsubmit() ? this.form.submit() : false) : this.form.submit());if (result == false) { this.innerHTML = this.getAttribute('originalValue'); this.disabled = false };return result;" type="submit">Login</button>}
    end
    
  end
  
end
