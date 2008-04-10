require File.dirname(__FILE__) + '/../../test_helper.rb'

class TaskHelpersTest < Test::Unit::TestCase
  
  def test_rake_task
    old_user = ENV["USER"]
    assert old_user != "foobar"
    rake_task("test:empty", {"USER" => "foobar"}) do
      assert_equal "foobar", ENV["USER"]
      assert ENV["TEST:EMPTY"]
    end
    assert ENV["USER"] != "foobar"
    assert_equal old_user, ENV["USER"]
  end
  
  def test_rake_task_exception
    old_user = ENV["USER"]
    assert old_user != "foobar"
    assert_raise(RuntimeError) { rake_task("test:raise_exception", {"USER" => "foobar"}) }
    assert ENV["USER"] != "foobar"
    assert_equal old_user, ENV["USER"]
  end
  
end