<?php 
include "../../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

echo 'in the model';

$data =  file_get_contents('php://input');
$d1 = json_decode($data);



$conn = get_mysqli_connection();
$full_name = mysqli_real_escape_string($conn ,  $d1->full_name);
$company_name = mysqli_real_escape_string($conn ,  $d1->company_name);    
$mobile = mysqli_real_escape_string($conn ,  $d1->mobile);
$email = mysqli_real_escape_string($conn ,  $d1->email);
$post_code = mysqli_real_escape_string($conn ,  $d1->post_code);
$address = mysqli_real_escape_string($conn ,  $d1->address);
$type = mysqli_real_escape_string($conn ,  $d1->type);
$who_is_adding = mysqli_real_escape_string($conn ,  $d1->who_is_adding);


$variables = " 
'".$company_name."',
'".$full_name."', 
'".$email."',
'".$mobile."',
'".$post_code."',
'".$address."',
'".$type."' ,
'".$who_is_adding."',
@result " ;

echo $variables;

$sql = "CALL add_people( ".$variables." )";
$result = mysqli_query($conn, $sql);


$sql = 'select @result as st'; 
$result = mysqli_query($conn, $sql);
$row = mysqli_fetch_assoc($result);


$conn->close();
echo $row['st'];


?>