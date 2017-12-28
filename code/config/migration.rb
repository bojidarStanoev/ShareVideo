

migration "create the Users,Messages and join table messsages_users" do
	database.drop_table(:users)
	database.drop_table(:messages)
	database.drop_table(:messages_users)
	
  database.create_table :users do
    primary_key :id
  end
  database.create_table :messages do
    primary_key :id
    string      :text
  end
   database.create_table :messages_users do
    primary_key :id
    foreign_key :user_id, :users 
    string     :date
    foreign_key  :message_id, :messages
  end
end