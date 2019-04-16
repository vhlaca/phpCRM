<?php
require_once 'en.php';
require_once 'sessionManagement.php';
if(isset($_POST['doThis']) && !empty($_POST['doThis'])) {
    $doThis = $_POST['doThis'];
	if(function_exists($doThis)) {        
		call_user_func($doThis);
	} else {
		echo 'Function Not Exists!!';
	}
}

function CheckLogin (){
	require_once 'dblogininfo.php';
	$userName=$_POST['userName'];
	$password=$_POST['password'];
	$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
	$mysqli->set_charset("utf8");
	$result = $mysqli->query("CALL CheckLogin('$userName','$password')");
	if (!$result) die ("Database access failed: " . $mysqli->error.".");
	if($result->num_rows==0||$result->num_rows>1)
	{
		echo LOGIN_INCORRECT;
	}
	else
	{
		
		$row = $result->fetch_assoc();
		$_SESSION['user'] = serialize($row);
		echo "Success";
	}
}

function IsLogged (){

	if(isset($_SESSION['user'])){
		$userRecord=unserialize($_SESSION['user']);
		//echo $_SESSION['user'];
		echo "Success: ".$userRecord['firstName']." ".$userRecord['lastName'];
	}
	else
	{
		echo "Fail";	
	}
}

function LogOut(){
	session_destroy();
	echo "Logged out";	
}

?>