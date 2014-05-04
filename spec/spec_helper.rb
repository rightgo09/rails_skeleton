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
