Mack::Routes.build do |r|

  r.connect "/", :controller => :tst_home_page
  r.connect "foo", :controller => :tst_home_page, :action => :foo
  r.pickles "/pickles", :controller => :tst_another, :action => :foo, :method => :post
  r.connect "hello_from_render_text", :controller => :tst_home_page, :action => :hello_from_render_text
  r.connect "/foo_from_render_action", :controller => :tst_home_page, :action => :foo_from_render_action
  r.connect "/blow_from_bad_render_action", :controller => :tst_home_page, :action => :blow_from_bad_render_action
  r.connect "blow_up_from_double_render", :controller => :tst_home_page, :action => :blow_up_from_double_render
  r.connect '/sess_test', :controller => :tst_home_page, :action => :read_param_from_session
  r.env '/env', :controller => :tst_another, :action => :env
                                                                        
  r.hello_world "/hello/world", :controller => :tst_home_page, :action => :hello_world
  
  r.old_foo "/my_old_foo", :redirect_to => "/tst_another/foo/:id", :status => 301
  
  r.kill_kenny_good "/tst_users/kill_kenny_good", :controller => :tst_users, :action => :kill_kenny_good
  r.kill_kenny_no_meth "/tst_another/kill_kenny", :controller => :tst_another, :action => :kill_kenny
  r.kill_kenny_bad "/tst_another/kill_kenny_bad", :controller => :tst_another, :action => :kill_kenny_bad
  r.resource :tst_users
  r.resource :tst_resources
  
  r.defaults
  
end
