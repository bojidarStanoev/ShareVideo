migration "create the Users  " do


	#database.drop_table(:users)
	
	
database.create_table :users do
    primary_key :id
    string  :first_name
    string  :last_name
    string  :locale
  end 


end