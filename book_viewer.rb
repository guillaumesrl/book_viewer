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



def search_query(query)
  return nil if query.nil?
  (1..@toc.size).select { |chap_num| File.read("data/chp#{chap_num}.txt").downcase.match?(query.downcase) }
end



get "/" do
  @title = "homepage"
  erb :home
end

get "/chapters/:num" do
  num = params[:num].to_i
  redirect "/" unless num.to_s == params[:num] && (1..@toc.size).include?(num)

  @chapter = File.read("data/chp#{params[:num]}.txt")
  @title = "chapter #{params[:num]} : #{File.readlines("data/toc.txt")[num-1]}"

  erb :chapter
end

not_found do
  redirect "/", 301
end

get "/search" do
  @result_arr = search_query(params[:query])
  erb :search
end
