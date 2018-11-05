<?php 
include('./db_params.php');

//fields
$user_id = Array();
$user_email = Array();
$encrypted_password = Array();
$reset_password_token = Array();
$reset_password_sent_at = Array();
$remember_created_at = Array();
$sign_in_count = Array();
$current_sign_in_at = Array();
$last_sign_in_at = Array();
$current_sign_in_ip = Array();
$last_sign_in_ip = Array();
$created_at = Array();
$updated_at = Array();
$name = Array();
$confirmation_token = Array();
$confirmed_at = Array();
$contirmation_sent_at = Array();
$unconfirmed_email = Array();
$avatar_uid = Array();
$role_id = Array();
$deleted_at = Array();

//Organization extra data
$nif = Array();
$organization_name = Array();


//Other data
$last_user_id = 0;

$conn = pg_connect("host=".$host." port=".$port." dbname=".$database." user=".$username." password=".$password);
if(!$conn) {
  echo "Error : Unable to open database to extract data. Aborting.\n";
} else {
  echo "<p>Opened database to extract data successfully.</p>";
}

$sql = get_users_information();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {
	//loop all users rows
   while($row = pg_fetch_row($ret)) {
		array_push($user_id, $row[0]);
		array_push($user_email, $row[1]);
		array_push($encrypted_password, $row[2]);
		array_push($reset_password_token, $row[3]);
		array_push($reset_password_sent_at, $row[4]);
		array_push($remember_created_at, $row[5]);
		array_push($sign_in_count, $row[6]);
		array_push($current_sign_in_at, $row[7]);
		array_push($last_sign_in_at, $row[8]);
		array_push($current_sign_in_ip, $row[9]);
		array_push($last_sign_in_ip, $row[10]);
		array_push($created_at, $row[11]);
		array_push($updated_at, $row[12]);
		array_push($name, $row[13]);
		array_push($confirmation_token, $row[14]);
		array_push($confirmed_at, $row[15]);
		array_push($contirmation_sent_at, $row[16]);
		array_push($unconfirmed_email, $row[17]);
		array_push($avatar_uid, $row[20]);
		array_push($role_id, $row[30]);
		array_push($deleted_at, $row[31]);
		array_push($nif, $row[21]);
		array_push($organization_name, $row[27]);

		if ($last_user_id < $row[0]) $last_user_id = $row[0];
   }
}
//close first connection
pg_close($conn);


//insert data connection
$conn = pg_connect("host=".$DBhost." port=".$DBport." dbname=".$DBdatabase." user=".$DBusername." password=".$DBpassword);
if(!$conn) {
	echo "Error : Unable to open database\n";
} else {
	echo "<p>Opened database successfully.</p>";
}
for ($i=0; $i < count($user_id); $i++) {
	$original_role = $role_id[$i];
	if ($role_id[$i] == 0) $role_id[$i] = '{admin}';
	if ($role_id[$i] == 1) $role_id[$i] = '{admin}';
	if ($role_id[$i] == 2) $role_id[$i] = '{}';
	if ($role_id[$i] == 3) $role_id[$i] = '{admin}';
	if ($role_id[$i] == 4) $role_id[$i] = '{admin}';
	if ($role_id[$i] == 5) $role_id[$i] = '{}';
	if (is_null($role_id[$i])) $role_id[$i] = '{}';

	$sql = set_users(
		$user_id[$i],
		$user_email[$i],
		$encrypted_password[$i],
		$reset_password_token[$i],
		$reset_password_sent_at[$i],
		$remember_created_at[$i],
		$sign_in_count[$i],
		$current_sign_in_at[$i],
		$last_sign_in_at[$i],
		$last_sign_in_ip[$i],
		$created_at[$i],
		$updated_at[$i],
		$name[$i],
		$confirmation_token[$i],
		$confirmed_at[$i],
		$contirmation_sent_at[$i],
		$unconfirmed_email[$i],
		$avatar_uid[$i],
		$role_id[$i],
		$deleted_at[$i],
		$decidim_organization_id = 1
		);
   $ret = pg_query($conn, $sql);
   if(!$ret) {
      echo pg_last_error($conn);
   } else {
      echo "<p>User with id $user_id[$i] created successfully</p>\n";

      //role id 2 is organization
      if ($original_role == 2) {
      	if ($nif[$i] == "") $nif[$i] = generateRandomString();

      	$sql2 = create_organization (
      		$nif[$i],
			$organization_name[$i],
			$avatar_uid[$i]
      	);
        $ret2 = pg_query($conn, $sql2);

	    if(!$ret2) {
	      echo pg_last_error($conn);
	    } else {
	    	$organization_id = 0;

			while($row = pg_fetch_row($ret2)) {
				$organization_id =  $row[0];
		   	}
		   
		   	$sql3 = create_organization_user_relation(
			   	$organization_id,
			   	$user_id[$i]
		   	);

	        $ret3 = pg_query($conn, $sql3);

		    if(!$ret3) {
		      echo pg_last_error($conn);
		    } else {
		    	echo "<p>RELACION CREADA CORRECTAMENTE</p>";
		    }
	    }
      }
   }

}
$sql = alter_user_id_sequence(
	$last_user_id);
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {
	echo "<p>Secuencia usuarios modificada correctamente.</p>";
}




//close second connection
pg_close($conn);


function get_users_information(){
	return $sql =<<<EOF
	  SELECT * FROM users;
EOF;
}

function set_users(
	$user_id,
	$user_email,
	$encrypted_password,
	$reset_password_token,
	$reset_password_sent_at,
	$remember_created_at,
	$sign_in_count,
	$current_sign_in_at,
	$last_sign_in_at,
	$last_sign_in_ip,
	$created_at,
	$updated_at,
	$name,
	$confirmation_token,
	$confirmed_at,
	$contirmation_sent_at,
	$unconfirmed_email,
	$avatar_uid,
	$role_id,
	$deleted_at,
	$decidim_organization_id = 1
	) {

	if ($current_sign_in_at != "") $current_sign_in_at = "to_timestamp('$current_sign_in_at', 'YYYY-MM-DD hh24:mi:ss')";
	else $current_sign_in_at = "now()::timestamp";
	if ($last_sign_in_at != "") $last_sign_in_at = "to_timestamp('$last_sign_in_at', 'YYYY-MM-DD hh24:mi:ss')";
	else $last_sign_in_at = "now()::timestamp";
	if ($confirmed_at != "") $confirmed_at = "to_timestamp('$confirmed_at', 'YYYY-MM-DD hh24:mi:ss')";
	else $confirmed_at = "now()::timestamp";
	if ($contirmation_sent_at != "") $contirmation_sent_at = "to_timestamp('$contirmation_sent_at', 'YYYY-MM-DD hh24:mi:ss')";
	else $contirmation_sent_at = "now()::timestamp";
	if ($remember_created_at != "") $remember_created_at = "to_timestamp('$remember_created_at', 'YYYY-MM-DD hh24:mi:ss')";
	else $remember_created_at = "now()::timestamp";
	if ($reset_password_sent_at != "") $reset_password_sent_at = "to_timestamp('$reset_password_sent_at', 'YYYY-MM-DD hh24:mi:ss')";
	else $reset_password_sent_at = "now()::timestamp";
	if ($deleted_at != "") $deleted_at = "to_timestamp('$deleted_at', 'YYYY-MM-DD hh24:mi:ss')";
	else $deleted_at = "null";

	if ($reset_password_token == "") $reset_password_token = generateRandomString(20);
	if ($confirmation_token == "") $confirmation_token = generateRandomString(20);
	
	$name = str_replace("'", "''", $name);
	
	return $sql =<<<EOF
	  INSERT INTO decidim_users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, last_sign_in_ip, current_sign_in_ip, created_at, updated_at, name, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, avatar, roles, deleted_at, decidim_organization_id, locale) 
	  VALUES
	  	($user_id,
		 '$user_email',
		 '$encrypted_password',
		 '$reset_password_token',
		 $reset_password_sent_at,
		 $remember_created_at,
		 $sign_in_count,
		 $current_sign_in_at,
		 $last_sign_in_at,
		 '$last_sign_in_ip',
		 '$current_sign_in_ip',
		 to_timestamp('$created_at', 'YYYY-MM-DD hh24:mi:ss'),
		 to_timestamp('$updated_at', 'YYYY-MM-DD hh24:mi:ss'),
		 '$name',
		 '$confirmation_token',
		 $confirmed_at,
		 $contirmation_sent_at,
		 '$unconfirmed_email',
		 '$avatar_uid',
		 '$role_id',
		 $deleted_at,
		 $decidim_organization_id,
		 'ca');
EOF;
}

function generateRandomString($length = 10) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

function create_organization(
	$nif,
	$organization_name,
	$avatar_uid,
	$organization_id = 1,
	$now = "now()::timestamp"
	)
{
	return $sql =<<<EOF
	  INSERT INTO decidim_user_groups (name, document_number, created_at, updated_at, avatar, decidim_organization_id, verified_at, phone) 
	  VALUES (
	  '$organization_name',
	  '$nif', 
	  $now, 
	  $now, 
	  '$avatar_uid',
	  $organization_id,
	  $now,
	  '000000000'
	  )
	  RETURNING id;
EOF;

}
function create_organization_user_relation(
	$organization_id,
	$user_id
	) {
	return $sql =<<<EOF
	INSERT INTO decidim_user_group_memberships (
	decidim_user_id, 
	decidim_user_group_id, 
	created_at,
	updated_at
	) 
	VALUES (
	$user_id,
	$organization_id,
	now()::timestamp,
	now()::timestamp
	);
EOF;

}

function alter_user_id_sequence (
	$id) {
	$id++;
	return $sql =<<<EOF
	ALTER SEQUENCE decidim_users_id_seq RESTART $id;
EOF;
}
?>