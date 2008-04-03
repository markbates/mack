require File.dirname(__FILE__) + '/../../test_helper.rb'
class RindaTest < Test::Unit::TestCase
  
  def setup
    puts `mack_ring_server restart`
  end
  
  def test_ring_server
    rs = Mack::Distributed::Utils::Rinda.ring_server
    assert_not_nil rs
    assert rs.is_a?(DRb::DRbObject)
  end
  
  def test_register
    str = String.randomize(40)
    rs = Mack::Distributed::Utils::Rinda.ring_server
    serv = nil
    assert_raise(Rinda::RequestExpiredError) { rs.read([:testing, :String, nil, "test_register-#{str}"], 0)[2] }
    Mack::Distributed::Utils::Rinda.register(:space => :testing, :klass_def => :String, :object => str, :description => "test_register-#{str}")
    serv = nil
    serv = rs.read([:testing, :String, nil, "test_register-#{str}"], 1)[2]
    assert_not_nil serv
    assert_equal str, serv
  end
  
  def test_register_or_renew
    str = String.randomize(40)
    rs = Mack::Distributed::Utils::Rinda.ring_server
    serv = nil
    assert_raise(Rinda::RequestExpiredError) { rs.read([:testing, :String, nil, "test_register_or_renew"], 0)[2] }
    Mack::Distributed::Utils::Rinda.register_or_renew(:space => :testing, :klass_def => :String, :object => str, :description => "test_register_or_renew")
    serv = nil
    serv = rs.read([:testing, :String, nil, "test_register_or_renew"], 1)[2]
    assert_not_nil serv
    assert_equal str, serv
    
    str2 = String.randomize(40)
    Mack::Distributed::Utils::Rinda.register_or_renew(:space => :testing, :klass_def => :String, :object => str2, :description => "test_register_or_renew")
    serv = nil
    serv = rs.read([:testing, :String, nil, "test_register_or_renew"], 1)[2]
    assert_not_nil serv
    assert_equal str2, serv
    assert serv != str
  end
  
end