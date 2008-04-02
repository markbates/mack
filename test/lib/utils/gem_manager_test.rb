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
    g = add_gem(:gem_1)
    assert_equal "gem_1", g.to_s
    assert !g.libs?

    g = add_gem(:gem_2, :version => "1.2.2")
    assert_equal "gem_2-1.2.2", g.to_s
    assert !g.libs?

    g = add_gem(:gem_2, :version => "1.2.2", :libs => :gem_2)
    assert_equal "gem_2-1.2.2", g.to_s
    assert g.libs?
  end
  
  def test_libs
    g = add_gem(:gem_1)
    assert !g.libs?
    assert_equal [], g.libs
    
    g = add_gem(:gem_1, :libs => :foo)
    assert g.libs?
    assert_equal [:foo], g.libs
    
    g = add_gem(:gem_1, :libs => [:foo])
    assert g.libs?
    assert_equal [:foo], g.libs
    
    g = add_gem(:gem_1, :libs => [:foo, "bar"])
    assert g.libs?
    assert_equal [:foo, "bar"], g.libs
  end
  
  def test_version
    g = add_gem(:gem_1)
    assert !g.version?
    
    g = add_gem(:gem_1, :version => "1.0.0")
    assert g.version?
    assert_equal "1.0.0", g.version
  end
  
  def test_source
    g = add_gem(:gem_1)
    assert !g.source?
    
    g = add_gem(:gem_1, :source => "http://gems.rubyforge.org")
    assert g.source?
    assert_equal "http://gems.rubyforge.org", g.source
  end
  
  def test_to_s
    g = add_gem(:gem_1)
    assert_equal "gem_1", g.to_s
    
    g = add_gem(:gem_1, :version => "1.0.0")
    assert_equal "gem_1-1.0.0", g.to_s
  end
  
  def test_do_requires
    g = add_gem(:termios)
    assert_equal "termios", g.to_s
    gem_manager.do_requires
    g = add_gem(:redgreen, :version => "1.2.2")
    g = add_gem(:redgreen, :version => "1.2.3", :libs => :redgreen)
    assert_equal "redgreen-1.2.3", gem_manager.required_gem_list.last.to_s
    assert_raise(Gem::LoadError) { gem_manager.do_requires }
  end
  
  private
  
  def add_gem(name, options = {})
    assert_difference(gem_manager.required_gem_list, :size) do
      require_gems {|g| g.add(name, options)}
      return gem_manager.required_gem_list.last
    end
  end

  def gem_manager
    Mack::Utils::GemManager.instance
  end

end