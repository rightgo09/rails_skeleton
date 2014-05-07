require "spec_helper"

describe Skeleton do
  describe ".skeleton" do
    let(:params){ {} }
    context "with 4.1.0" do
      let(:version){ "4.1.0" }
      it "should retuen Skeleton410 instance" do
        s = Skeleton.skeleton(version, params)
        expect(s).to be_kind_of(Skeleton410)
      end
    end
    context "with 1.0.0" do
      let(:version){ "1.1.0" }
      it "should raise error" do
        expect{ Skeleton.skeleton(version, params) }.to raise_error
      end
    end
  end
end

describe Skeleton410 do
  let(:rails_version){ nil }
  let(:app_name){ "Piyopiyo" }
  let(:database){ nil }
  let(:testing_framework){ nil }
  let(:rails_config){ nil }
  let(:stylesheet){ nil }
  let(:turbolinks){ nil }
  let(:bootstrap){ nil }
  let(:template_engine){ nil }
  let(:kaminari){ nil }
  let(:draper){ nil }
  let(:params){ {
    rails_version: rails_version,
    app_name: app_name,
    database: database,
    testing_framework: testing_framework,
    turbolinks: turbolinks,
    bootstrap: bootstrap,
    template_engine: template_engine,
    rails_config: rails_config,
    stylesheet: stylesheet,
    kaminari: kaminari,
    draper: draper,
  } }
  let(:skeleton){ Skeleton410.new(params) }
  before do
    skeleton.instance_variable_set(:@dst, spec_tmp_dir)
  end
  describe "#build!" do
    let(:gemfile){ File.read("#{spec_tmp_dir}/Gemfile") }
    before do
      skeleton.build!
    end
    it "should exist app name" do
      application_rb = File.read("#{spec_tmp_dir}/config/application.rb")
      expect(application_rb).to match(/module Piyopiyo/)
    end
    context "with 4.1.0" do
      let(:rails_version){ "4.1.0" }
      it do
        expect(gemfile).to match(/gem 'rails', '4.1.0'/)
      end
    end
    context "with 4.1.1" do
      let(:rails_version){ "4.1.1" }
      it do
        expect(gemfile).to match(/gem 'rails', '4.1.1'/)
      end
    end
    context "with mysql" do
      let(:database){ "mysql" }
      it do
        expect(gemfile).to match(/gem 'mysql2'/)
      end
    end
    context "with pg" do
      let(:database){ "postgresql" }
      it do
        expect(gemfile).to match(/gem 'pg'/)
      end
    end
    context "with sqlite" do
      let(:database){ "sqlite" }
      it do
        expect(gemfile).to match(/gem 'sqlite3'/)
      end
    end
    context "with turbolinks" do
      let(:turbolinks){ "use" }
      it do
        expect(gemfile).to match(/^gem 'turbolinks'/)
      end
      context "with erb" do
        let(:template_engine){ "erb" }
        it do
          expect(File.read("#{spec_tmp_dir}/app/views/layouts/application.html.erb")).to match(/data-turbolinks-track/)
        end
      end
      context "with haml" do
        let(:template_engine){ "haml" }
        it do
          expect(File.read("#{spec_tmp_dir}/app/views/layouts/application.html.haml")).to match(/data-turbolinks-track/)
        end
      end
      context "with slim" do
        let(:template_engine){ "slim" }
        it do
          expect(File.read("#{spec_tmp_dir}/app/views/layouts/application.html.slim")).to match(/data-turbolinks-track/)
        end
      end
    end
    context "without turbolinks" do
      let(:turbolinks){ "not_use" }
      it do
        expect(gemfile).to match(/^#gem 'turbolinks'/)
      end
      context "with erb" do
        let(:template_engine){ "erb" }
        it do
          expect(File.read("#{spec_tmp_dir}/app/views/layouts/application.html.erb")).not_to match(/data-turbolinks-track/)
        end
      end
      context "with haml" do
        let(:template_engine){ "haml" }
        it do
          expect(File.read("#{spec_tmp_dir}/app/views/layouts/application.html.haml")).not_to match(/data-turbolinks-track/)
        end
      end
      context "with slim" do
        let(:template_engine){ "slim" }
        it do
          expect(File.read("#{spec_tmp_dir}/app/views/layouts/application.html.slim")).not_to match(/data-turbolinks-track/)
        end
      end
    end
    context "with bootstrap" do
      let(:bootstrap){ "use" }
      it do
        expect(gemfile).to match(/gem 'bootstrap-sass'/)
      end
    end
    context "without bootstrap" do
      let(:bootstrap){ "not_use" }
      it do
        expect(gemfile).not_to match(/gem 'bootstrap-sass'/)
      end
    end
    context "with erb" do
      let(:template_engine){ "erb" }
      it do
        expect(File.exist?("#{spec_tmp_dir}/app/views/layouts/application.html.erb")).to be_true
      end
    end
    context "with haml" do
      let(:template_engine){ "haml" }
      it do
        expect(gemfile).to match(/gem 'haml-rails'/)
        expect(File.exist?("#{spec_tmp_dir}/app/views/layouts/application.html.haml")).to be_true
      end
    end
    context "with slim" do
      let(:template_engine){ "slim" }
      it do
        expect(gemfile).to match(/gem 'slim-rails'/)
        expect(File.exist?("#{spec_tmp_dir}/app/views/layouts/application.html.slim")).to be_true
      end
    end
    context "with rspec" do
      let(:testing_framework){ "rspec" }
      it do
        expect(File.exist?("#{spec_tmp_dir}/.rspec")).to be_true
        expect(Dir.exist?("#{spec_tmp_dir}/spec")).to be_true
      end
    end
    context "with test_unit" do
      let(:testing_framework){ "test_unit" }
      it do
        expect(Dir.exist?("#{spec_tmp_dir}/test")).to be_true
      end
    end
    context "with kaminari" do
      let(:kaminari){ "use" }
      it do
        expect(gemfile).to match(/gem 'kaminari'/)
      end
    end
    context "without kaminari" do
      let(:kaminari){ "not_use" }
      it do
        expect(gemfile).not_to match(/gem 'kaminari'/)
      end
    end
    context "with scss" do
      let(:stylesheet){ "scss" }
      it do
        expect(File.exist?("#{spec_tmp_dir}/app/assets/stylesheets/application.css.scss")).to be_true
      end
    end
    context "with sass" do
      let(:stylesheet){ "sass" }
      it do
        expect(File.exist?("#{spec_tmp_dir}/app/assets/stylesheets/application.css.sass")).to be_true
      end
    end
    context "with rails_config" do
      let(:rails_config){ "use" }
      it do
        expect(File.exist?("#{spec_tmp_dir}/config/initializers/rails_config.rb")).to be_true
        expect(File.exist?("#{spec_tmp_dir}/config/settings/development.yml")).to be_true
        expect(File.exist?("#{spec_tmp_dir}/config/settings/production.yml")).to be_true
        expect(File.exist?("#{spec_tmp_dir}/config/settings/test.yml")).to be_true
        expect(File.exist?("#{spec_tmp_dir}/config/settings.local.yml")).to be_true
        expect(File.exist?("#{spec_tmp_dir}/config/settings.yml")).to be_true
      end
    end
    context "without rails_config" do
      let(:rails_config){ "not_use" }
      it do
        expect(File.exist?("#{spec_tmp_dir}/config/initializers/rails_config.rb")).to be_false
        expect(File.exist?("#{spec_tmp_dir}/config/settings/development.yml")).to be_false
        expect(File.exist?("#{spec_tmp_dir}/config/settings/production.yml")).to be_false
        expect(File.exist?("#{spec_tmp_dir}/config/settings/test.yml")).to be_false
        expect(File.exist?("#{spec_tmp_dir}/config/settings.local.yml")).to be_false
        expect(File.exist?("#{spec_tmp_dir}/config/settings.yml")).to be_false
      end
    end
    context "with draper" do
      let(:draper){ "use" }
      it do
        expect(gemfile).to match(/gem 'draper'/)
        expect(File.exist?("#{spec_tmp_dir}/app/decorators/application_decorator.rb")).to be_true
      end
    end
    context "without draper" do
      let(:draper){ "not_use" }
      it do
        expect(gemfile).not_to match(/gem 'draper'/)
        expect(File.exist?("#{spec_tmp_dir}/app/decorators/application_decorator.rb")).to be_false
      end
    end
  end
  describe "#zip!" do
    before do
      skeleton.build!
      skeleton.zip!
    end
    it do
      expect(File.exist?(skeleton.zip_path)).to be_true
      files = [
        "app/",
        "app/assets/",
        "app/assets/images/",
        "app/assets/javascripts/",
        "app/assets/javascripts/application.js",
        "app/assets/stylesheets/",
        "app/controllers/",
        "app/controllers/application_controller.rb",
        "app/controllers/concerns/",
        "app/helpers/",
        "app/helpers/application_helper.rb",
        "app/mailers/",
        "app/models/",
        "app/models/concerns/",
        "app/views/",
        "app/views/layouts/",
        "bin/",
        "bin/bundle",
        "bin/rails",
        "bin/rake",
        "config/",
        "config/application.rb",
        "config/boot.rb",
        "config/database.yml",
        "config/environment.rb",
        "config/environments/",
        "config/environments/development.rb",
        "config/environments/production.rb",
        "config/environments/test.rb",
        "config/initializers/",
        "config/initializers/backtrace_silencers.rb",
        "config/initializers/cookies_serializer.rb",
        "config/initializers/filter_parameter_logging.rb",
        "config/initializers/inflections.rb",
        "config/initializers/mime_types.rb",
        "config/initializers/session_store.rb",
        "config/initializers/wrap_parameters.rb",
        "config/locales/",
        "config/locales/en.yml",
        "config/routes.rb",
        "config/secrets.yml",
        "config.ru",
        "db/",
        "db/seeds.rb",
        "Gemfile",
        "lib/",
        "lib/assets/",
        "lib/tasks/",
        "log/",
        "public/",
        "public/404.html",
        "public/422.html",
        "public/500.html",
        "public/favicon.ico",
        "public/robots.txt",
        "Rakefile",
        "README.rdoc",
        "tmp/",
        "tmp/cache/",
        "tmp/cache/assets/",
        "vendor/",
        "vendor/assets/",
        "vendor/assets/javascripts/",
        "vendor/assets/stylesheets/",
      ]
      Zip::File.open(skeleton.zip_path) do |zip_file|
        zip_file.each do |entry|
          files.delete_if { |f| f == entry.name }
        end
      end
      p files unless files.empty?
      expect(files).to be_empty
    end
  end
end

describe "GET /" do
  it do
    get "/"
    expect(res).to match(/<title>Rails Skeleton<\/title>/)
  end
end

describe "POST /skeleton" do
  before do
    Skeleton410.any_instance.stub(:dst).and_return(spec_tmp_dir)
  end
  it do
    post "/skeleton", rails_version: "4.1.1"
    expect(res_header("Content-Type")).to eq "application/zip"
    expect(res_header("Content-Length")).to eq File.size("#{spec_tmp_dir}.zip").to_s
  end
end
