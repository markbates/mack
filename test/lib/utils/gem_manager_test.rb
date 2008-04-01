require File.dirname(__FILE__) + '/../../test_helper.rb'

class GemManagerTest < Test::Unit::TestCase

  def setup
    @required_gems = gem_manager.required_gem_list.dup
    gem_manager.required_gem_list = []
  end
  
  def teardown
    gem_manager.required_gem_list = @required_gems
  end

  def test_add
    assert_difference(gem_manager.required_gem_list, :size) do
      require_gems do |g|
        g.add("termios")
      end
      assert_equal({:name => "termios", :version => nil, :require_file => nil}, gem_manager.required_gem_list.last)
    end
    assert_difference(gem_manager.required_gem_list, :size) do
      require_gems do |g|
        g.add("redgreen", "1.2.2")
      end
      assert_equal({:name => "redgreen", :version => "1.2.2", :require_file => nil}, gem_manager.required_gem_list.last)
    end
    assert_difference(gem_manager.required_gem_list, :size) do
      require_gems do |g|
        g.add("redgreen", "1.2.2", "redgreen")
      end
      assert_equal({:name => "redgreen", :version => "1.2.2", :require_file => "redgreen"}, gem_manager.required_gem_list.last)
    end
  end
  
  def test_do_requires
    assert_difference(gem_manager.required_gem_list, :size) do
      require_gems do |g|
        g.add("termios")
      end
      assert_equal({:name => "termios", :version => nil, :require_file => nil}, gem_manager.required_gem_list.last)
      gem_manager.do_requires
    end
    assert_difference(gem_manager.required_gem_list, :size, 2) do
      require_gems do |g|
        g.add("redgreen", "1.2.2")
        g.add("redgreen", "1.2.3", "redgreen")
      end
      assert_equal({:name => "redgreen", :version => "1.2.3", :require_file => "redgreen"}, gem_manager.required_gem_list.last)
    end
    assert_raise(Gem::LoadError) { gem_manager.do_requires }
  end
  
  private

  def gem_manager
    Mack::Utils::GemManager.instance
  end

end