require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent.parent.parent + 'spec_helper'

describe Mack::Utils::Ansi::Color do
  
  it "should wrap a string with the specified ansi color" do
    Mack::Utils::Ansi::Color.wrap(:blue, "hello").should == "\e[34mhello\e[0m"
  end
  
  it "should allow for new colors to be registered" do
    Mack::Utils::Ansi::ColorRegistry.add(:puece, 99)
    Mack::Utils::Ansi::Color.wrap(:puece, "hello").should == "\e[99mhello\e[0m"
  end
  
end