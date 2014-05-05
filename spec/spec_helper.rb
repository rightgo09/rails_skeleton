# refs. https://coveralls.io/docs/ruby
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/vendor/bundle'
end

ENV['RACK_ENV'] = 'test'

require "./app"

require 'rspec'
require 'rack/test'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def spec_tmp_dir
  "#{Sinatra::Application.settings.root}/spec/tmp/4.1.0/Rails4.1.0"
end

def res
  last_response.body
end

def res_header(header)
  last_response.headers[header]
end

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.after(:each) do
    if Dir.exist?(spec_tmp_dir)
      FileUtils.rm_r(spec_tmp_dir)
    end
    zip_path = "#{spec_tmp_dir}.zip"
    if File.exist?(zip_path)
      FileUtils.rm(zip_path)
    end
  end
end
