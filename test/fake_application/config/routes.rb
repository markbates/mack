Mack::Routes.build do |r|

  r.resource "admin/users"
  
  r.with_options(:controller => :tst_home_page) do |map|
    map.connect "/"
    map.connect "foo", :action => :foo
    map.connect "hello_from_render_text", :action => :hello_from_render_text
    map.connect "/foo_from_render_action", :action => :foo_from_render_action
    map.connect "/blow_from_bad_render_action", :action => :blow_from_bad_render_action
    map.connect "blow_up_from_double_render", :action => :blow_up_from_double_render
    map.connect '/sess_test', :action => :read_param_from_session
    map.hello_world "/hello/world", :action => :hello_world
  end
  
  r.with_options(:controller => :tst_another) do |map|
    map.pickles "/pickles", :action => :foo, :method => :post
    map.env '/env', :action => :env
    map.kill_kenny_no_meth "/tst_another/kill_kenny", :action => :kill_kenny
    map.kill_kenny_bad "/tst_another/kill_kenny_bad", :action => :kill_kenny_bad
  end
  

  
  r.old_foo "/my_old_foo", :redirect_to => "/tst_another/foo/:id", :status => 301
  
  r.kill_kenny_good "/tst_users/kill_kenny_good", :controller => :tst_users, :action => :kill_kenny_good
  r.resource :tst_users
  r.resource :tst_resources
  
  r.defaults
  
end
