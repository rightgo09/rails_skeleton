require "sinatra"
require "fileutils"
require "zip"
require "securerandom"

get "/" do
  erb :index
end

helpers do
  def timestamp
    Time.now.strftime("%Y%m%d%H%M%S")
  end

  def random_str
    SecureRandom.hex(4)
  end

  def cp(src, dest)
    FileUtils.cp(src, dest, verbose: true)
  end

  def cp_r(src, dest)
    FileUtils.cp_r(src, dest, verbose: true)
  end

  def rm(list)
    FileUtils.rm(list, verbose: true)
  end

  def rm_r(list)
    FileUtils.rm_r(list, verbose: true)
  end

  def zip_r(zip, src)
    rm(zip) if File.exist?(zip)
    Zip::File.open(zip, Zip::File::CREATE) do |z|
      Dir[File.join(src, '**', '**')].each do |f|
        z.add(f.sub("#{src}/", ''), f)
      end
    end
  end
end

post "/skeleton" do
  @app_name = params[:app_name]
  @database = params[:database]
  @testing_framework = params[:testing_framework]
  @template_engine = params[:template_engine]
  @stylesheet = params[:stylesheet]
  @turbolinks = params[:turbolinks]
  @bootstrap = params[:bootstrap]

  d = "#{settings.root}/tmp/4.1.0/Rails4.1.0_#{timestamp}_#{random_str}"
  s = "#{settings.root}/skeletons/4.1.0/common"
  e = "#{settings.root}/skeletons/4.1.0/erb"
  t = "#{settings.root}/skeletons/4.1.0/testing_framework"

  rm_r(d) if Dir.exist?(d)
  cp_r(s, d)
  if @testing_framework == "test_unit"
    cp_r("#{t}/test", d)
  elsif @testing_framework == "rspec"
    cp("#{t}/spec/.rspec", d)
    cp_r("#{t}/spec/spec", d)
  end

  r = ->(org, new = org) { File.write("#{d}/#{new}", ERB.new(File.read("#{e}/#{org}")).result(binding)) }
  r.call("Gemfile")
  r.call("config/application.rb")
  r.call("app/assets/javascripts/application.js")
  if @stylesheet == "scss"
    r.call("app/assets/stylesheets/application.css", "app/assets/stylesheets/application.css.scss")
  elsif @stylesheet == "sass"
    r.call("app/assets/stylesheets/application.css", "app/assets/stylesheets/application.css.sass")
  end
  if @template_engine == "erb"
    r.call("app/views/layouts/application.html.erb", "app/views/layouts/application.html.erb")
  elsif @template_engine == "haml"
    r.call("app/views/layouts/application.html.haml", "app/views/layouts/application.html.haml")
  elsif @template_engine == "slim"
    r.call("app/views/layouts/application.html.slim", "app/views/layouts/application.html.slim")
  end

  d_zip = "#{d}.zip"
  zip_r(d_zip, d)

  send_file(d_zip, filename: File.basename(d_zip))
end
