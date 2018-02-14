require'sequel'


class Session< Sequel::Model
many_to_many :messages
   
end