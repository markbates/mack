require File.dirname(__FILE__) + '/../test_helper.rb'

class EngineTest < Test::Unit::TestCase
  
  def test_register_new
    assert !Mack::Rendering::Engine::Registry.engines.has_key?(:foo)
    Mack::Rendering::Engine::Registry.register(:foo, :erb)
    assert Mack::Rendering::Engine::Registry.engines.has_key?(:foo)
    assert_equal [:erb], Mack::Rendering::Engine::Registry.engines[:foo]
  end
  
  def test_register_existing
    Mack::Rendering::Engine::Registry.register(:bar, :erb)
    assert Mack::Rendering::Engine::Registry.engines.has_key?(:bar)
    Mack::Rendering::Engine::Registry.register(:bar, :sass)
    assert_equal [:sass, :erb], Mack::Rendering::Engine::Registry.engines[:bar]
  end
  
end