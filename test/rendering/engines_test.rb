require File.dirname(__FILE__) + '/../test_helper.rb'

module Mack
  module Rendering
    module Engines
      class Crazy # :nodoc:
      end # Public
    end # Engines
  end # Rendering
end # Mack

class EnginesTest < Test::Unit::TestCase
  
  def test_register_new
    assert !Mack::Rendering::Engines::Registry.engines.has_key?(:foo)
    Mack::Rendering::Engines::Registry.register(:foo, {:engine => Mack::Rendering::Engines::Erb, :extension => :foo})
    assert Mack::Rendering::Engines::Registry.engines.has_key?(:foo)
    assert_equal [{:engine => Mack::Rendering::Engines::Erb, :extension => :foo}], Mack::Rendering::Engines::Registry.engines[:foo]
  end
  
  def test_register_existing
    assert Mack::Rendering::Engines::Registry.engines.has_key?(:action)
    Mack::Rendering::Engines::Registry.register(:action, {:engine => Mack::Rendering::Engines::Crazy, :extension => :czy})
    assert_equal [{:engine => Mack::Rendering::Engines::Crazy, :extension => :czy},
                  {:engine => Mack::Rendering::Engines::Erb, :extension => :erb}], Mack::Rendering::Engines::Registry.engines[:action]
  end
  
end