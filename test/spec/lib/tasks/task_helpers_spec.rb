require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "Task Helper" do
  
  it "should handle rake_task" do
    old_user = ENV["USER"]
    old_user.should_not == "foobar"
    rake_task("test:empty", {"USER" => "foobar"}) do
      ENV["USER"].should == "foobar"
      ENV["TEST:EMPTY"].should == "true"
    end
    ENV["USER"].should_not == "foobar"
    ENV["USER"].should == old_user
  end
  
  it "should handle rake_task_exception" do
    old_user = ENV["USER"]
    old_user.should_not == "foobar"
    lambda { rake_task("test:raise_exception", {"USER" => "foobar"}) }.should raise_error(RuntimeError) 
    ENV["USER"].should_not == "foobar"
    ENV["USER"].should == old_user
  end
  
end
