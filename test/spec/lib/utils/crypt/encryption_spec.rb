require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent.parent + 'spec_helper'

describe Mack::Utils::Crypt do
  
  it "should be able to encrypt/decrypt using default worker" do
    Mack::Utils::Crypt::Keeper.instance.worker.is_a?(Mack::Utils::Crypt::DefaultWorker).should == true
    Mack::Utils::Crypt::Keeper.instance.worker(:unknown).is_a?(Mack::Utils::Crypt::DefaultWorker).should == true
    en = Mack::Utils::Crypt::Keeper.instance.worker.encrypt("hello world")
    en.should_not == "hello world"
    Mack::Utils::Crypt::Keeper.instance.worker.decrypt(en).should == "hello world"
  end
  
  it "should be able to encrypt/decrypt using other worker" do
    Mack::Utils::Crypt::Keeper.instance.worker(:reverse).is_a?(Mack::Utils::Crypt::ReverseWorker).should == true
    Mack::Utils::Crypt::Keeper.instance.worker(:reverse).encrypt("hello world").should == "dlrow olleh"
    Mack::Utils::Crypt::Keeper.instance.worker(:reverse).decrypt("dlrow olleh").should == "hello world"
  end
end
