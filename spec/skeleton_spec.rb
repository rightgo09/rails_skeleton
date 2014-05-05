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
  describe "build!" do
    let(:skeleton){ Skeleton410.new(params) }
    let(:gemfile){ File.read("#{spec_tmp_dir}/Gemfile") }
    before do
      skeleton.instance_variable_set(:@dst, spec_tmp_dir)
      skeleton.build!
    end
    it "should exist app name" do
      application_rb = File.read("#{spec_tmp_dir}/config/application.rb")
      expect(application_rb).to match(/module Piyopiyo/)
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
end
