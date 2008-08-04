require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

module Mack
  module ControllerHelpers
    module RedSox
      def rock!
      end
    end
    module Yankees
      def suck!
      end
    end
  end
end

class BaseBallController
  include Mack::ControllerHelpers
end

describe Mack::ControllerHelpers do
  
  it "should include all controller helpers when included" do
    bb = BaseBallController.new
    bb.should be_respond_to(:rock!)
    bb.should be_respond_to(:suck!)
    bb.protected_methods.should include("rock!")
    bb.protected_methods.should include("suck!")
  end
  
end