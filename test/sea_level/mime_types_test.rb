require File.dirname(__FILE__) + '/../test_helper.rb'

class MimeTypesTest < Test::Unit::TestCase

  class MimeController < Mack::Controller::Base
    
    def index
      wants(:html) do
        render(:text => "HTML")
      end
      wants(:xml) do
        render(:text => "XML")
      end
      wants(:iphone) do
        render(:text => "IPHONE")
      end
      wants(:jpg) do
        render(:text => "JPG")
      end
    end
    
  end
  
  Mack::Routes.build do |r|
    r.marceau "/marceau/marceau", :controller => "mime_types_test/mime"
  end
  
  def test_mime_types
    get(marceau_url(:format => :html))
    assert_match "HTML", response.body
    assert_equal "text/html", response["Content-Type"]
    
    get(marceau_url(:format => :xml))
    assert_match "XML", response.body
    assert_equal "application/xml; text/xml", response["Content-Type"]
    
    get(marceau_url(:format => :iphone))
    assert_match "IPHONE", response.body
    assert_equal "app/iphone", response["Content-Type"]
    
    get(marceau_url(:format => :jpg))
    assert_match "JPG", response.body
    assert_equal "image/jpeg; image/pjpeg", response["Content-Type"]
  end

end