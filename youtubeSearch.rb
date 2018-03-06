class SearchYoutube 

DEVELOPER_KEY = 'AIzaSyAk0bdRE1Uw3O07roXwWBZyStsM-TXmkVA'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'
Youtube_Url = "https://www.youtube.com/embed/"
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



def  find_video(search,random_or_not,extension_search)

  if random_or_not == true
    max_res = 15

  elsif extension_search == true
    max_res = 5
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
    thumbnails = []

       search_response.data.items.each do |search_result|
          videos << Youtube_Url + "#{search_result.id.videoId}"
           thumbnails <<  "#{search_result.snippet.thumbnails.high.url}"
      end
    

   return videos,thumbnails 
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
      
          mostpopular << Youtube_Url + "#{popular_res.id}"        
  end

    return mostpopular
end

end