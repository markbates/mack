require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Symbol do
  
  class Cop
    attr_accessor :full_name
    attr_accessor :level
    attr_accessor :tos
  end
  
  before(:each) do
    @cop = Cop.new
    @cop.full_name = "ness"
    @cop.level = 1
    @simple = "hi"
    @default_file = "~/resume.doc"
  end
  
  describe "check_box" do
    
    it "should create a nested checkbox for a model" do
      :cop.check_box(:tos).should == %{<input id="cop_tos" name="cop[tos]" type="checkbox" />}
    end
    
    it "should create a non-nested checkbox for a simple object" do
      :simple.check_box.should == %{<input id="simple" name="simple" type="checkbox" checked="checked" />}
    end
    
    it "should create a non-nested checkbox for just a symbol" do
      :unknown.check_box.should == %{<input id="unknown" name="unknown" type="checkbox" />}
    end
    
    it "should be checked if the value is true" do
      @cop.tos = true
      :cop.check_box(:tos).should == %{<input id="cop_tos" name="cop[tos]" type="checkbox" checked="checked" />}
    end
    
    it "should be unchecked if the value is false" do
      @cop.tos = false
      :cop.check_box(:tos).should == %{<input id="cop_tos" name="cop[tos]" type="checkbox" />}
    end
    
  end
  
  describe "file_field" do
    
  end
  
  describe "hidden_field" do
    
  end
  
  describe "image_submit" do
    
  end
  
  describe "label" do
    
  end
  
  describe "radio_button" do
    
  end
  
  describe "select" do
    
  end
  
  describe "submit" do
    
  end
  
  describe "text_area" do
    
  end
  
  describe "text_field" do
    
  end
  
end