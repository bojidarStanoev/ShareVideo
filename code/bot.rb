require 'facebook/messenger'
require 'httparty' # you should require this one
require 'json' # and that one
include Facebook::Messenger
require 'google/api_client'
require 'trollop'
# NOTE: ENV variables should be set directly in terminal for testing on localhost

# Subcribe bot to your page
Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])
# Set DEVELOPER_KEY to the API
DEVELOPER_KEY = 'AIzaSyAk0bdRE1Uw3O07roXwWBZyStsM-TXmkVA'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

hello_init=["hi","hello","zdr"]


Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}" # debug purposes
  
  normal_msg = normalize(message)
  puts normal_msg
  if(hello_init.include?(normal_msg))

    message.reply(text: "Hello")
  
  elsif normal_msg.split(' ').first == "search"
    search = normal_msg.split(' ')[1..-1].join(' ')
      get_search_res=find_video(search).first
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



def  find_video(search)

  opts = Trollop::options do
    opt :q, 'Search term', :type => String, :default => search
    opt :max_results, 'Max results', :type => :int, :default => 2
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

    # Add each result to the appropriate list, and then display the lists of
    # matching videos, channels, and playlists.
    search_response.data.items.each do |search_result|
      case search_result.id.kind
        when 'youtube#video'
          videos << "https://www.youtube.com/watch?v=" + "#{search_result.id.videoId}"
        
      end
    end

   return videos 
end
