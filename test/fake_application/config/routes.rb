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
  
  r.with_options(:controller => "vtt/view_template") do |map|
    map.bart_html_erb_with_layout "/vtt/bart_html_erb_with_layout", :action => :bart_html_erb_with_layout
    map.bart_html_erb_without_layout "/vtt/bart_html_erb_without_layout", :action => :bart_html_erb_without_layout
    map.bart_html_erb_with_special_layout "/vtt/bart_html_erb_with_special_layout", :action => :bart_html_erb_with_special_layout
    map.lisa_text_erb_with_layout "/vtt/lisa_text_erb_with_layout", :action => :lisa_text_erb_with_layout
    map.lisa_text_erb_without_layout "/vtt/lisa_text_erb_without_layout", :action => :lisa_text_erb_without_layout
    map.lisa_text_erb_with_special_layout "/vtt/lisa_text_erb_with_special_layout", :action => :lisa_text_erb_with_special_layout
    map.with_options(:format => :xml) do |x|
      x.homer_xml_with_layout "/vtt/homer_xml_with_layout", :action => :homer_xml_with_layout
      x.homer_xml_without_layout "/vtt/homer_xml_without_layout", :action => :homer_xml_without_layout
      x.homer_xml_with_special_layout "/vtt/homer_xml_with_special_layout", :action => :homer_xml_with_special_layout
    end
    map.good_get "/vtt/good_get", :action => :good_get_url
    map.bad_get "/vtt/bad_get", :action => :bad_get_url
    map.bad_with_raise "/vtt/bad_with_raise", :action => :bad_with_raise_url
    map.with_options(:method => :post) do |x|
      x.good_post "/vtt/good_post", :action => :good_post_url
      x.bad_post "/vtt/bad_post", :action => :bad_post_url
      x.bad_post_with_raise "/vtt/bad_post_with_raise", :action => :bad_post_with_raise_url
    end
    map.good_put "/vtt/good_put", :action => :good_put_url, :method => :put
    map.good_put "/vtt/good_delete", :action => :good_delete_url, :method => :delete
  end
  
  r.old_foo "/my_old_foo", :redirect_to => "/tst_another/foo/:id", :status => 301
  
  r.kill_kenny_good "/tst_users/kill_kenny_good", :controller => :tst_users, :action => :kill_kenny_good
  r.resource :tst_users
  r.resource :tst_resources
  
  r.defaults
  
end
