require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

class ForgeryTestController
  include Mack::Controller
  disable_forgery_detector :only => ['forgery_test1', 'forgery_test2']
  
  def forgery_test1
    render(:text, "foo")
  end
  
  def forgery_test2
    render(:text, "foo")
  end
  
  def forgery_test3
    render(:text, "foo")
  end
  
  def forgery_test4
    render(:text, "foo")
  end
end

class ForgeryTest2Controller
  include Mack::Controller
  disable_forgery_detector :except => ['test1', 'test2']
  
  def test1
    render(:text, "foo")
  end
  
  def test2
    render(:text, "foo")
  end
   
  def test3
    render(:text, "foo")
  end
  
  def test4
    render(:text, "foo")
  end
end

class ForgeryTest3Controller
  include Mack::Controller
  disable_forgery_detector
  
  def test1
    render(:text, "foo")
  end
  
  def test2
    render(:text, "foo")
  end
   
  def test3
    render(:text, "foo")
  end
  
  def test4
    render(:text, "foo")
  end
end

class ForgeryInheritanceController < ForgeryTest3Controller
  
  def test5
    render(:text, "foo")
  end
  
end

describe 'Forgery Detector' do
  
  describe 'Authenticity token' do
    it "should always use the session id + default salt" do
      session_id = session.id
      real_token = Mack::Utils::AuthenticityTokenDispenser.instance.dispense_token(session_id)
      my_token = Digest::SHA1.hexdigest(session_id.to_s + "shh, it's a secret")
      my_token.should == real_token
    end
    it "should allow people to use custom salt" do
      temp_app_config("request_authenticity_token_salt" => "Boo") do
        session_id = session.id
        real_token = Mack::Utils::AuthenticityTokenDispenser.instance.dispense_token(session_id)
        my_token = Digest::SHA1.hexdigest(session_id.to_s + "Boo")
        my_token.should == real_token
      end
    end
    it "should use default salt if custom salt is empty" do
      temp_app_config("request_authenticity_token_salt" => "") do
        session_id = session.id
        real_token = Mack::Utils::AuthenticityTokenDispenser.instance.dispense_token(session_id)
        my_token = Digest::SHA1.hexdigest(session_id.to_s + "shh, it's a secret")
        my_token.should == real_token
      end
    end
  end
  
  describe 'Form helpers' do    
    it "should generate authenticity token when using form() method" do
      my_token = Digest::SHA1.hexdigest(session.id.to_s + "shh, it's a secret")
      get xss_url
      response.body.should match(%{<input type="hidden" name="authenticity_token" value="#{my_token}" />})
    end
    
    it "should let people add authenticity token when not using form() method" do 
      my_token = Digest::SHA1.hexdigest(session.id.to_s + "shh, it's a secret")
      get xss2_url
      response.body.should match(%{<input type="hidden" name="authenticity_token" value="#{my_token}" />})
    end
  end
  
  describe 'Forgery detection' do
    it "should not validate if this feature is globally turned off" do
      temp_app_config("disable_request_validation" => true) do
        post(violate_xss_check_url).should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      end
    end
    
    it "should raise error when authenticity token is not present in the params" do
      lambda{
        post(violate_xss_check_url)
      }.should raise_error(Mack::Errors::InvalidAuthenticityToken)
    end
    
    it "should raise error when authenticity token is present but doesn't match" do
      lambda{
        post(violate_xss_check_url, :authenticity_token => "boo")
      }.should raise_error(Mack::Errors::InvalidAuthenticityToken)
    end
    
    it "should not raise error when a valid authenticity token is present in post" do
      my_token = Digest::SHA1.hexdigest(session.id.to_s + "shh, it's a secret")
      lambda{
        post(violate_xss_check_url, :authenticity_token => my_token)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
    end
    
    it "should not raise error when a valid authenticity token and custom salt are both present" do
      temp_app_config("request_authenticity_token_salt" => "boo") do
        my_token = Digest::SHA1.hexdigest(session.id.to_s + "boo")
        lambda{
          post(violate_xss_check_url, :authenticity_token => my_token)
        }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      end
    end
    
    it "should not raise error when a valid authenticity token is present but custom salt is empty" do
      temp_app_config("request_authenticity_token_salt" => "") do
        my_token = Digest::SHA1.hexdigest(session.id.to_s + "shh, it's a secret")
        lambda{
          post(violate_xss_check_url, :authenticity_token => my_token)
        }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      end
    end
  end
  
  describe "Disabling forgery detector" do
    before(:all) do
      Mack::Routes.build do |r|
        r.forgery_test1 "/forgery_test1", :controller => :forgery_test, :action => :forgery_test1, :method => :post
        r.forgery_test2 "/forgery_test2", :controller => :forgery_test, :action => :forgery_test2, :method => :post
        r.forgery_test3 "/forgery_test3", :controller => :forgery_test, :action => :forgery_test3, :method => :post
        r.forgery_test4 "/forgery_test4", :controller => :forgery_test, :action => :forgery_test4, :method => :post
      
        r.forgery2_test1 "/forgery2_test1", :controller => :forgery_test2, :action => :test1, :method => :post
        r.forgery2_test2 "/forgery2_test2", :controller => :forgery_test2, :action => :test2, :method => :post
        r.forgery2_test3 "/forgery2_test3", :controller => :forgery_test2, :action => :test3, :method => :post
        r.forgery2_test4 "/forgery2_test4", :controller => :forgery_test2, :action => :test4, :method => :post
        
        r.forgery3_test1 "/forgery3_test1", :controller => :forgery_test3, :action => :test1, :method => :post
        r.forgery3_test2 "/forgery3_test2", :controller => :forgery_test3, :action => :test2, :method => :post
        r.forgery3_test3 "/forgery3_test3", :controller => :forgery_test3, :action => :test3, :method => :post
        r.forgery3_test4 "/forgery3_test4", :controller => :forgery_test3, :action => :test4, :method => :post
        
        r.forgery4_test1 "/forgery3_test1", :controller => :forgery_inheritance, :action => :test1, :method => :post
        r.forgery4_test2 "/forgery3_test2", :controller => :forgery_inheritance, :action => :test2, :method => :post
        r.forgery4_test3 "/forgery3_test3", :controller => :forgery_inheritance, :action => :test3, :method => :post
        r.forgery4_test4 "/forgery3_test4", :controller => :forgery_inheritance, :action => :test4, :method => :post
        r.forgery4_test5 "/forgery3_test5", :controller => :forgery_inheritance, :action => :test5, :method => :post        
      end
      a = "hello"
    end
    
    it "should handle :only" do
      lambda{
        post(forgery_test1_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery_test2_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery_test3_url)
      }.should raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery_test4_url)
      }.should raise_error(Mack::Errors::InvalidAuthenticityToken)
    end
    
    it "should handle :except" do
      lambda{
        post(forgery2_test1_url)
      }.should raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery2_test2_url)
      }.should raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery2_test3_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery2_test4_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
    end
    
    it "should handle disable all" do
      lambda{
        post(forgery3_test1_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery3_test2_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery3_test3_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery3_test4_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
    end
    
    it "should work in inherited controller" do
      lambda{
        post(forgery4_test1_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery4_test2_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery4_test3_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery4_test4_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(forgery4_test5_url)
      }.should raise_error(Mack::Errors::InvalidAuthenticityToken)
    end
    
  end
end