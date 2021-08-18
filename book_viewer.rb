require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @toc = File.readlines('data/toc.txt')
end

helpers do 
  def in_paragraphs(text)
    text.split("\n\n").map.with_index { |paragraph, idx| "<p id=#{idx}> #{paragraph} </p>"}.join
  end
end

helpers do
  def highlight(text)
    text.gsub(params[:query], "<strong> #{params[:query]} </strong>")
  end
end

def search_chapters(query)
  return nil if query.nil?
  (1..@toc.size).select { |chap_num| File.read("data/chp#{chap_num}.txt").downcase.match?(query.downcase) }
end

def search_content(query)
  return nil if query.nil?
  result = Hash.new { |hash, key| hash[key] = [] }
  (1..@toc.size).each do |chap_num|
    chap_content = File.read("data/chp#{chap_num}.txt").split("\n\n")
    chap_content.each_with_index { |content, id| result[chap_num] << [id, content] if content.downcase.match?(query.downcase)}
  end
  result
end

# result = {1 => [id, id ,id]}

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
  @result = search_content(params[:query])
  erb :search
end
