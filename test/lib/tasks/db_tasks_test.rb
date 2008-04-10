require File.dirname(__FILE__) + '/../../test_helper.rb'

class DbTasksTest < Test::Unit::TestCase
  
  def setup
    cleanup
  end
  
  def teardown
    cleanup
  end
  
  def test_db_migrate
    rake_task("db:migrate", {"USER" => "foobar"}) do
      assert true
    end
  end
  
  private
  def cleanup
    db_loc = File.join(MACK_ROOT, "db", "fake_application_test.db")
    FileUtils.rm_r(db_loc) if File.exists?(db_loc)
  end
  
end