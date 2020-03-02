<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 


//header('Content-Type: text/html; charset=utf-8');


$conn = get_mysqli_connection();

// $conn->set_charset("utf8");


$sql = "insert into form_fields_rule ( field_name, rule) values('first_name' , 'mandatory')";

mysqli_query($conn , $sql);



$sql = "SELECT * FROM form_fields_rule";

$result = mysqli_query($conn , $sql);



if (mysqli_num_rows($result) > 0) {
	// $row = mysqli_fetch_assoc($result);

	$i = 0;
	$arrryData ;
	while($row = mysqli_fetch_assoc($result)){
		// print_r($row);
		$arrayData[$i] = $row;
		$i++;
	}
	//print_r($arrayData);
	echo json_encode($arrayData);


}


$conn->close();


