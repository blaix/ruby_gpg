$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby_gpg'
require 'rspec'

RSpec.configure do |config|
  config.mock_framework = :mocha
end
