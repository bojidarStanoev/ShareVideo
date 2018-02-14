migration "create the  sessions_messages " do

	#database.drop_table(:messages_sessions)
	database.create_table :messages_sessions do
    primary_key :id
    foreign_key :session_id, :sessions 
    foreign_key  :message_id, :messages
  end

end