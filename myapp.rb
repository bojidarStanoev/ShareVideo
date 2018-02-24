require 'sinatra'
require 'rubygems'
require './config/init.rb'

# NOTE: ENV variables should be set directly in terminal for testing on localhost

# Talk to Facebook
get '/webhook' do 
 puts params
  params['hub.challenge'] if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
end

get "/extension" do
  "Hello User!"
  erb :webExtension
end