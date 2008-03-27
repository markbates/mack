require File.dirname(__FILE__) + '/../../test_helper.rb'
class DistributedUrlsTest < Test::Unit::TestCase
  
  def test_runner
    d_url = Mack::Distributed::Routes::Urls.new("http://www.mackframework.com")
    assert_not_nil d_url
    assert_equal "http://www.mackframework.com", d_url.instance_variable_get("@dsd")
    d_url[:foo] = %{
      def foo
        @dsd + "/foo?123"
      end
    }
    runner_klass = d_url.run
    5.times do
      assert_equal runner_klass, d_url.run
    end
    assert_match "Mack::Distributed::Routes::Temp::M", runner_klass.class.to_s
    assert_equal "http://www.mackframework.com/foo?123", d_url.run.foo
  end
  
end