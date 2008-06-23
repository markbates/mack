require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

class MimeController < Mack::Controller::Base

  def index
    wants(:html) do
      render(:text, "HTML")
    end
    wants(:xml) do
      render(:text, "XML")
    end
    wants(:iphone) do
      render(:text, "IPHONE", :layout => false)
    end
    wants(:jpg) do
      render(:text, "JPG", :layout => false)
    end
  end

end

describe "MIME Types" do
  
  describe "=> Pre-defined Types" do
    
    before(:each) do
      Mack::Routes.build do |r|
        r.marceau "/marceau/marceau", :controller => "mime"
      end
    end
    it "should handle HTML type" do
      get(marceau_url(:format => :html))
      response.body.should match(/HTML/)
      response["Content-Type"].should == "text/html"
    end
    
    it "should handle XML type" do
      get(marceau_url(:format => :xml))
      response.body.should match(/XML/)
      response["Content-Type"].should == "application/xml; text/xml"
    end
    
    it "should handle iPhone type" do
      get(marceau_url(:format => :iphone))
      response.body.should match(/IPHONE/)
      response["Content-Type"].should == "app/iphone"
    end
    
    it "should handle JPEG type" do
      get(marceau_url(:format => :jpg))
      response.body.should match(/JPG/)
      response["Content-Type"].should == "image/jpeg; image/pjpeg"
    end
  end
  describe "=> Newly Defined Types" do
    
    before(:each) do
      Mack::Routes.build do |r|
        r.marceau "/marceau/marceau", :controller => "mime"
      end
      
      Mack::Utils::MimeTypes.register(:iphone, "application/mac-iphone")
    end
    
    it "should handle the new type" do
      get(marceau_url(:format => :iphone))
      response.body.should match(/IPHONE/)
      response["Content-Type"].should == "app/iphone; application/mac-iphone"
    end
  end
end
