require 'sinatra/sequel'
#require 'sqlite3'

 
configure :development do
  set :database, 'sqlite://db/sqlite/test.db'
end
configure :test do
  set :database, 'sqlite3::memory:'
end
 #require_relative 'migration'
 Dir["./db/migrations/**/*.rb"].each do |migration|
 	puts migration
  require migration
end

 Dir["./models/**/*.rb"].each do |model|
 	puts model
  require model
end
