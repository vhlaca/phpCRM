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

function ContactsSearch (){
		//echo "jebi se pa rasti";
		require_once 'dblogininfo.php';
		$searchString=$_POST['searchString'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$result = $mysqli->query("CALL SearchAllContactsForOne('$searchString')");
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

function SaveContact() {
	$userRecord=unserialize($_SESSION['user']);
	require_once 'dblogininfo.php';
	$contact=$_POST['contact'];
	$firstName=$_POST['firstName'];
	$middleName=$_POST['middleName'];
	$lastName=$_POST['lastName'];
	$positionDescription=$_POST['positionDescription'];
	$description=$_POST['description'];	
	$customer=$_POST['customerName'];	
	$organizationID=$_POST['organization'];
	if ($organizationID==null) $organizationID=$userRecord['organization'];
	$email1Desc=$_POST['email1Desc'];
	$email1=$_POST['email1'];
	if(isset($_POST['email2Desc'])) {
		$email2Desc=$_POST['email2Desc'];
	}else{
		$email2Desc="";	
	}
	if(isset($_POST['email2'])) {
		$email2=$_POST['email2'];
	}else{
		$email2="";	
	}
	$phone1Desc=$_POST['phone1Desc'];
	$phone1=$_POST['phone1'];

	if(isset($_POST['phone2Desc'])) {
		$phone2Desc=$_POST['phone2Desc'];
	}else{
		$phone2Desc="";	
	}
	if(isset($_POST['phone2'])) {
		$phone2=$_POST['phone2'];
	}else{
		$phone2="";	
	}
	if(isset($_POST['phone3Desc'])) {
		$phone3Desc=$_POST['phone3Desc'];
	}else{
		$phone3Desc="";	
	}
	if(isset($_POST['phone3'])) {
		$phone3=$_POST['phone3'];
	}else{
		$phone3="";	
	}
	$modifiedBy=$userRecord['id'];

	$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
	$mysqli->set_charset("utf8");
	$toReturn="";
	if ($contact==""){
		$result = $mysqli->query("CALL InsertContact('$firstName', '$middleName', '$lastName', '$positionDescription', '$description', '$customer', '$organizationID', '$email1Desc', '$email1', '$email2Desc', '$email2', '$phone1Desc', '$phone1', '$phone2Desc', '$phone2', '$phone3Desc', '$phone3', '$modifiedBy')");
		$row=$result->fetch_row();
		$toReturn=$row[0];
	}
	else
	{
		$result = $mysqli->query("CALL SaveContact('$contact', '$firstName', '$middleName', '$lastName', '$positionDescription', '$description', '$customer', '$organizationID', '$email1Desc', '$email1', '$email2Desc', '$email2', '$phone1Desc', '$phone1', '$phone2Desc', '$phone2', '$phone3Desc', '$phone3', '$modifiedBy')");
		$row=$result->fetch_row();
		$toReturn=$row[0];
	};
	if (!$result) die ("Database access failed: " . $mysqli->error.".");
	echo $toReturn;
	
}

function GetContact (){
	require_once 'dblogininfo.php';
	$contact=$_POST['contact'];
	$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
	$mysqli->set_charset("utf8");
	$result = $mysqli->query("CALL GetContact('$contact')");
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

function GetContactsSales (){
	require_once 'dblogininfo.php';
	$contact=$_POST['contact'];
	$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
	$mysqli->set_charset("utf8");
	$result = $mysqli->query("CALL GetContactsSales('$contact')");
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


function DeleteContact (){
		$userRecord=unserialize($_SESSION['user']);
		require_once 'dblogininfo.php';
		$contact=$_POST['contact'];
		$modifiedBy=$userRecord['id'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$toReturn="";
		$result = $mysqli->query("CALL DeleteContact('$contact','$modifiedBy')");
		$row=$result->fetch_row();
		$toReturn=$row[0];
		if (!$result) die ("Database access failed: " . $mysqli->error.".");
		echo $toReturn;
}

?>