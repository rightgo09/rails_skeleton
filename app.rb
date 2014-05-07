require "sinatra"
require "./models/skeleton"

get "/" do
  erb :index
end

post "/skeleton" do
  skeleton = Skeleton.skeleton(params[:rails_version], params)
  skeleton.build!
  skeleton.zip!

  send_file(skeleton.zip_path, filename: "#{skeleton.app_name}.zip")
end
