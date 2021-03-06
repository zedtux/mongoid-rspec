$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
MODELS = File.join(File.dirname(__FILE__), 'models')
$LOAD_PATH.unshift(MODELS)
VALIDATORS = File.join(File.dirname(__FILE__), 'validators')
$LOAD_PATH.unshift(VALIDATORS)

require 'rubygems'
require 'bundler'
Bundler.setup

require 'mongoid'
require 'rspec/core'
require 'rspec/expectations'
require 'mongoid/compatibility'

Mongoid::Config.connect_to('mongoid-rspec-test') if Mongoid::Compatibility::Version.mongoid3_or_newer?
Mongo::Logger.logger.level = ::Logger::INFO if Mongoid::Compatibility::Version.mongoid5_or_newer?

Dir[File.join(MODELS, '*.rb')].sort.each { |file| require File.basename(file) }

require 'mongoid-rspec'

RSpec.configure do |config|
  config.include RSpec::Matchers
  config.include Mongoid::Matchers
  config.mock_with :rspec
  config.after :all do
    Mongoid::Config.purge!
  end
  config.after :suite do
    print "\n# Mongoid v#{Mongoid::VERSION}"
  end
  config.disable_monkey_patching!
end
