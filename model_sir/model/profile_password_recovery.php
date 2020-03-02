<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

// $id__ = 1;

$data =  file_get_contents('php://input');
$d1 = json_decode($data);


if($d1->purpose == 'forgot_password_recovery'){

  $email1 = $d1->email;
  $forgot_password_crypto = $d1->forgot_password_crypto;
  $purpose = 'crypto_check';

	//echo $email1;

  $conn = get_mysqli_connection();
  $sql = "call update_profile_forgot_password( ? , ? , ? , @result)";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('sss' , $email1 , $forgot_password_crypto , $purpose );

  $stmt->execute();
  $stmt->close();
  $sql = 'select @result as st'; 
  $result = mysqli_query($conn, $sql);
  $row = mysqli_fetch_assoc($result);

  echo $row['st'];

}else if($d1->purpose == 'password_change'){


  $password1= md5($d1->password);
  // $password1= $d1->password;
  $email = $d1->email ; 

	//echo $password1;

  $conn = get_mysqli_connection();
  $sql = "update users_registration set password = '".$password1."' where email = '".$email."' ";
  $result = mysqli_query($conn, $sql);

  mysqli_close($conn);

  // echo $row['st'];
  echo 'success';



}