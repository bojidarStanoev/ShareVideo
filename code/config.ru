require './myapp'
require_relative 'bot' # you can comment this line out until you create a bot.rb file later in the tutorial

# you may need this lines in order to test your server before you create bot.rb later 
#require 'facebook/messenger'
#include Facebook::Messenger

# run both Sinatra and facebook-messenger on /webhook
map("/webhook") do
  run Sinatra::Application
  run Facebook::Messenger::Server
end


configure do |config|
	enable :logging, :dump_errors, :raise_errors
	
end
# run regular sinatra for other paths (in case you ever need it)
run Sinatra::Application
#Tasks
#hi,heelo,zdr-initialize
#include?arraay(message)
#message=normalize(mes)
#case message
	#initiazili 
	#help,komandite array
	#if(inial.include message)
		#vinagi
		#db da logvame
		#elasticssearch
		#vedis
		#mysql