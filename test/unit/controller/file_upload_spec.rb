require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "File Upload Request" do
  
  it "should generate proper multipart content" do
    post upload_file_url, :multipart => true, :file0 => file_for_upload(File.join(File.dirname(__FILE__), 'images', "homer_brain.jpg")), :album => 'simpsons'
    assigns(:saved_file_name).should_not be_nil
    assigns(:saved_file_name).should == "homer_brain.jpg"
    assigns(:album).should_not be_nil
    assigns(:album).should == "simpsons"
  end
  
  it "should be able to upload multiple files" do  
    post upload_multiple_url, :multipart => true, :file0 => file_for_upload(File.join(File.dirname(__FILE__), 'images', "homer_brain.jpg")), :file1 => file_for_upload(File.join(File.dirname(__FILE__), 'images', "homer_brain2.jpg"))
    assigns(:saved_file1).should_not be_nil
    assigns(:saved_file2).should_not be_nil
    assigns(:saved_file1).should == "homer_brain.jpg"
    assigns(:saved_file2).should == "homer_brain2.jpg"
  end
  
  it 'should work with nested hash parameters' do
    post upload_file_url, :multipart => true, :file0 => file_for_upload(File.join(File.dirname(__FILE__), 'images', "homer_brain.jpg")), :album => 'simpsons', :user => {:username => 'mark'}
    assigns(:saved_file_name).should_not be_nil
    assigns(:saved_file_name).should == "homer_brain.jpg"
    assigns(:user).should_not be_nil
    assigns(:user)[:username].should == "mark"
  end
  
end