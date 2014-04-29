require "sinatra"
require "fileutils"
require "zip"

get "/" do
  erb :index
end

helpers do
  def timestamp
    Time.now.strftime("%Y%m%d%H%M%S")
  end
end

post "/skeleton" do
  d = "#{settings.root}/tmp/4.1.0/Rails4.1.0_#{timestamp}"
  s = "#{settings.root}/skeletons/4.1.0/commons"
  e = "#{settings.root}/skeletons/4.1.0/erb"

  FileUtils.rm_r(d) if Dir.exist?(d)
  FileUtils.cp_r(s, d)

  @database = params[:database]
  @app_name = params[:app_name]

  r = ->(f) { File.write("#{d}/#{f}", ERB.new(File.read("#{e}/#{f}")).result(binding)) }
  r.call("Gemfile")
  r.call("config/application.rb")

  d_zip = "#{d}.zip"
  FileUtils.rm(d_zip) if File.exist?(d_zip)
  Zip::File.open(d_zip, Zip::File::CREATE) do |z|
    Dir[File.join(d, '**', '**')].each do |f|
      z.add(f.sub("#{d}/", ''), f)
    end
  end

  send_file(d_zip, filename: File.basename(d_zip))
end
