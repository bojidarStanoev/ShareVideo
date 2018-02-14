migration "create the sessions     " do


	#database.drop_table(:sessions)

	database.create_table :sessions do
    primary_key :id
    string      :date
    int			:user_id
  end

end