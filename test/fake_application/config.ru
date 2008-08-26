ENV["MACK_ENV"] = 'development'
require 'rubygems'
load("Rakefile")
require 'mack'
run Mack::Utils::Server.build_app
