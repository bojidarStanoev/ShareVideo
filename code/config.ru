require './myapp'
require_relative 'bot' 


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
