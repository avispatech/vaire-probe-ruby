require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'dotenv/load'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..')

Dir.glob(File.join(File.dirname(__FILE__), 'app/**/*.rb')).each do |fname|
  load fname
end

def load_tests!
  Dir.glob(File.join(File.dirname(__FILE__), 'tests/**/*.rb')).each do |fname|
    load fname
  end
  nil
end
