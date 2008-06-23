require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

class Foo
end

describe "Filter" do

  describe "->before" do
    #   def test_before_all_actions
    #   end
    it "should handle before_all actions" do
      get "/tst_my_filters/index"
      response.body.should match(/Date: TODAY!/)
    end

    #   def test_before_simple_only
    #   end
    it "should handle before simple :only" do
      get "/tst_my_filters/index"
      response.body.should match(/Hi: ''/)

      get "/tst_my_filters/hello"
      response.body.should match(/Hi: 'HELLO!!'/)
    end

    #   def test_before_simple_except
    #   end
    it "should handle before simple :except" do
      get "/tst_my_filters/index"
      response.body.should match(/Goodbye: 'bye!'/)

      get "/tst_my_filters/hello"
      response.body.should match(/Goodbye: ''/)
    end
  end

  describe "->run" do
    before(:all) do
      @filter = Mack::Controller::Filter
    end

    it "should run without options" do
      f = @filter.new(:log_action, self)
      f.run?(:my_action).should == true
    end

    it "should run with :only option" do
      f = @filter.new(:log_action, self, :only => :my_action)
      f.run?(:my_action).should == true
      f.run?(:my_other_action).should_not == true
    end

    it "should run with :except option" do
      f = @filter.new(:log_action, self, :except => :my_action)
      !f.run?(:my_action).should_not == true
      f.run?(:my_other_action).should == true
    end

    it "should run with :only options" do
      f = @filter.new(:log_action, self, :only => [:my_action, :my_other_action])
      f.run?(:my_action).should == true
      f.run?(:my_other_action).should == true
      f.run?(:some_other_action).should_not == true
    end

    it "should run with :except options" do
      f = @filter.new(:log_action, self, :except => [:my_action, :my_other_action])
      f.run?(:my_action).should_not == true
      f.run?(:my_other_action).should_not == true
      f.run?(:some_other_action).should == true
    end
  end

  describe "->after" do
    it "should handle after_filter simple :only" do
      get "/tst_my_filters/me"
      response.body.should match(/'ME'/)
    end   

    it "should handle after_render filter simple :only " do
      get "/tst_my_filters/make_all_a"
      response.body.should match(/aaa/)
    end
  end

  describe "->misc" do

    it "should respond to to_s" do
      f = Mack::Controller::Filter.new(:log_action, Foo)
      f.to_s.should == "Foo.log_action"
    end

    it "should be able to do equality test of 2 filters" do
      Mack::Controller::Filter.new(:log_action, Foo).should == Mack::Controller::Filter.new(:log_action, Foo)
    end

    it "should not contain duplicate filter" do
      fs = [Mack::Controller::Filter.new(:log_action, Foo), Mack::Controller::Filter.new(:log_action, Foo)]
      fs.uniq!
      [Mack::Controller::Filter.new(:log_action, Foo)].should == fs
      fs.size.should == 1
    end

    it "should raise error if false filter is called" do
      lambda { get "/tst_my_filters/please_blow_up" }.should raise_error(Mack::Errors::FilterChainHalted)
    end
  end
end

