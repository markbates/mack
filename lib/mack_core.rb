require File.join(File.dirname(__FILE__), 'gems')
require 'rubygems'
require 'rack'
require 'digest'
require 'mack-facets'
require 'mack-encryption'
require 'configatron'
require 'fileutils'
require 'singleton'
require 'uri'
require 'drb'
require 'rinda/ring'
require 'rinda/tuplespace'
require 'builder'
require 'erubis'
require 'erb'
require 'genosaurus'
require 'net/http'
require 'pp'
require 'test/unit' 
require 'thread'
begin
  # just in case people don't have it installed.
  require 'ruby-debug'
rescue Exception => e
end

run_once do
  [:version, :extensions, :paths, :portlets, :environment, :configuration, :logging, :assets, :core, :gems].each do |f|
    require File.join_from_here('mack', 'boot', "#{f}.rb")
  end
end