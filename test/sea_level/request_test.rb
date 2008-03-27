require File.dirname(__FILE__) + '/../test_helper.rb'

class RequestTest < Test::Unit::TestCase
  
  def test_full_host
    get "/tst_home_page/request_full_host"
    assert_match "http://example.org", response.body
  end
  
  def test_full_host_with_port
    get "/tst_home_page/request_full_host_with_port"
    assert_match "http://example.org:80", response.body
  end
  
  def test_session_gets_set
    in_session do
      get "/tst_home_page/read_param_from_session"
      assert_not_nil session
      t = session[:my_time]
      assert_not_nil t
      assert_match t.to_s, response.body
      sleep(1)
      get "/tst_home_page/read_param_from_session"
      assert_not_nil session
      assert_equal t.to_s, session[:my_time].to_s
    end
  end
  
  def test_params_returns_regardless_of_string_or_symbol
    get "/tst_another/regardless_of_string_or_symbol?foo=bar"
    assert_match "from_string: foo=bar", response.body
    assert_match "from_symbol: foo=bar", response.body
  end
  
  def test_nested_params_return_as_hash
    post "/tst_another/params_return_as_hash", :foo => {:one => "one", :two => "too", :three => 3}
    assert_match "class: Hash", response.body
  end
  
end