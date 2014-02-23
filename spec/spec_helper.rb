$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'rubygems'
require 'bundler/setup'
require 'vexile'

I18n.enforce_available_locales = true

RSpec.configure do |config|
end