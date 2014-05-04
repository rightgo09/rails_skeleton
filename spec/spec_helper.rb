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

require "./app"

def spec_tmp_dir
  "#{Sinatra::Application.settings.root}/spec/tmp/4.1.0/Rails4.1.0"
end

RSpec.configure do |config|
  config.after(:each) do
    if Dir.exist?(spec_tmp_dir)
      FileUtils.rm_r(spec_tmp_dir)
    end
  end
end
