require'sequel'


class Message < Sequel::Model
  	many_to_many :sessions
end