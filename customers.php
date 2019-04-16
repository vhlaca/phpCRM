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

function CustomersSearch (){
		require_once 'dblogininfo.php';
		$searchString=$_POST['searchString'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$result = $mysqli->query("CALL SearchAllCustomersForOne('$searchString')");
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

function GetCustomer (){
		require_once 'dblogininfo.php';
		$customer=$_POST['customer'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$result = $mysqli->query("CALL GetCustomer('$customer')");
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

function SaveCustomer (){
		$userRecord=unserialize($_SESSION['user']);
		require_once 'dblogininfo.php';
		$customer=$_POST['customer'];
		$name=$_POST['name'];
		$description=$_POST['description'];	
		$webSite=$_POST['webSite'];	
		$phone=$_POST['phone'];	
		$address=$_POST['address'];	
		$city=$_POST['city'];
		$state=$_POST['state'];
		$country=$_POST['country'];	
		$parent=$_POST['parentName'];
		$entity_person=$_POST['entity_person'];
		$organizationID=$_POST['organization'];
		if ($organizationID==null) $organizationID=$userRecord['organization'];
		$modifiedBy=$userRecord['id'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$toReturn="";
		if ($customer==""){
			$result = $mysqli->query("CALL InsertCustomer('$name','$description','$webSite','$phone','$address','$city','$state','$country','$parent','$organizationID','$entity_person','$modifiedBy')");
			$row=$result->fetch_row();
			$toReturn=$row[0];
		}
		else
		{
			$result = $mysqli->query("CALL SaveCustomer('$customer','$name','$description','$webSite','$phone','$address','$city','$state','$country','$parent','$organizationID','$entity_person','$modifiedBy')");
			$row=$result->fetch_row();
			$toReturn=$row[0];
			//$toReturn=$mysqli->affected_rows;
		};
		if (!$result) die ("Database access failed: " . $mysqli->error.".");
		echo $toReturn;
		
}

function DeleteCustomer (){
		$userRecord=unserialize($_SESSION['user']);
		require_once 'dblogininfo.php';
		$customer=$_POST['customer'];
		$modifiedBy=$userRecord['id'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$toReturn="";
		$result = $mysqli->query("CALL DeleteCustomer('$customer','$modifiedBy')");
		$row=$result->fetch_row();
		$toReturn=$row[0];
		if (!$result) die ("Database access failed: " . $mysqli->error.".");
		echo $toReturn;
}



function GetCustomersShortAll (){
		require_once 'dblogininfo.php';
		//echo "jebiga";
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$result = $mysqli->query("CALL GetCustomersShortAll()");
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

function GetOrganizationsShortAll (){
		require_once 'dblogininfo.php';
		//echo "i ti isto";
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$result = $mysqli->query("CALL GetOrganizationsShortAll()");
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



function GetContactByCustomer (){

		require_once 'dblogininfo.php';
		$customer=$_POST['customer'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$result = $mysqli->query("CALL GetContactByCustomer('$customer')");
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

function GetChildCustomers (){

		require_once 'dblogininfo.php';
		$customer=$_POST['customer'];
		$mysqli = new MySQLi ($db_hostname, $db_username, $db_password, $db_database);
		$mysqli->set_charset("utf8");
		$result = $mysqli->query("CALL GetChildCustomers('$customer')");
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
