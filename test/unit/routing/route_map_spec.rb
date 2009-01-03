require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

class ChaptersController
  include Mack::Controller
  
  def show
    @chapters = params[:chaps]
    render(:text, 'hello')
  end
  
end

describe Mack::Routes::RouteMap do

  Mack::Routes.build do |r|
    r.chapter_show "/chapters/*chaps", :controller => :chapters, :action => :show
  end

  it "should map a wildcard to an array" do
    get '/chapters/1'
    assigns(:chapters).should == ["1"]
    get '/chapters/1/1a'
    assigns(:chapters).should == ["1", "1a"]
    get '/chapters/1/1a/1b'
    assigns(:chapters).should == ["1", "1a", "1b"]
  end

  it "should route to homepage" do
    get "/"
    response.body.should match(/tst_home_page: index/)
  end
  
  it "should route to user_index url" do
    get "/tst_users"
    response.body.should match(/tst_users: index/)
  end

  it "should route to users_show url" do
    get "/tst_users/1"
    response.body.should match(/tst_users: show: id: 1/)
  end
  
  it "should complain if requested undefined action" do
    lambda { get "/sadfasdfasdfasf" }.should raise_error(Mack::Errors::UndefinedRoute)
    lambda { get "/foo/bar/asg/asg/asg" }.should raise_error(Mack::Errors::UndefinedRoute)
    lambda { get "/tst_users/asgaga/asgasg/asg" }.should raise_error(Mack::Errors::UndefinedRoute)
  end
  
  it "should handle uri case properly" do
    get "/TST_users/1-HelloWorld"
    response.body.should match(/tst_users: show: id: 1-HelloWorld/)
    get "/tst_users/1-helloworld"
    response.body.should match(/tst_users: show: id: 1-helloworld/)
  end
  
  it "should have support for rails default style routes" do
    get "/tst_another/foo"
    response.body.should match(/tst_another_controller: foo: id: '' pickles: ''/)
  end
  
  it "should be case insensitive" do
    get "/TST_USERS/1"
    response.body.should match(/tst_users: show: id: 1/)
  end
  
  it "should support unescaped params" do
    get "/tst_users/Who%27s+Your+Daddy%21%3F%21"
    response.body.should match(/tst_users: show: id: Who's Your Daddy!?!/)
  end
  
  it "should handle redirect" do
    get "/my_old_foo"
    response.should be_redirect
    response.should be_redirected_to("/tst_another/foo/:id")
    
    get "/my_old_foo?id=1"
    response.should be_redirect
    response.should be_redirected_to("/tst_another/foo/1")
    
    get "/my_old_foo?id=1&pickles=yummy"
    response.should be_redirect
    response.should be_redirected_to("/tst_another/foo/1?pickles=yummy")
  end
  
  it "should not downcase post params" do
    post "/pickles", {:id => 1, :pickles => "ARE YUMMY!!"}
    response.body.should match(/tst_another_controller: foo: id: '1' pickles: 'ARE YUMMY!!'/)
    
    big_text = %{Decima et quinta decima eodem modo typi qui nunc nobis videntur parum clari fiant sollemnes in. Eros et accumsan et iusto odio; dignissim qui blandit praesent luptatum zzril delenit augue duis. Quam littera gothica quam nunc putamus parum claram anteposuerit litterarum formas humanitatis per seacula quarta. Qui facit eorum claritatem Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius claritas est. Ad minim veniam quis nostrud exerci tation ullamcorper suscipit lobortis nisl.}
    post "/pickles", {:id => 1, :pickles => big_text}
    response.body.should match(/tst_another_controller: foo: id: '1' pickles: '#{big_text}'/)
  end
  
end
