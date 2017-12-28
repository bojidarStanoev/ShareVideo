

migration "create the Users,Messages,sessions and sessions_messages    " do
	#database.drop_table(:messages)
	#database.drop_table(:users)
	#database.drop_table(:sessions)
	#database.drop_table(:messages_sessions)
  database.create_table :users do
    primary_key :id
  end
  database.create_table :messages do
    primary_key :id
    string      :text
  end
  database.create_table :sessions do
    primary_key :id
    string      :date
    int			:user_id
  end
   database.create_table :messages_sessions do
    primary_key :id
    foreign_key :session_id, :sessions 
    foreign_key  :message_id, :messages
  end
end