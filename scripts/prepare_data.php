<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include('./db_params.php');

//please fill the following parameters:

//Organization name
$organization_name = "Generalitat de catalunya";
//host
$host = "test.participa.com";
//locales
$locales = '{ca, es}';



$conn = pg_connect("host=".$DBhost." port=".$DBport." dbname=".$DBdatabase." user=".$DBusername." password=".$DBpassword);
if(!$conn) {
  echo "Error : Unable to open database to extract data. Aborting.\n";
} else {
  echo "<p>Opened database to extract data successfully.</p>";
}

$sql = empty_decidim_admin_participatory_process_user_roles();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_attachments();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_authorizations();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_budgets_line_items();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_budgets_orders();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_budgets_projects();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}


$sql = empty_decidim_categorizations();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_categories();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_comments_comment_votes();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_comments_comments();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_departments();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_features();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_identities();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_meetings_meetings();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_moderations();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_newsletters();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_pages_pages();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_participatory_process_groups();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_participatory_process_steps();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_participatory_processes();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_proposals_proposal_votes();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_proposals_proposals();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_reports();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_resource_links();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_results_results();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_scopes();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}
/*
$sql = empty_decidim_static_pages();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}*/

$sql = empty_decidim_surveys_survey_answers();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_surveys_survey_questions();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_surveys_surveys();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_system_admins();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_themes();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_user_group_memberships();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_user_groups();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_decidim_users();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = empty_schema_migrations();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}

$sql = set_decidim_organizations(
	$organization_name,
	$host,
	$locales
	);
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}


$sql = fill_processes_groups_process();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}


$sql = fill_processes_groups_regulation();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}


$sql = set_decidim_processes_groups_sequence();
$ret = pg_query($conn, $sql);
if(!$ret) {
  echo pg_last_error($conn);
  exit;
} else {

}


function empty_decidim_admin_participatory_process_user_roles (){

	return $sql =<<<EOF
		DELETE FROM decidim_admin_participatory_process_user_roles;
EOF;

}
function empty_decidim_attachments (){

	return $sql =<<<EOF
		DELETE FROM decidim_attachments;
EOF;

}
function empty_decidim_authorizations (){

	return $sql =<<<EOF
		DELETE FROM decidim_authorizations;
EOF;

}
function empty_decidim_budgets_line_items (){

	return $sql =<<<EOF
		DELETE FROM decidim_budgets_line_items;
EOF;

}
function empty_decidim_budgets_orders (){

	return $sql =<<<EOF
		DELETE FROM decidim_budgets_orders;
EOF;

}
function empty_decidim_budgets_projects (){

	return $sql =<<<EOF
		DELETE FROM decidim_budgets_projects;
EOF;

}
function empty_decidim_categories (){

	return $sql =<<<EOF
		DELETE FROM decidim_categories;
EOF;

}
function empty_decidim_categorizations (){

	return $sql =<<<EOF
		DELETE FROM decidim_categorizations;
EOF;

}
function empty_decidim_comments_comment_votes (){

	return $sql =<<<EOF
		DELETE FROM decidim_comments_comment_votes;
EOF;

}
function empty_decidim_comments_comments (){

	return $sql =<<<EOF
		DELETE FROM decidim_comments_comments;
EOF;

}
function empty_decidim_departments (){

	return $sql =<<<EOF
		DELETE FROM decidim_departments;
EOF;

}
function empty_decidim_features (){

	return $sql =<<<EOF
		DELETE FROM decidim_features;
EOF;

}
function empty_decidim_identities (){

	return $sql =<<<EOF
		DELETE FROM decidim_identities;
EOF;

}
function empty_decidim_meetings_meetings (){

	return $sql =<<<EOF
		DELETE FROM decidim_meetings_meetings;
EOF;

}
function empty_decidim_moderations (){

	return $sql =<<<EOF
		DELETE FROM decidim_moderations;
EOF;

}
function empty_decidim_newsletters (){

	return $sql =<<<EOF
		DELETE FROM decidim_newsletters;
EOF;

}
function set_decidim_organizations (
	$organization_name,
	$host,
	$locales
	){
	return $sql =<<<EOF
		UPDATE decidim_organizations SET name = '$organization_name', host = '$host', available_locales = '$locales' WHERE id = 1;

EOF;

}
function empty_decidim_pages_pages (){

	return $sql =<<<EOF
		DELETE FROM decidim_pages_pages;
EOF;

}
function empty_decidim_participatory_process_groups (){

	return $sql =<<<EOF
		DELETE FROM decidim_participatory_process_groups;
EOF;

}
function empty_decidim_participatory_process_steps (){

	return $sql =<<<EOF
		DELETE FROM decidim_participatory_process_steps;
EOF;

}
function empty_decidim_participatory_processes (){

	return $sql =<<<EOF
		DELETE FROM decidim_participatory_processes;
EOF;

}
function empty_decidim_proposals_proposal_votes (){

	return $sql =<<<EOF
		DELETE FROM decidim_proposals_proposal_votes;
EOF;

}
function empty_decidim_proposals_proposals (){

	return $sql =<<<EOF
		DELETE FROM decidim_proposals_proposals;
EOF;

}
function empty_decidim_reports (){

	return $sql =<<<EOF
		DELETE FROM decidim_reports;
EOF;

}
function empty_decidim_resource_links (){

	return $sql =<<<EOF
		DELETE FROM decidim_resource_links;
EOF;

}
function empty_decidim_results_results (){

	return $sql =<<<EOF
		DELETE FROM decidim_results_results;
EOF;

}
function empty_decidim_scopes (){

	return $sql =<<<EOF
		DELETE FROM decidim_scopes;
EOF;

}
function empty_decidim_static_pages (){

	return $sql =<<<EOF
		DELETE FROM decidim_static_pages;
EOF;

}
function empty_decidim_surveys_survey_answers (){

	return $sql =<<<EOF
		DELETE FROM decidim_surveys_survey_answers;
EOF;

}
function empty_decidim_surveys_survey_questions (){

	return $sql =<<<EOF
		DELETE FROM decidim_surveys_survey_questions;
EOF;

}
function empty_decidim_surveys_surveys (){

	return $sql =<<<EOF
		DELETE FROM decidim_surveys_surveys;
EOF;

}
function empty_decidim_system_admins (){

	return $sql =<<<EOF
		DELETE FROM decidim_system_admins;
EOF;

}
function empty_decidim_themes (){

	return $sql =<<<EOF
		DELETE FROM decidim_themes;
EOF;

}
function empty_decidim_user_group_memberships (){

	return $sql =<<<EOF
		DELETE FROM decidim_user_group_memberships;
EOF;

}
function empty_decidim_user_groups (){

	return $sql =<<<EOF
		DELETE FROM decidim_user_groups;
EOF;

}
function empty_decidim_users (){

	return $sql =<<<EOF
		DELETE FROM decidim_users;
EOF;

}
function empty_schema_migrations (){

	return $sql =<<<EOF
		DELETE FROM schema_migrations;
EOF;

}

function fill_processes_groups_process ($decidim_organization_id = 1) {
	return $sql =<<<EOF
		INSERT INTO decidim_participatory_process_groups (
		id, name, description, decidim_organization_id, created_at, updated_at)
		VALUES (
		1, 
		'{"ca": "Procés", "es": "Proceso"}',
		'{"ca": "Procés tipus procés", "es": "Proceso tipo proceso"}',
		$decidim_organization_id,
		now()::timestamp,
		now()::timestamp
		);
EOF;

}

function fill_processes_groups_regulation ($decidim_organization_id = 1) {
	return $sql =<<<EOF
		INSERT INTO decidim_participatory_process_groups (
		id, name, description, decidim_organization_id, created_at, updated_at)
		VALUES (
		2, 
		'{"ca": "Consulta", "es": "Consulta"}',
		'{"ca": "Procés tipus consulta", "es": "Proceso tipo consulta"}',
		$decidim_organization_id,
		now()::timestamp,
		now()::timestamp
		);
EOF;

}

function set_decidim_processes_groups_sequence ($id = 3) {
	return $sql =<<<EOF
	ALTER SEQUENCE decidim_participatory_process_groups_id_seq RESTART $id;
EOF;
}

?>

