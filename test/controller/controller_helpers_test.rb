require File.dirname(__FILE__) + '/../test_helper.rb'

class ControllerHelpersTest < Test::Unit::TestCase
  
  def test_url_helper_works_in_correct_controller
    get kill_kenny_good_url
    assert_match "You killed Kenny!", response.body
  end
  
  def test_url_helper_blows_up_because_its_not_public
    assert_raise(Mack::Errors::ResourceNotFound) { get kill_kenny_no_meth_url }
  end
  
  def test_url_helper_blows_up_in_wrong_controller
    assert_raise(NameError) { get kill_kenny_bad_url }
  end
  
  def test_application_helper_included_everywhere
    get "/foo"
    assert_match "love you", response.body
    
    get "/tst_resources/1/edit"
    assert_match "love you", response.body
    
    get "/tst_another/say_love_you"
    assert_match "love you", response.body
  end
  
end