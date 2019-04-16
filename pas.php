<?php 
require_once 'en.php';
require_once 'sessionManagement.php';

//if(isset($_SESSION['user'])){
	if(isset($_POST['doThis']) && !empty($_POST['doThis'])) {
		$doThis = $_POST['doThis'];
		if(function_exists($doThis)) {        
			call_user_func($doThis);
		} else {
			echo FunctionDoesntExist;
		}
	}
/*}
else
	{
		echo notLoggedIn;	
	}*/

function PASSearch (){
		require_once 'dblogininfo.php';
		$searchString=$_POST['searchString'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$result = $mysqli->query("CALL SearchPAS('$searchString')");
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

function GetPAS (){
	require_once 'dblogininfo.php';
	$pas=$_POST['pas'];
	$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
	$mysqli->set_charset("utf8");
	$result = $mysqli->query("CALL GetPAS('$pas')");
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

function GetSales (){
	require_once 'dblogininfo.php';
	$sales=$_POST['sales'];
	$customer=$_POST['customer'];
	$contact=$_POST['contact'];
	$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
	$mysqli->set_charset("utf8");
	$result = $mysqli->query("CALL GetSales('$sales','$contact','$customer')");
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

function GetSalesStatus (){
	require_once 'dblogininfo.php';

	$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
	$mysqli->set_charset("utf8");
	$result = $mysqli->query("CALL GetSalesStatus()");
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

function GetPASContent (){

		require_once 'dblogininfo.php';
		$pas=$_POST['pas'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$result = $mysqli->query("CALL GetPASContent('$pas')");
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

function GetPASContainedIn (){

		require_once 'dblogininfo.php';
		$pas=$_POST['pas'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$result = $mysqli->query("CALL GetPASContainedIn('$pas')");
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


function SavePAS (){
		$userRecord=unserialize($_SESSION['user']);
		require_once 'dblogininfo.php';
		$pas=$_POST['pas'];
		$name=$_POST['name'];
		$description=$_POST['description'];	
		$p_s_b=$_POST['p_s_b'];	
		$organizationID=$_POST['organization'];
		if ($organizationID==null) $organizationID=$userRecord['organization'];
		$modifiedBy=$userRecord['id'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$toReturn="";
		if ($pas==""){
			$result = $mysqli->query("CALL InsertPAS('$name','$description','$p_s_b','$organizationID','$modifiedBy')");
			$row=$result->fetch_row();
			$toReturn=$row[0];
		}
		else
		{
			$result = $mysqli->query("CALL SavePAS('$pas','$name','$description','$p_s_b','$organizationID','$modifiedBy')");
			$row=$result->fetch_row();
			$toReturn=$row[0];
			//$toReturn=$mysqli->affected_rows;
		};
		if (!$result) die ("Database access failed: " . $mysqli->error.".");
		echo $toReturn;
		
}

function DeletePAS (){
		$userRecord=unserialize($_SESSION['user']);
		require_once 'dblogininfo.php';
		$pas=$_POST['pas'];
		$modifiedBy=$userRecord['id'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$toReturn="";
		$result = $mysqli->query("CALL DeletePAS('$pas','$modifiedBy')");
		$row=$result->fetch_row();
		$toReturn=$row[0];
		if (!$result) die ("Database access failed: " . $mysqli->error.".");
		echo $toReturn;
}

function SavePASContent (){
		$userRecord=unserialize($_SESSION['user']);
		require_once 'dblogininfo.php';
		$data=$_POST['data'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$toReturn="";
		$result = $mysqli->query("CALL InsertPASContent('$data')");
		$row=$result->fetch_row();
		$toReturn=$row[0];
		if (!$result) die ("Database access failed: " . $mysqli->error.".");
		echo $toReturn;
		
}

?>