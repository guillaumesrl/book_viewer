require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @toc = File.readlines('data/toc.txt')
end

helpers do 
  def in_paragraphs(text)
    text.split("\n\n").map { |paragraph| "<p> #{paragraph} </p>"}.join
  end
end

get "/" do
  @title = "homepage"
  erb :home
end

get "/chapters/:num" do
  @chapter = File.read("data/chp#{params[:num]}.txt")
  @title = "chapter #{params[:num]} : #{File.readlines("data/toc.txt")[params[:num].to_i-1]}"

  erb :chapter
end

