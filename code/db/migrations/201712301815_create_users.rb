migration "create the Users  " do


	#database.drop_table(:users)
	
	
database.create_table :users do
    primary_key :id
  end 


end