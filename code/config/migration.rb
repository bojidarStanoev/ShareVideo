

migration "create the Users,Messages and Sessions table" do
	#database.drop_table(:users)
	#database.drop_table(:messages)
  database.create_table :users do
    primary_key :id
  end
  database.create_table :messages do
    primary_key :id
    string      :text
  end
   database.create_table :sessions do
    primary_key :id
    int      :user_id
    string     :date
    array   :message_id
  end
end