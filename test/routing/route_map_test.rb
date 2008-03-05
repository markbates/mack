require File.dirname(__FILE__) + '/../test_helper.rb'
class RouteMapTest < Test::Unit::TestCase
  
  def test_homepage
    get "/"
    assert_match "tst_home_page: index", response.body
  end
  
  def test_users_index
    get "/tst_users"
    assert_match "tst_users: index", response.body
  end
  
  def test_users_show
    get "/tst_users/1"
    assert_match "tst_users: show: id: 1", response.body
  end
  
  def test_undefined_action
    assert_raise(Mack::Errors::UndefinedRoute) { get "/sadfasdfasdfasf" }
    assert_raise(Mack::Errors::UndefinedRoute) { get "/foo/bar/asdf/asdf/asdf" }
    assert_raise(Mack::Errors::UndefinedRoute) { get "/tst_users/sadfasdfasdfasf/asfdasdfa/asfd" }
  end
  
  def test_rails_default_style_routes
    get "/tst_another/foo"
    assert_match "tst_another_controller: foo: id: '' pickles: ''", response.body
  end
  
  def test_matching_is_case_insensitive
    get "/TST_USERS/1"
    assert_match "tst_users: show: id: 1", response.body
  end
  
  def test_params_are_unescaped
    get "/tst_users/Who%27s+Your+Daddy%21%3F%21"
    # params are automatically downcased when they come in.
    assert_match "tst_users: show: id: who's your daddy!?!", response.body
  end
  
  def test_post_params_are_not_downcased
    post "/pickles", {:id => 1, :pickles => "ARE YUMMY!!"}
    assert_match "tst_another_controller: foo: id: '1' pickles: 'ARE YUMMY!!'", response.body
    
    big_text = %{
      Decima et quinta decima eodem modo typi qui nunc nobis videntur parum clari fiant sollemnes in. Eros et accumsan et iusto odio; dignissim qui blandit praesent luptatum zzril delenit augue duis. Quam littera gothica quam nunc putamus parum claram anteposuerit litterarum formas humanitatis per seacula quarta. Qui facit eorum claritatem Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius claritas est. Ad minim veniam quis nostrud exerci tation ullamcorper suscipit lobortis nisl.
    
      Legere me lius quod ii legunt saepius claritas est etiam. Delenit augue duis dolore te feugait, nulla facilisi nam liber. Exerci tation ullamcorper suscipit lobortis nisl ut aliquip, ex ea commodo consequat duis. Facit eorum claritatem Investigationes demonstraverunt lectores, processus dynamicus qui sequitur.
    
      Duis dolore te feugait nulla facilisi nam liber tempor cum soluta nobis eleifend option congue! Quinta decima eodem modo typi qui nunc nobis videntur parum. Placerat facer possim assum typi non habent claritatem insitam est. Consequat vel illum dolore eu; feugiat nulla facilisis at vero eros? Dolor in hendrerit in vulputate: velit esse molestie et accumsan. Quam nunc putamus, parum claram anteposuerit litterarum formas humanitatis per seacula. Lobortis nisl ut aliquip ex ea commodo consequat duis autem vel eum iriure?
    
      Eros et accumsan et iusto odio dignissim, qui blandit praesent luptatum zzril delenit augue. Gothica quam nunc putamus parum claram anteposuerit litterarum formas humanitatis per. Habent claritatem insitam, est usus legentis in iis qui. Et quinta decima eodem modo typi qui, nunc nobis videntur parum clari fiant sollemnes in.}
    
    post "/pickles", {:id => 1, :pickles => big_text}
    assert_match %{tst_another_controller: foo: id: '1' pickles: '#{big_text}'}, response.body
  end
  
  def test_redirect
    get "/my_old_foo"
    assert_response :redirect
    assert_redirected_to "/tst_another/foo/:id"
    
    get "/my_old_foo?id=1"
    assert_response :redirect
    assert_redirected_to "/tst_another/foo/1"
    
    get "/my_old_foo?id=1&pickles=yummy"
    assert_response :redirect
    assert_redirected_to "/tst_another/foo/1?pickles=yummy"
  end
  
end