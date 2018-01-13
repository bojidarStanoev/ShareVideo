migration "create the Messages    " do

#database.drop_table(:messages)
	database.create_table :messages do
    primary_key :id
    string      :text
    string      :date
  end
	
end
	
