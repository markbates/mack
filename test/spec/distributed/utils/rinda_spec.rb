require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'
require 'rinda/ring'
require 'rinda/tuplespace'

describe "Rinda" do
  before(:all) do 
    begin
      DRb.start_service
      Rinda::RingServer.new(Rinda::TupleSpace.new)
      # DRb.thread.join
    rescue Errno::EADDRINUSE => e
      # it's fine to ignore this, it's expected that it's already running.
      # all other exceptions should be thrown
    end
    begin
      rs.take([:testing, :String, nil, nil], 0)
    rescue Exception => e
    end
  end
  
  it "should have access to the ring server" do
    rs = Mack::Distributed::Utils::Rinda.ring_server
    rs.should_not be_nil
    rs.is_a?(Rinda::TupleSpace).should == true
  end
  
  it "should be able to register new service" do
    str = String.randomize(40)
    rs = Mack::Distributed::Utils::Rinda.ring_server
    serv = nil
    lambda { rs.read([:testing, :String, nil, "test_register-#{str}"], 0)[2] }.should raise_error(Rinda::RequestExpiredError)
    Mack::Distributed::Utils::Rinda.register(:space => :testing, :klass_def => :String, :object => str, :description => "test_register-#{str}")
    serv = nil
    serv = rs.read([:testing, :String, nil, "test_register-#{str}"], 1)[2]
    serv.should_not be_nil
    serv.should == str
  end
  
  it "should be able to register or renew service(s)" do
    str = String.randomize(40)
    rs = Mack::Distributed::Utils::Rinda.ring_server
    serv = nil
    lambda { rs.read([:testing, :String, nil, "test_register_or_renew"], 0)[2] }.should raise_error(Rinda::RequestExpiredError)
    Mack::Distributed::Utils::Rinda.register_or_renew(:space => :testing, :klass_def => :String, :object => str, :description => "test_register_or_renew")
    serv = nil
    serv = rs.read([:testing, :String, nil, "test_register_or_renew"], 1)[2]
    serv.should_not be_nil
    serv.should == str
    
    str2 = String.randomize(40)
    Mack::Distributed::Utils::Rinda.register_or_renew(:space => :testing, :klass_def => :String, :object => str2, :description => "test_register_or_renew")
    serv = nil
    serv = rs.read([:testing, :String, nil, "test_register_or_renew"], 1)[2]
    serv.should_not be_nil
    serv.should == str2
    serv.should_not == str
  end
end
