require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe PassengerGenerator do
  
  before(:each) do
    @config_ru = Mack::Paths.root("config.ru")
    @readme = Mack::Paths.tmp("README")
    FileUtils.rm_rf(@config_ru)
    FileUtils.rm_rf(@readme)
  end
  
  it "should generate the files needed to run Mack with Passenger" do
    File.should_not be_exists(@config_ru)
    File.should_not be_exists(@readme)
    PassengerGenerator.run
    File.should be_exists(@config_ru)
    File.should be_exists(@readme)
    File.read(@config_ru).should == fixture("config.ru")
  end
  
end