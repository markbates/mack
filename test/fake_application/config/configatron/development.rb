configatron do |c|
  c.namespace(:mack) do |mack|
    mack.session_id = '_my_fake_app_session_id'
    mack.use_distributed_routes = false
    mack.distributed_app_name = 'fake_app'
  end
end