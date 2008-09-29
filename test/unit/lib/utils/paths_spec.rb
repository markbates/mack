require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent.parent + 'spec_helper'

describe Mack::Paths do
  
  describe "public" do
    
    it "should give the path to the public directory" do
      Mack::Paths.public.should == File.join(Mack.root, "public")
    end
    
    it "should join the file name given with the public directory path" do
      Mack::Paths.public("index.html").should == File.join(Mack.root, "public", "index.html")
    end
    
    it "should join the file names given with the public directory path" do
      Mack::Paths.public("foo", "index.html").should == File.join(Mack.root, "public", "foo", "index.html")
    end
    
  end
  
  describe "images" do
    
    it "should give the path to the images directory" do
      Mack::Paths.images.should == File.join(Mack::Paths.public, "images")
    end
    
  end
  
  describe "javascripts" do
    
    it "should give the path to the javascripts directory" do
      Mack::Paths.javascripts.should == File.join(Mack::Paths.public, "javascripts")
    end
    
  end
  
  describe "stylesheets" do
    
    it "should give the path to the stylesheets directory" do
      Mack::Paths.stylesheets.should == File.join(Mack::Paths.public, "stylesheets")
    end
    
  end
  
  describe "app" do
    
    it "should give the path to the app directory" do
      Mack::Paths.app.should == File.join(Mack.root, "app")
    end
    
    it "should join the file name given with the app directory path" do
      Mack::Paths.app("index.html").should == File.join(Mack.root, "app", "index.html")
    end
    
    it "should join the file names given with the public directory path" do
      Mack::Paths.app("foo", "index.html").should == File.join(Mack.root, "app", "foo", "index.html")
    end
    
  end
  
  describe "lib" do
    
    it "should give the path to the lib directory" do
      Mack::Paths.lib.should == File.join(Mack.root, "lib")
    end
    
  end
  
  describe "log" do
    
    it "should give the path to the log directory" do
      Mack::Paths.log.should == File.join(Mack.root, "log")
    end
    
  end
  
  describe "test" do
    
    it "should give the path to the test directory" do
      Mack::Paths.test.should == File.join(Mack.root, "test")
    end
    
  end
  
  # describe "functional" do
  #   
  #   it "should give the path to the functional directory" do
  #     Mack::Paths.functional.should == File.join(Mack::Paths.test, "functional")
  #   end
  #   
  # end
  # 
  # describe "unit" do
  #   
  #   it "should give the path to the unit directory" do
  #     Mack::Paths.unit.should == File.join(Mack::Paths.test, "unit")
  #   end
  #   
  # end
  
  describe "tasks" do
    
    it "should give the path to the tasks directory" do
      Mack::Paths.tasks.should == File.join(Mack::Paths.lib, "tasks")
    end
    
  end
  
  describe "config" do
    
    it "should give the path to the config directory" do
      Mack::Paths.config.should == File.join(Mack.root, "config")
    end
    
  end
  
  describe "configatron" do
    
    it "should give the path to the configatron directory" do
      Mack::Paths.configatron.should == File.join(Mack::Paths.config, "configatron")
    end
    
  end
  
  describe "initializers" do
    
    it "should give the path to the initializers directory" do
      Mack::Paths.initializers.should == File.join(Mack::Paths.config, "initializers")
    end
    
  end
  
  describe "views" do
    
    it "should give the path to the views directory" do
      Mack::Paths.views.should == File.join(Mack::Paths.app, "views")
    end
    
    it 'should correctly take an array' do
      Mack::Paths.views('foo', 'bar').should == File.join(Mack::Paths.app, 'views', 'foo', 'bar')
    end
    
  end
  
  describe "controllers" do
    
    it "should give the path to the controllers directory" do
      Mack::Paths.controllers.should == File.join(Mack::Paths.app, "controllers")
    end
    
  end
  
  describe "helpers" do
    
    it "should give the path to the helpers directory" do
      Mack::Paths.helpers.should == File.join(Mack::Paths.app, "helpers")
    end
    
  end
  
  describe "models" do
    
    it "should give the path to the models directory" do
      Mack::Paths.models.should == File.join(Mack::Paths.app, "models")
    end
    
  end
  
  describe "layouts" do
    
    it "should give the path to the layouts directory" do
      Mack::Paths.layouts.should == File.join(Mack::Paths.views, "layouts")
    end
    
  end
  
  describe "db" do
    
    it "should give the path to the db directory" do
      Mack::Paths.db.should == File.join(Mack.root, "db")
    end
    
  end
  
  describe "migrations" do
    
    it "should give the path to the migrations directory" do
      Mack::Paths.migrations.should == File.join(Mack::Paths.db, "migrations")
    end
    
  end
  
  describe "vendor" do
    
    it "should give the path to the vendor directory" do
      Mack::Paths.vendor.should == File.join(Mack.root, "vendor")
    end
    
  end
  
  describe "plugins" do
    
    it "should give the path to the plugins directory" do
      Mack::Paths.plugins.should == File.join(Mack::Paths.vendor, "plugins")
    end
    
  end
  
end