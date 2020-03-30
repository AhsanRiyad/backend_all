<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 
include 'email_config.php';

// $id__ = 1;
// $email__ = 'ahsan.riyad@outlook.com';

$data =  file_get_contents('php://input');
$d1 = json_decode($data);


if($d1->purpose == 'email'){

  $email__ = $d1->email_old;
  $id__ = $d1->id;
  $email1 = $d1->email;

	//echo $email1;

  $conn = get_mysqli_connection();
  $sql = "select count(*) as count from all_info_together where email='".$email1."' ";
  $result = mysqli_query($conn, $sql);
  if (mysqli_num_rows($result) > 0) {
   $row = mysqli_fetch_assoc($result);
 }

 if($row['count'] > 0){
   echo 'email already exists';
 }else{
   $otp = rand(1000,9999);
   $mailto = $email1;
   $mailSub = 'OTP for Changine Email';
   $mailMsg = 'OTP '. $otp;


   $mail ->Subject = $mailSub;
   $mail ->Body = $mailMsg;
   $mail ->AddAddress($mailto);

   if(!$mail->Send())
   {
    echo 'server_problem';
  }else{

    $sql = "update all_info_together set otp = '".$otp."'  where id='".$id__."' ";
    $result = mysqli_query($conn, $sql);
    echo 'success';

  }

}

}else if($d1->purpose == 'changeEmail'){


  $email__ = $d1->email_old;
  $id__ = $d1->id;
  
  $email = $d1->email;
  $otp = $d1->otp;
  $conn = get_mysqli_connection();
  $sql = "call update_profile_email(".$id__.", '".$email__."', '".$email."' , '".$otp."' , @result)";

   // echo $sql;
  $result = mysqli_query($conn, $sql);

  $sql = "select @result as rs";
  $result = mysqli_query($conn, $sql);

  if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    echo $row['rs'];
  }


  //$result = mysqli_query($conn, $sql);
  //$sql = "select @result as rs";
 //  if (mysqli_num_rows($result) > 0) {
 //    $row = mysqli_fetch_assoc($result);
 //    echo $row['rs'];
 // }
 // mysqli_close($conn);


   // $i = 0;
// echo json_encode(var_dump($row));
}else if($d1->purpose == 'verify_email_otp'){


  // $email__ = $d1->email_old;
  $verify_email_otp = $d1->verify_email_otp;
  $purpose = $d1->purpose;
	// $otp = $d1->verify_email_otp;
	// $otp = rand(1000,9999);

	//echo $email1;
  $conn = get_mysqli_connection();
  $sql = "call email_verification_otp( ? , ? , ? , @result)";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('sss' , $email__ , $verify_email_otp , $purpose );

  $stmt->execute();
  $stmt->close();
  $sql = 'select @result as st'; 
  $result = mysqli_query($conn, $sql);
  $row = mysqli_fetch_assoc($result);


  echo $row['st'];

	// $i = 0;
// echo json_encode(var_dump($row));
}else if($d1->purpose == 'send_otp'){


	//$verify_email_otp = $d1->verify_email_otp;
  $purpose = $d1->purpose;
	// $otp = $d1->verify_email_otp;
  $otp = rand(1000,9999);

	//echo $email1;
  $conn = get_mysqli_connection();
  $sql = "call email_verification_otp( ? , ? , ? , @result)";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('sss' , $email__ , $otp , $purpose );

  $stmt->execute();
  $stmt->close();
  $sql = 'select @result as st'; 
  $result = mysqli_query($conn, $sql);
  $row = mysqli_fetch_assoc($result);


  if($row['st']=='otp_sent'){
    $mailto = $email__;
    $mailSub = 'OTP for email verification';
    $mailMsg = 'OTP '. $otp;


    $mail ->Subject = $mailSub;
    $mail ->Body = $mailMsg;
    $mail ->AddAddress($mailto);

    if(!$mail->Send())
    {
      echo 'server_problem';
    }
    else
    {
      echo $row['st'];
    }
  };

	// $i = 0;
// echo json_encode(var_dump($row));
}





