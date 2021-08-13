require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "homepage"
  @toc = File.readlines('data/toc.txt')
  erb :home
end

get "/chapters/1" do
  @content = File.read('data/chp1.txt')
  @toc = File.readlines('data/toc.txt')
  @title = "chapter 1"

  erb :chapter
end

