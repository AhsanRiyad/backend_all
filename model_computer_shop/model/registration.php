<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

$data =  file_get_contents('php://input');
$d1 = json_decode($data);


$email = $d1->email;
$first_name = $d1->first_name;
$last_name = $d1->last_name;
$mobile = $d1->mobile;
$institution_id = $d1->institution_id;
$password1 = md5($d1->password);
$otp = rand(1000,9999);
$who_is_doing_registration = $d1->who_is_doing_registration;

// echo $password;


 
// echo $password;

//echo $full_name;




$conn = get_mysqli_connection();

$sql = "CALL REGISTRATION( ? , ?, ?, ?, ?, ?, ? , ? , @result)";
$stmt = $conn->prepare($sql);
// $email =  'riyad298@afhorfooefoe.com';
// $full_name = 'Ahsan Riyad';
// $mobile = '01919448787';
// $institution_id = '01919448787';
// $password = '1';
 // $otp = 'aofhoerf';

$stmt->bind_param('ssssssss' , $email, $first_name, $last_name, $mobile, $institution_id, $password1, $otp , $who_is_doing_registration);
$stmt->execute();   

$stmt->close();
$sql = 'select @result as st'; 
$result = mysqli_query($conn, $sql);
$row = mysqli_fetch_assoc($result);

$conn->close();
//print_r($row);
echo $row['st'];


