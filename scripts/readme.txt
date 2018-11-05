IMPORTANT: 

Connection data information is inside db_params.php. Please fill the information in order to make it work.

Process:

- In the command prompt, run 
	bin/rails db:create
	bin/rails db:migrate
	bin/rails db:seed

- Run the scripts in the following order
	prepare_data.php * 
	create_users.php
	info.php


* In prepare_data.php there are some variables that should be filled in order to put the correct information.