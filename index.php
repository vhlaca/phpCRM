<?php 
//session_start();
require_once 'en.php';
if(isset($_POST['doThis']) && !empty($_POST['doThis'])) {
    $doThis = $_POST['doThis'];
	if(function_exists($doThis)) {        
		call_user_func($doThis);
	} else {
		echo 'Function Not Exists!!';
	}
}

function WideSearch (){
	require_once 'dblogininfo.php';
	$searchString=$_POST['searchString'];
	$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
	$mysqli->set_charset("utf8");
	$result = $mysqli->query("CALL SearchAllForOne('$searchString')");
	if (!$result) die ("Database access failed: " . $mysqli->error.".");
	$returnString="[";
	WHILE($row = $result->fetch_assoc()){
		if($returnString!="["){
			$returnString=$returnString.",";	
		}
		$returnString=$returnString.json_encode($row);		
	}
	echo $returnString."]";
}

?>
