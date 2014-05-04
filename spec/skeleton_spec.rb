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
  let(:params){ {
    app_name: "Piyopiyo",
  } }
  describe "build!" do
    let(:skeleton){ Skeleton410.new(params) }
    before do
      skeleton.instance_variable_set(:@dst, spec_tmp_dir)
      skeleton.build!
    end
    it "should exist app name" do
      application_rb = File.read("#{spec_tmp_dir}/config/application.rb")
      expect(application_rb).to match(/module Piyopiyo/)
    end
  end
end
