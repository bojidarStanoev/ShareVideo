require'sequel'

class User < Sequel::Model
	many_to_many :messages
end