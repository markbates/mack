require 'rubygems'
require 'rack'
require 'fileutils'

require File.join(ENV["MACK_ROOT"] ||= FileUtils.pwd, "..", "..", "lib", "mack")
