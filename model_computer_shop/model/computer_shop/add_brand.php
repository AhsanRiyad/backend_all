<?php 
include "../../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

//echo 'in the model';


$conn = get_mysqli_connection();
//echo 'in the model';

$data =  file_get_contents('php://input');
$d1 = json_decode($data);



$brand_name = mysqli_real_escape_string($conn ,  $d1->brand_name);
$brand_details = mysqli_real_escape_string($conn ,  $d1->brand_details);    
$who_is_adding = mysqli_real_escape_string($conn ,  $d1->who_is_adding);

echo $brand_name;

$sql = "select count(*) as st from brand where brand_name = '".$brand_name."' ";
$result = mysqli_query($conn, $sql);

$row = mysqli_fetch_assoc($result);
// echo $row['st'];

// echo $row['st'];
if($row['st'] == 0){

	$sql = "INSERT INTO brand (brand_name , brand_description) VALUES ( '".$brand_name."' , '".$brand_details."' )";
	$result = mysqli_query($conn, $sql);
	echo 'successful';

}else{
	echo 'duplicate brand_name';
}

$conn->close();


?>