require 'sinatra'
require 'rubygems'
require './config/init.rb'
require_relative 'youtubeSearch'

# NOTE: ENV variabvles should be set directly in terminal for testing on localhost
@videos = " "

# Talk to Facebook
get '/webhook' do 
 puts params
  params['hub.challenge'] if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
end

get "/extension" do
  puts params
  @arrindex = 0
  @videos,@thumbnails = SearchYoutube.new.find_video(params['SearchVideo'],false,true) 
  puts @videos
  erb :webExtension
end