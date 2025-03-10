require 'simplecov'
SimpleCov.start

require 'rspec'
# require 'minitest/autorun'  

# Require your application file here
require_relative '../lib/wordguesser_game'

require File.join(File.dirname(__FILE__), '..', 'app.rb')

require 'sinatra'
require 'rack/test'
require 'webmock/rspec'
require 'debug'

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

use Rack::Session::Cookie

def app
  WordGuesserApp.new!
end

def session
  last_request.env['rack.session']
end

# The following lines disable web usage and causes the external API to be stubbed out,
# eliminating randomness to aid in testing
def stub_random_word(word)
  stub_request(:post, 'http://randomword.saasbook.info/RandomWord').to_return(body: word)
end

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.before do
    stub_request(:post, "http://randomword.saasbook.info/RandomWord").to_return(body: "foobar")
  end
  config.color = true
  config.filter_run_excluding pending: true # this avoids excessive pending examples output
  config.formatter = :documentation
  
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
