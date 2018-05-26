require 'dotenv/load'
require 'facebook/messenger' 
require 'json'
require 'time'
include Facebook::Messenger
require 'google/api_client'
require 'sequel'

require_relative 'bot_commands_help'
require_relative 'youtubeSearch'




Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])
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

   if Time.new - Time.parse(last_mes.date) > 120 
    session.save
    session = Session.create(date: message.sent_at)
    session.set(user_id: message.sender["id"])
    end
 
   User.find_or_create(id: message.sender["id"], first_name: get_user_data(message.sender["id"])["first_name"], last_name: get_user_data(message.sender["id"])["last_name"],  locale: get_user_data(message.sender["id"])["locale"])
  session.set(user_id: message.sender["id"])
  normal_msg = normalize(message)

  puts normal_msg
  
   mes = Message.create("text": normal_msg, date: message.sent_at)
 
   session.add_message(mes.id)
  if !is_text_message(message)

    message.reply(text: "only send text please")
  
  elsif hello_init.include?(normal_msg)
    
    message.reply(text: "Hello " + "#{get_user_data(message.sender["id"])["first_name"]}")
  
  elsif normal_msg.split(' ').first == "search"
    search = normal_msg.split(' ')[1..-1].join(' ')
      get_search_res,thumbnails = SearchYoutube.new.find_video(search,false,false).first
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
      get_search_res,thumbnails = SearchYoutube.new.find_video(search,true,false)
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
              most_popular_arr = SearchYoutube.new.get_most_popular(get_user_data(message.sender["id"])["locale"])

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
              most_popular = SearchYoutube.new.get_most_popular(get_user_data(message.sender["id"])["locale"])[song_number-1]
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
  if is_text_message(message)
    message = message.text.downcase
  end
end

def is_text_message(message)
  !message.text.nil?
end



def get_user_data(id)

  return user_data = Facebook::Messenger::Profile.get("https://graph.facebook.com/v2.6/#{id}?fields=locale,first_name,last_name&access_token=#{ ENV["ACCESS_TOKEN"]}") 
end

def set_getStarted_and_consistent_menu
  
  Facebook::Messenger::Profile.set({
     "whitelisted_domains":[
        ENV["NGROK_URL"]     
      ]
    }, access_token: ENV['ACCESS_TOKEN'])
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
],
get_started: {
    payload: 'GET_STARTED_PAYLOAD'
  },
  
   "home_url": {
     "url": ENV["NGROK_URL"],
     "webview_height_ratio": "tall",
     "webview_share_button": "show",
     "in_test":true
  }
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
  if postback.payload == "GET_STARTED_PAYLOAD"
    Bot.deliver({
    recipient: {
      id: postback.sender["id"]
    },
    message: {
      text: "hello there " + "#{get_user_data(postback.sender["id"])["first_name"]}" + 
       ". Im your personal Video sharing bot for more info type: help." 
    }
  }, access_token: ENV['ACCESS_TOKEN'])
    end
  end
  
end



set_getStarted_and_consistent_menu





