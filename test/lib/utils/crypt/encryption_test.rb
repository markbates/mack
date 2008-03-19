require File.dirname(__FILE__) + '/../../../test_helper.rb'

class EncryptionTest < Test::Unit::TestCase
  
  def test_default_worker
    assert Mack::Utils::Crypt::Keeper.instance.worker.is_a?(Mack::Utils::Crypt::DefaultWorker)
    assert Mack::Utils::Crypt::Keeper.instance.worker(:unknown).is_a?(Mack::Utils::Crypt::DefaultWorker)
    en = Mack::Utils::Crypt::Keeper.instance.worker.encrypt("hello world")
    assert en != "hello world"
    assert_equal "hello world", Mack::Utils::Crypt::Keeper.instance.worker.decrypt(en)
  end
  
  def test_another_worker
    assert Mack::Utils::Crypt::Keeper.instance.worker(:reverse).is_a?(Mack::Utils::Crypt::ReverseWorker)
    assert_equal "dlrow olleh", Mack::Utils::Crypt::Keeper.instance.worker(:reverse).encrypt("hello world")
    assert_equal "hello world", Mack::Utils::Crypt::Keeper.instance.worker(:reverse).decrypt("dlrow olleh")
  end
  
end