<?php 
include "../../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

//echo 'in the model';


$conn = get_mysqli_connection();
//echo 'in the model';

$data =  file_get_contents('php://input');
$d1 = json_decode($data);



$category_name = mysqli_real_escape_string($conn ,  $d1->category_name);
$category_details = mysqli_real_escape_string($conn ,  $d1->category_details);    
$who_is_adding = mysqli_real_escape_string($conn ,  $d1->who_is_adding);

// echo $brand_name;

$sql = "select count(*) as st from category where category_name = '".$category_name."' ";
$result = mysqli_query($conn, $sql);

$row = mysqli_fetch_assoc($result);
// echo $row['st'];

// echo $row['st'];
if($row['st'] == 0){

	$sql = "INSERT INTO category (category_name , category_description) VALUES ( '".$category_name."' , '".$category_details."' )";
	$result = mysqli_query($conn, $sql);
	echo 'successful';

}else{
	echo 'duplicate category_name';
}

$conn->close();


?>