require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

module Mack
  module ViewHelpers
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

class BaseBall
  include Mack::ViewHelpers
end

describe Mack::ViewHelpers do
  
  it "should include all view helpers when included" do
    bb = BaseBall.new
    bb.should be_respond_to(:rock!)
    bb.should be_respond_to(:suck!)
  end
  
end