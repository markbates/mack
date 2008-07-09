require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::CookieJar do
  
  it "should be able to set 1 cookie" do
    get "/tst_home_page/write_cookie?bourne=the_bourne_identity"
    cookies["bourne"].should == "the_bourne_identity"
    cookies["woody"].should be_nil
  end
  
  it "should be able to set 2 cookies" do
    get "/tst_home_page/write_two_cookies?bourne=the_bourne_identity&woody=annie_hall"
    cookies["bourne"].should == "the_bourne_identity"
    cookies["woody"].should == "annie_hall"
  end
  
end
