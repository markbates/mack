configatron do |c|
  c.foo = 'bar'
  c.namespace(:mack) do |mack|
    mack.page_cache = true
    mack.session_id = '_my_fake_app_session_id'
    mack.use_distributed_routes = false
    mack.distributed_app_name = 'fake_app'
    mack.testing_framework = :rspec
    mack.test_facets = 24.hours
  end
  c.test_facets = 15.minutes
end