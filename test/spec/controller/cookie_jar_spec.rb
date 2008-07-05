require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::CookieJar do
  
  it "should be able to set 1 cookie" do
    get "/tst_home_page/write_cookie?bourne=the_bourne_identity"
    assert_cookie(:bourne, "the_bourne_identity")
    assert_no_cookie(:woody)
  end
  
  it "should be able to set 2 cookies" do
    get "/tst_home_page/write_two_cookies?bourne=the_bourne_identity&woody=annie_hall"
    assert_cookie(:bourne, "the_bourne_identity")
    assert_cookie(:woody, "annie_hall")
  end
  
end
