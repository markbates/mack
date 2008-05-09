require File.dirname(__FILE__) + '/../test_helper.rb'

class CookieJarTest < Test::Unit::TestCase
  
  def test_set_cookie
    get "/tst_home_page/write_cookie?bourne=the_bourne_identity"
    assert_cookie(:bourne, "the_bourne_identity")
    assert_no_cookie(:woody)
  end
  
  def test_set_two_cookies
    get "/tst_home_page/write_two_cookies?bourne=the_bourne_identity&woody=annie_hall"
    assert_cookie(:bourne, "the_bourne_identity")
    assert_cookie(:woody, "annie_hall")
  end
  
end