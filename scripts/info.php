<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include('./db_params.php');


//local variables - processes:
$decidim_participatory_processes = Array();
$process_id = Array();
$process_title = Array();
$process_description = Array();
$process_intro = Array();
$process_published_on = Array();
$process_created_at = Array();
$process_updated_at = Array();
$process_expires_on = Array();

//local variables - comments
$comment_id = Array();
$comment_user_id = Array();
$comment_description = Array();
$comment_created_at = Array();
$comment_updated_at = Array();
$comment_state = Array();
$comment_commentable_id = Array();


//Other variables
$last_id = 0;

//Main code: CREATING PROCESSES

//first connection
$conn = pg_connect("host=".$host." port=".$port." dbname=".$database." user=".$username." password=".$password);
if(!$conn) {
  echo "Error : Unable to open database to extract data. Aborting.\n";
} else {
  echo "<p>Opened database to extract data successfully.</p>";
}
//get project data
$sql = get_project_information();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {
	//loop all project rows
   while($row = pg_fetch_row($ret)) {
	  //get locales from other table
      $sql2 = get_translation_information_from_project($row[0]);

      $ret2 = pg_query($conn, $sql2);
		if(!$ret2) {
			echo pg_last_error($conn);
			exit;
		} else {
			array_push($process_id, $row[0]);
			array_push($process_created_at, $row[11]);
			array_push($process_updated_at, $row[12]);
			array_push($process_expires_on, $row[3]);
			array_push($process_published_on, $row[4]);
			//declare arrays for titles, description and intro locales
			$processTitle = Array();
			$processDescription = Array();
			$processIntro = Array();
			//loop trough them and assign to arrays
			while($row2 = pg_fetch_row($ret2)) {
				//if the translation has no content, put the original content inside
			   	if ($row2[3] == "") $processTitle[$row2[2]] = $row[2];
			   	else $processTitle[$row2[2]] = $row2[3];

			   	if ($row2[4] == "") $processDescription[$row2[2]] = $row[14];
			   	else $processDescription[$row2[2]] = $row2[4];

			   	if ($row2[5] == "") $processIntro[$row2[2]] = $row[2];
			   	else $processIntro[$row2[2]] = $row2[5];
			}
		   //append those arrays to the main process array
			array_push($process_title, $processTitle);
			array_push($process_description, $processDescription);
			array_push($process_intro, $processIntro);
			//unset arrays for next process locales
			unset($processTitle);
			unset($processDescription);
			unset($processIntro);

			if ($last_id < $row[0]) $last_id = $row[0];
		}
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

//insert project data into decidim_participatory_processes
for ($i=0; $i < count($process_id); $i++) { 
	//creating process
	echo $process_expires_on[$i];
	$sql = insert_process_data($process_id[$i], $process_title[$i], $process_description[$i], $process_intro[$i], $process_published_on[$i], $process_created_at[$i], $process_updated_at[$i], $process_expires_on[$i]);
	$ret = pg_query($conn, $sql);
	if(!$ret) {
	  echo pg_last_error($conn);
	} else {
	  echo "<p>Process record with id $process_id[$i] created successfully</p>\n";
	}
	//creating feature for process
	$sql2 = insert_feature_for_process($process_id[$i]);
	$ret2 = pg_query($conn, $sql2);
	if(!$ret2) {
	  echo pg_last_error($conn);
	} else {
      	echo "<p>Feature created for process $process_id[$i]</p>\n";

		$sql3 = get_page_from_process_id($process_id[$i]);
		$ret3 = pg_query($conn, $sql3);
		if(!$ret3) {
		  echo pg_last_error($conn);
		  exit;
		} else {
			//loop all project rows
			while($row3 = pg_fetch_row($ret3)) {
				//creating page for process feature
			   $sql4 = insert_page_for_feature($row3[0]);
			   $ret4 = pg_query($conn, $sql4);
			   if(!$ret4) {
			      echo pg_last_error($conn);
			   } else {
			      echo "<p>Page feature created for process $process_id[$i]</p>\n";
			   }
			}
		}
	}

	$sql2 = create_phase_for_process($process_id[$i]);
	$ret2 = pg_query($conn, $sql2);
	if(!$ret2) {
	  echo pg_last_error($conn);
	} else {
      	echo "<p>Phase created for process $process_id[$i]</p>\n";
	}

}

$sql = alter_decidim_participatory_processes_id_seq($last_id);
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
} else {
  echo "<p>ID_SEQUENCE modified correctly</p>\n";
}


//close second connection
pg_close($conn);


//CREATING COMMENTS
//first connection
$conn = pg_connect("host=".$host." port=".$port." dbname=".$database." user=".$username." password=".$password);
if(!$conn) {
  echo "Error : Unable to open database to extract data. Aborting.\n";
} else {
  echo "<p>Opened database to extract data successfully.</p>";
}
//get comments data
$sql = get_comments_information();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {
	//loop all project rows
   while($row = pg_fetch_row($ret)) {
		array_push($comment_id, $row[0]);
		array_push($comment_user_id, $row[1]);
		array_push($comment_commentable_id, $row[3]);
		array_push($comment_description, $row[4]);
		array_push($comment_created_at, $row[5]);
		array_push($comment_updated_at, $row[6]);
		array_push($comment_state, $row[7]);
   }
}
//close first connection
pg_close($conn);

//<-- NOT WORKING ATM

//second connection
$conn = pg_connect("host=".$DBhost." port=".$DBport." dbname=".$DBdatabase." user=".$DBusername." password=".$DBpassword);
if(!$conn) {
  echo "Error : Unable to open database to insert data. Aborting.\n";
} else {
  echo "<p>Opened database to insert data successfully.</p>";
}
//set comments data
for ($i=0; $i < count($comment_commentable_id); $i++) {

	$sql2 = get_page_from_process_id(
		$comment_commentable_id[$i]
		);

	$ret2 = pg_query($conn, $sql2);
	if(!$ret2) {
	  echo pg_last_error($conn);
	  exit;
	} else {
		$feature_page_id = 0;

		while($row = pg_fetch_row($ret2)) {
			$feature_page_id = $row[0];
		}

		$sql3 = get_page_id_from_feature_id(
			$feature_page_id
		);
		$ret3 = pg_query($conn, $sql3);
		if(!$ret3) {
		  echo pg_last_error($conn);
		  exit;
		} else {
			$pages_pages_id = 0;
			while($row3 = pg_fetch_row($ret3)) {
				$pages_pages_id = $row3[0];
			}
			$sql = set_comments_information(
				$comment_id[$i],
				$comment_user_id[$i],
				$comment_commentable_id[$i],
				$comment_description[$i],
				$comment_created_at[$i],
				$comment_updated_at[$i],
				$comment_state[$i],
				$pages_pages_id
			);

			$ret = pg_query($conn, $sql);
			if(!$ret) {
			  echo pg_last_error($conn);
			  exit;
			} else {
			    echo "<p>Comment created for process $comment_id[$i]</p>\n";
			}
		}
	}
}
//close first connection
pg_close($conn);

//NOT WORKING ATM -->



//functions
function generateRandomString($length = 10) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

function get_project_information() {
	return $sql =<<<EOF
	  SELECT * FROM projects;
EOF;
}

function get_translation_information_from_project($project_id) {
	return $sql =<<<EOF
	  SELECT * FROM project_translations
		  WHERE project_id = $project_id;
EOF;

}

function insert_process_data($process_id, $process_title, $process_description, $process_intro, $process_published_on, $process_created_at, $process_updated_at ,$process_expires_on, $organization_id = 1, $process_group = 2) {
	//first convert locales arrays to JSON
	$process_title 		 = json_encode($process_title);
	$process_description = json_encode($process_description);
	$process_intro  	 = json_encode($process_intro);
	
	//replace single quotes to scape them in the insert statement
	
	$process_title = str_replace("'", "''", $process_title);
	$process_description = str_replace("'", "''", $process_description);
	$process_intro = str_replace("'", "''", $process_intro);
echo $process_expires_on;
	$randomString = generateRandomString(8);
	return $sql =<<<EOF
	  INSERT INTO decidim_participatory_processes (id, title, description, short_description,subtitle, published_at, created_at, updated_at, slug, decidim_organization_id, decidim_participatory_process_group_id, end_date)
		  values ($process_id, '$process_title', '$process_description', '{"ca": "", "es": ""}','$process_title',to_timestamp('$process_published_on', 'YYYY-MM-DD hh24:mi:ss'), to_timestamp('$process_created_at', 'YYYY-MM-DD hh24:mi:ss'), to_timestamp('$process_updated_at', 'YYYY-MM-DD hh24:mi:ss'), '$randomString', $organization_id, $process_group, date('$process_expires_on'));
EOF;
}

function insert_feature_for_process($process_id, $organization_id = 1) {
	return $sql =<<<EOF
	  INSERT INTO decidim_features (manifest_name, name, decidim_participatory_process_id, settings, weight, published_at)
	    values ('pages', '{"ca": "Comentaris", "es": "Comentarios"}', $process_id, '{"steps": {}, "global": {"comments_enabled": true}}', 0, now()::timestamp);
EOF;
}

function get_comments_information () {
	return $sql =<<<EOF
	  SELECT * FROM comments;
EOF;
}


function set_comments_information(
	$comment_id,
	$comment_user_id,
	$comment_commentable_id,
	$comment_description,
	$comment_created_at,
	$comment_updated_at,
	$comment_state,
	$comment_page_id
	)
{
	$comment_description = str_replace("'", "''", $comment_description);

	return $sql =<<<EOF
	  INSERT INTO decidim_comments_comments (
	  	body,
	   	decidim_commentable_type, 
	   	decidim_commentable_id,
	   	decidim_root_commentable_type, 
	   	decidim_root_commentable_id,
	   	decidim_author_id,
	   	created_at,
	   	updated_at
	   	)
	  	VALUES (
	  	'$comment_description',
	  	'Decidim::Pages::Page',
	  	$comment_page_id,
	  	'Decidim::Pages::Page',
	  	$comment_page_id,
	  	$comment_user_id,
 		to_timestamp('$comment_created_at', 'YYYY-MM-DD hh24:mi:ss'), 
 		to_timestamp('$comment_updated_at', 'YYYY-MM-DD hh24:mi:ss')
 		);
EOF;

}

function get_page_from_process_id ($process_id) {
	return $sql =<<<EOF
		SELECT id FROM decidim_features WHERE manifest_name = 'pages' AND decidim_participatory_process_id = $process_id LIMIT 1;
EOF;

}

function insert_page_for_feature($feature_id)
{
	return $sql =<<<EOF
		INSERT INTO decidim_pages_pages (body, decidim_feature_id, created_at, updated_at) VALUES ('{"ca": "Comentaris", "es" : "comentaris"}', $feature_id, now()::timestamp, now()::timestamp);
EOF;
}

function create_phase_for_process($process_id) {
	return $sql =<<<EOF
		INSERT INTO decidim_participatory_process_steps (
		title, 
		description, 
		start_date, 
		end_date, 
		decidim_participatory_process_id, 
		created_at, 
		updated_at,
		active, 
		position
		) VALUES (
		'{"ca": "Fase inicial", "es" : "Fase incial"}',
		'{"ca": "Fase inicial de la participació", "es" : "Fase incial de la participació"}',
		current_date,
		current_date + interval '1 month',
		$process_id,
		now()::timestamp, 
		now()::timestamp,
		TRUE,
		0
		);
EOF;
}

function get_page_id_from_feature_id($feature_page_id) {
	return $sql =<<<EOF
		SELECT id FROM decidim_pages_pages WHERE decidim_feature_id = $feature_page_id LIMIT 1;
EOF;
}

function alter_decidim_participatory_processes_id_seq (
	$id) {
	$id++;
	return $sql =<<<EOF
	ALTER SEQUENCE decidim_participatory_processes_id_seq RESTART $id;
EOF;
}
?>
