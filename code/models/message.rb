require'sequel'


class Message < Sequel::Model
  	many_to_many :users
end