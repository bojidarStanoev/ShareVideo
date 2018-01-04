require 'facebook/messenger'
require 'httparty' # you should require this one
require 'json' # and that one
include Facebook::Messenger
require 'google/api_client'
require 'trollop'
require 'sequel'
#DB = Sequel.connect(adapter: :'mysql', database: 'shareVideo', host: 'localhost', user: 'root', password: 'root')
# NOTE: ENV variables should be set directly in terminal for testing on localhost

# Subcribe bot to your page
Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])
# Set DEVELOPER_KEY to the API
DEVELOPER_KEY = 'AIzaSyAk0bdRE1Uw3O07roXwWBZyStsM-TXmkVA'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

hello_init = ["hi","hello","zdr"]
search_random = ["searchrnd","srcrnd","searchrandom"]
help = ["help?","?","help"]
session_mes = []
User.unrestrict_primary_key
session=Session.create
last_send = Time.new
last_id=0

 
Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"
  puts session_mes
  #last session is saved and a new one is created when a message is received
  #and 60 seconds have passed since the last one
   if(Time.new > last_send+60)
    session.save
    session= Session.create(date: message.sent_at)
     end
  User.find_or_create(id: message.sender["id"])
  session.set(user_id: message.sender["id"])
  normal_msg = normalize(message)

  puts normal_msg
   mes = Message.create(text: normal_msg)

   session.add_message(mes.id)
   
  if hello_init.include?(normal_msg)

    message.reply(text: "Hello")
  
  elsif normal_msg.split(' ').first == "search"
    search = normal_msg.split(' ')[1..-1].join(' ')
      get_search_res=find_video(search,false).first
      puts get_search_res
       message.reply(
  attachment: {
    "type": "template",
    "payload": {
      "template_type": "open_graph",
                   "elements": [
                       {
                           "url": binding.local_variable_get("get_search_res")
                       }
                   ]
     }
    }
  )
     
    elsif search_random.include?(normal_msg.split(' ').first)
      search = normal_msg.split(' ')[1..-1].join(' ')
      get_search_res = find_video(search,true)
      puts get_search_res=get_search_res[Random.rand(0...14)]
      message.reply(
  attachment: {
    "type": "template",
    "payload": {
      "template_type": "open_graph",
                   "elements": [
                       {
                           "url": binding.local_variable_get("get_search_res")
                       }
                   ]
     }
    }
  )

  elsif help.include?(normal_msg)
    message.reply(text: "search keyword => does a Youtube search with the given keyword 
      searchrnd,searchrandom,srcrnd keyword => gives you a random video based on the keyword")

  else
    
    message.reply(text: "i cant understand")
 
  end
  
  last_id = message.sender["id"]
  last_send = Time.new
end


def normalize(message)
  message = message.text.downcase
end

def get_service
  client = Google::APIClient.new(
    :key => DEVELOPER_KEY,
    :authorization => nil,
    :application_name => $PROGRAM_NAME,
    :application_version => '1.0.0'
  )
  youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

  return client, youtube
end



def  find_video(search,random_or_not)

  if(random_or_not== true)
    max_res=15

  else
    max_res = 2
  end
  opts = Trollop::options do
    opt :q, 'Search term', :type => String, :default => search
    opt :max_results, 'Max results', :type => :int, :default => max_res
  end
  client, youtube = get_service

  search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :q => opts[:q],
        :maxResults => opts[:max_results]
      }
    )

    videos = []

       search_response.data.items.each do |search_result|
      case search_result.id.kind
        when 'youtube#video'
          videos << "https://www.youtube.com/watch?v=" + "#{search_result.id.videoId}"
        
      end
    end

   return videos 
end
