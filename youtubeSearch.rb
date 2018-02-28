class SearchYoutube 

DEVELOPER_KEY = 'AIzaSyAk0bdRE1Uw3O07roXwWBZyStsM-TXmkVA'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

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

  if(random_or_not == true)
    max_res = 15

  else
    max_res = 1
  end
  
  client, youtube = get_service

  search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :q => search,
        :type => 'video',
        :maxResults => max_res
      }
    )

    videos = []

       search_response.data.items.each do |search_result|
      
        
          videos << "https://www.youtube.com/embed/" + "#{search_result.id.videoId}"
        
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

end