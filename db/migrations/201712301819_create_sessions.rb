migration "create the sessions     " do


	

	database.create_table :sessions do
    primary_key :id
    string      :date
    int			:user_id
  end

end