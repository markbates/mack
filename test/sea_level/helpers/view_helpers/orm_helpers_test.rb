require File.dirname(__FILE__) + '/../../../test_helper.rb'

class HtmlHelpersTest < Test::Unit::TestCase
  
  include Mack::ViewHelpers::OrmHelpers
  
  def test_data_mapper_error_messages_for
    use_data_mapper do
      common
      assert true
    end
  end
  
  def test_active_record_error_messages_for
    use_active_record do
      common
      assert true
    end
  end
  
  def common
    # ModelGenerator.run("name" => "zoo", "cols" => "name:string,description:text")
  end
  
  def cleanup
    model_generator_cleanup
  end
  
end