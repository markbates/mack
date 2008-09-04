require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

class XSS1Controller
  include Mack::Controller
  disable_request_validation :only => ['test1', 'test2']
  
  def test1
  end
  
  def test2
  end
  
  def test3
  end
  
  def test4
  end
end

class XSS2Controller
  include Mack::Controller
  disable_request_validation :except => ['test1', 'test2']
  
  def test1
  end
  
  def test2
  end
   
  def test3
  end
  
  def test4
  end
end

describe 'Request Authenticity' do
  
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
  
  describe 'Request validation' do
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
  
  describe "Disabling request validation" do
    before(:all) do
      Mack::Routes.build do |r|
        r.xss1_test1 "/test1", :controller => :xss1, :action => :test1
        r.xss1_test2 "/test2", :controller => :xss1, :action => :test2
        r.xss1_test3 "/test3", :controller => :xss3, :action => :test3
        r.xss1_test4 "/test4", :controller => :xss4, :action => :test4
      end
    end
    
    it "should handle :only" do
      lambda{
        post(xss1_test1_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(xss1_test2_url)
      }.should_not raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(xss1_test3_url)
      }.should raise_error(Mack::Errors::InvalidAuthenticityToken)
      lambda{
        post(xss1_test4_url)
      }.should raise_error(Mack::Errors::InvalidAuthenticityToken)
    end
    
    it "should handle :except"
    
    it "should handle disable all"
  end
end