require './myapp'
require_relative 'bot' 


# run  Sinatra and facebook-messenger on /webhook
map("/webhook") do
  run Sinatra::Application
  run Facebook::Messenger::Server
end


configure do |config|
	enable :logging, :dump_errors, :raise_errors
	
end
# run regular sinatra for chat extension 
run Sinatra::Application
