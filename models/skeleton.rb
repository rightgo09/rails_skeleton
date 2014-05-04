class Skeleton
  def self.skeleton(version, params)
    case version
    when "4.1.0"
      Skeleton410.new(params)
    else
      raise "No skeleton"
    end
  end
end

require "securerandom"
require "fileutils"
require "zip"

class Skeleton410
  attr_reader :app_name

  def initialize(params)
    @app_name = params[:app_name]
    @database = params[:database]
    @testing_framework = params[:testing_framework]
    @template_engine = params[:template_engine]
    @stylesheet = params[:stylesheet]
    @turbolinks = params[:turbolinks]
    @bootstrap = params[:bootstrap]
    @rails_config = params[:rails_config]
    @kaminari = params[:kaminari]
  end

  def build!
    common            = "#{src}/common"
    testing_framework = "#{src}/testing_framework"
    rails_config      = "#{src}/rails_config"

    rm_r(dst) if Dir.exist?(dst)

    # common
    cp_r(common, dst)

    # testing framework
    if @testing_framework == "test_unit"
      cp_r("#{testing_framework}/test", dst)
    elsif @testing_framework == "rspec"
      cp("#{testing_framework}/spec/.rspec", dst)
      cp_r("#{testing_framework}/spec/spec", dst)
    end

    # rails_config
    if @rails_config == "use"
      cp_r("#{rails_config}/config", dst)
    end

    [
      "Gemfile",
      ".gitignore",
      "config/application.rb",
      "app/assets/javascripts/application.js",
    ].each do |f|
      erb_result(f)
    end

    if @stylesheet == "scss"
      erb_result("app/assets/stylesheets/application.css", "app/assets/stylesheets/application.css.scss")
    elsif @stylesheet == "sass"
      erb_result("app/assets/stylesheets/application.css", "app/assets/stylesheets/application.css.sass")
    end
    if @template_engine == "erb"
      erb_result("app/views/layouts/application.html.erb", "app/views/layouts/application.html.erb")
    elsif @template_engine == "haml"
      erb_result("app/views/layouts/application.html.haml", "app/views/layouts/application.html.haml")
    elsif @template_engine == "slim"
      erb_result("app/views/layouts/application.html.slim", "app/views/layouts/application.html.slim")
    end
  end

  def zip!
    rm(zip_path) if File.exist?(zip_path)
    Zip::File.open(zip_path, Zip::File::CREATE) do |z|
      Dir[File.join(dst, '**', '**')].each do |f|
        z.add(f.sub("#{dst}/", ''), f)
      end
    end
  end

  def zip_path
    @zip_path ||= "#{dst}.zip"
  end

  private

  def timestamp
    Time.now.strftime("%Y%m%d%H%M%S")
  end

  def random_str
    SecureRandom.hex(4)
  end

  def root
    Sinatra::Application.settings.root
  end

  def dst
    @dst ||= "#{root}/tmp/4.1.0/Rails4.1.0_#{timestamp}_#{random_str}"
  end

  def src
    @src ||= "#{root}/skeletons/4.1.0"
  end

  def cp(from, to)
    FileUtils.cp(from, to, verbose: true)
  end

  def cp_r(from, to)
    FileUtils.cp_r(from, to, verbose: true)
  end

  def rm(list)
    FileUtils.rm(list, verbose: true)
  end

  def rm_r(list)
    FileUtils.rm_r(list, verbose: true)
  end

  def erb_result(org, new = org)
    erb = "#{src}/erb"
    File.write("#{dst}/#{new}", ERB.new(File.read("#{erb}/#{org}"), nil, '-').result(binding))
  end
end
