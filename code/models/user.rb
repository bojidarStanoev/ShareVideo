require'sequel'
require'mysql'
DB = Sequel.connect(adapter: :'mysql', database: 'shareVideo', host: 'localhost', user: 'root', password: 'root')
class BotUsers < Sequel::Model
	 def to_bot
    {
      id: id
      
    }
  end
end