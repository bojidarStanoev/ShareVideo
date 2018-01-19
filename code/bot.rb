require 'facebook/messenger'
require 'httparty' 
require 'json'
require 'time'
include Facebook::Messenger
require 'google/api_client'
require 'trollop'
require 'sequel'
require_relative 'bot_commands_help'

# NOTE: ENV variables should be set directly in terminal for testing on localhost

# Subcribe bot to your page
Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])
# Set DEVELOPER_KEY to the API
DEVELOPER_KEY = 'AIzaSyAk0bdRE1Uw3O07roXwWBZyStsM-TXmkVA'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'
FB_TOKEN = 'EAAELGMFbNQIBALuMYcHX9ZB4gxhLAX2qMmd4Xdq0MCTiny02ghiH3ZBYtPPqOc3ZAjNXb8Rs7zvUHJ4itHEBa6mDXd8fR5JT1oFtvwyXak0hHVRqwRfXuUEYyH5YD19XmN8PdX8E6UxVdPZC9YQhITiitaZAb80RM2ENrUoRquwZDZD'

hello_init = ["hi","hello","zdr"]
search_random = ["searchrnd","srcrnd","searchrandom"]
help = ["help?","?","help"]
session_mes = []
User.unrestrict_primary_key
session = Session.create(date: Time.new)
session.add_message(Message.create("text": "starting sessions", date: Time.new).id)
session.save



  

  

Bot.on :message do |message|

  puts "Received '#{message.inspect}' from #{message.sender}"
  puts session_mes
    last_mes = session.messages_dataset.order(:date).last

   if(Time.new - Time.parse(last_mes.date) > 120)
    session.save
    session = Session.create(date: message.sent_at)
    session.set(user_id: message.sender["id"])
  end
 
   User.find_or_create(id: message.sender["id"],  first_name: get_user_data(message.sender["id"])["first_name"], last_name: get_user_data(message.sender["id"])["last_name"],  locale: get_user_data(message.sender["id"])["locale"])
  session.set(user_id: message.sender["id"])
  normal_msg = normalize(message)

  puts normal_msg
  
   mes = Message.create("text": normal_msg, date: message.sent_at)
 
   session.add_message(mes.id)
   
  if hello_init.include?(normal_msg)
    
    message.reply(text: "Hello " + "#{get_user_data(message.sender["id"])["first_name"]}")
  
  elsif normal_msg.split(' ').first == "search"
    search = normal_msg.split(' ')[1..-1].join(' ')
      get_search_res = find_video(search,false).first
      puts get_search_res
       message.reply( attachment: {
                      "type": "template",
                        "payload": {
                          "template_type": "open_graph",
                                 "elements": [
                                     {
                                         "url": binding.local_variable_get("get_search_res")
                                     }
                                 ]
                        }
                    }) 

     
    elsif search_random.include?(normal_msg.split(' ').first)
      search = normal_msg.split(' ')[1..-1].join(' ')
      get_search_res = find_video(search,true)
      puts get_search_res = get_search_res[Random.rand(0...14)]
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
    message.reply(text: BotCommandString.new.give_commands_string)

  elsif normal_msg.split(' ').first == "mostpopular"
       
       if normal_msg.split(' ')[1] == nil  || normal_msg.split(' ')[1].to_i < 1 

         message.reply(text: "wrong input for mostpopular")

        else
         
            if normal_msg.split(' ')[2] == "to" && normal_msg.split(' ')[3].to_i != nil && normal_msg.split(' ')[3].to_i > 1 && normal_msg.split(' ')[3].to_i < 20
              starting_video = normal_msg.split(' ')[1].to_i - 1
              ending_video = normal_msg.split(' ')[3].to_i - 1
              most_popular_arr = get_most_popular(get_user_data(message.sender["id"])["locale"])

                (starting_video.to_i..ending_video.to_i).each do |i|
                  return_video = most_popular_arr[i]
                  message.reply(
                    attachment: {
                      "type": "template",
                        "payload": {
                          "template_type": "open_graph",
                                 "elements": [
                                     {
                                         "url": binding.local_variable_get("return_video")
                                     }
                                 ]
                        }
                    } 
                ) 
                end            
            
              else
           
             song_number = normal_msg.split(' ')[1].to_i
              most_popular = get_most_popular(get_user_data(message.sender["id"])["locale"])[song_number-1]
              message.reply(
                  attachment: {
                    "type": "template",
                      "payload": {
                        "template_type": "open_graph",
                               "elements": [
                                   {
                                       "url": binding.local_variable_get("most_popular")
                                   }
                               ]
                      }
                  } 
              ) 
            end
        end  
        
  else 
    
    message.reply(text: "i cant understand")
 
  end
  
  
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

def get_most_popular(region)

client,youtube = get_service
region = region.split("_")[1]
search_response = client.execute!(
      :api_method => youtube.videos.list,
      :parameters => {
        :part => 'snippet',
        :chart => 'mostPopular',
        :regionCode => region,
        :maxResults => '20'
      }
    )

mostpopular = []

  search_response.data.items.each do |popular_res|
      
          mostpopular << "https://www.youtube.com/watch?v=" + "#{popular_res.id}"        
  end

    return mostpopular
end

def get_user_data(id)

  return user_data = Facebook::Messenger::Profile.get("https://graph.facebook.com/v2.6/#{id}?fields=locale,first_name,last_name&access_token=#{FB_TOKEN}") 
end

def set_consistent_menu
  Facebook::Messenger::Profile.set({
  persistent_menu: [
    {
      locale: 'default',
      composer_input_disabled: false,
      call_to_actions: [
        {
      type: 'postback',
      title: 'Bot commands',
      payload: 'Help'
    }
    
    ]
  }
]
}, access_token: ENV['ACCESS_TOKEN'])

  Bot.on :postback do |postback|

    if postback.payload == 'Help'
      Bot.deliver({
    recipient: {
      id: postback.sender["id"]
    },
    message: {
      text: BotCommandString.new.give_commands_string
    }
  }, access_token: ENV['ACCESS_TOKEN'])
    end
  end
  
end

set_consistent_menu





