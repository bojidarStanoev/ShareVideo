migration "create the Messages    " do


	database.create_table :messages do
    primary_key :id
    string      :text
    string      :date
  end
	
end
	
