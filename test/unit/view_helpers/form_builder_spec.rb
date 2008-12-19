require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::View::FormBuilder do
  
  class StarWarsFormBuilder
    include Mack::View::FormBuilder
    
    def text_field(*args)
      "<p>#{element(:text_field, *args)}</p>"
    end
    
  end
  
  class GodfatherFormBuilder
    include Mack::View::FormBuilder
    
    def text_field(*args)
      "<p>#{element(:text_field, *args)}</p>"
    end
    
    def all(sym, *args)
      "<i>#{element(sym, *args)}</i>"
    end
    
  end
  
  class StarWarsController
    include Mack::Controller
  end
  
  before(:each) do
    @sw = StarWarsFormBuilder.new(Mack::Rendering::ViewTemplate.new(:text, ''))
    @gf = GodfatherFormBuilder.new(Mack::Rendering::ViewTemplate.new(:text, ''))
  end
  
  it 'should wrap a text_field with paragraphs' do
    @sw.text_field(:skywalker, :value => 1).should == %{<p><input id="skywalker" name="skywalker" type="text" value="1" /></p>}
  end
  
  it 'should pass on any method it doesnt have to Mack::ViewHelpers::FormHelpers' do
    @sw.password_field(:skywalker, :value => 1).should == %{<input id="skywalker" name="skywalker" type="password" value="1" />}
  end
  
  it 'should work' do
    get '/star_wars/skywalker'
    response.should be_successful
    response.body.should match(%{<p><input id="solo" name="solo" type="text" value="Han Solo" /></p>})
  end
  
  it 'should use the all method if available' do
    @gf.text_field(:skywalker, :value => 1).should == %{<p><input id="skywalker" name="skywalker" type="text" value="1" /></p>}
    @gf.password_field(:skywalker, :value => 1).should == %{<i><input id="skywalker" name="skywalker" type="password" value="1" /></i>}
  end 
  
  describe 'partial' do

    class StripesController
      include Mack::Controller
    end
    
    class StripesBuilder
      include Mack::View::FormBuilder
      
      partial :text_field, 'fb_partials/text_field'
      partial :all, 'fb_partials/all'
    end
    
    it 'should render a partial if told to' do
      get '/stripes/index'
      response.should be_successful
      response.body.should match(%{<h1><input id="murray" name="murray" type="text" value="Bill Murray" /></h1>})
      response.body.should match(%{<h2><input id="ramis" name="ramis" type="password" value="Harold Ramis" /></h2>})
    end
    
  end
  
end