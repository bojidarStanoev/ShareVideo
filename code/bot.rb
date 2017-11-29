require 'facebook/messenger'
require 'httparty' # you should require this one
require 'json' # and that one
require 'google_custom_search_api'
include Facebook::Messenger
# NOTE: ENV variables should be set directly in terminal for testing on localhost

# Subcribe bot to your page
Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

hello_init=["hi","hello","zdr"]


Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}" # debug purposes
  #parsed_response = get_parsed_response(API_URL, message.text) # talk to Google API
  normal_msg = normalize(message)
  puts normal_msg
  if(hello_init.include?(normal_msg))

    message.reply(text: "Hello")
  
  elsif normal_msg.split(' ').first == "search"
    search = normal_msg.split(' ')[1..-1].join(' ')
    results = GoogleCustomSearchApi.search(search) 
      results.items.each do |item|
        message.reply(text:  item.title)
         message.reply(text:  item.link) 
      end
    
  else
    
    message.reply(text: "i cant understand")
 
  end
  
end


def normalize(message)
  message = message.text.downcase
  
end
