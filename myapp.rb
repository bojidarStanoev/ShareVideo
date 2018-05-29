require 'sinatra'
require 'rubygems'
require './config/init.rb'
require_relative 'youtubeSearch'





get '/webhook' do 
 puts params
   if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
   		params['hub.challenge']
   end
end

get "/extension" do
  puts params
  @arrindex = 0
  @videos,@thumbnails = SearchYoutube.new.find_video(params['SearchVideo'],false,true) 
  puts @videos
  erb :webExtension
end