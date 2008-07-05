require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

module Mack
  module Utils
    module Crypt
      class ReverseWorker
        
        def encrypt(x)
          x.reverse
        end
        
        def decrypt(x)
          x.reverse
        end
        
      end
    end
  end
end

describe Kernel do
  
  describe "Encryption Engine" do
    
    it "should be able to encrypt text using the reverse worker" do
      _encrypt("hello world", :reverse).should == "dlrow olleh"
    end
  
    it "should be able to decrypt text using the reverse worker" do
      _decrypt("dlrow olleh", :reverse).should == "hello world"
    end
    
  end
  
end