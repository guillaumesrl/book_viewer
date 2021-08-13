require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "homepage"
  @toc = File.readlines('data/toc.txt')
  erb :home
end

get "/chapters/:num" do
  @chapter = File.read("data/chp#{params[:num]}.txt")
  @toc = File.readlines('data/toc.txt')
  @title = "chapter #{params[:num]}"

  erb :chapter
end

