<?php 

function get_mysqli_connection(){
    // Create connection
    $conn = new mysqli( $GLOBALS['hostName'],  $GLOBALS['userName'],  $GLOBALS['password'],  $GLOBALS['databaseName']);
// Check connection
    if ($conn->connect_error) {

        //var_dump($conn->connect_error);
        die("Connection failed: " . $conn->connect_error);
        //header('location:'.$rootAdress.'not_authorised.php');
    }


    return $conn; 

}





function get_mysqli_connect(){

$conn = mysqli_connect($GLOBALS['hostName'],  $GLOBALS['userName'],  $GLOBALS['password'],  $GLOBALS['databaseName']);


return $conn;

}





function get_PDO_connection(){


	$hostName = $GLOBALS['hostName'];
	$databaseName = $GLOBALS['databaseName'];

	try {
        $pdo = new PDO("mysql:host=$hostName;dbname=$databaseName", $GLOBALS['userName'], $GLOBALS['password']);	
 		return $pdo; 
       
    } catch (PDOException $e) {
        die("Error occurred:" . $e->getMessage());
    }


}




/*try {
    $conn = new PDO("mysql:host=$hostName;dbname=$databaseName", $userName, $password);
    // set the PDO error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }
catch(PDOException $e)
    {
    echo $e->getMessage();
    }
*/



//session







?>