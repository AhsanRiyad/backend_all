<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 


// echo $APP_ROOT;



$conn = get_mysqli_connection();
$sql = "select * from category";
$result = mysqli_query($conn, $sql);

$arrayData;
$i = 0;
while($row = mysqli_fetch_assoc($result)){
		
	$arrayData['category'][$i++] = $row;

}

$sql = "select * from brand";
$arrayData;
$i = 0;
$result = mysqli_query($conn, $sql);
while($row = mysqli_fetch_assoc($result)){
		
	$arrayData['brand'][$i++] = $row;

}

// print_r($arrayData);

$conn->close();

echo json_encode($arrayData);
