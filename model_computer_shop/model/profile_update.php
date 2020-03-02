<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

include 'email_config.php';

$data =  file_get_contents('php://input');
$d1 = json_decode($data);
// $email = 'riyad298@gmail.com';

//echo $d1->purpose;


function verify_change_request($user_id){


$conn = get_mysqli_connection();
$sql = "select `full_name`, `mobile`, `institution_id`,`nid_or_passport`, `fathers_name`, `mother_name`, `spouse_name`, `number_of_children`, `profession`, `designation`, `institution`, `blood_group`, `date_of_birth`, `present_line1`, `present_district`, `present_post_code`, `present_country`, `parmanent_line1`,  `parmanent_district`, `parmanent_post_code`, `parmanent_country`  from all_info_together where  id = ".$user_id." ";

$result = mysqli_query($conn, $sql);
  if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
  }

$arrayValueString =  implode(',' ,$row);
$arrayKeyString =  implode(',' , array_keys($row));
$newArrayString = $arrayKeyString .'@#$'.$arrayValueString;
$arrayTogether = explode('@#$' , $newArrayString);
$array1keyString = $arrayTogether[0];
$array2ValueString = $arrayTogether[1];
//final pair1
$arrayKey_tobeUpdated =  $stringToArrayKey = explode(',' , $array1keyString);
$arrayValue_tobeUpdated = $stringToArrayValue = explode(',' , $array2ValueString);
$arrayAssoc;
$i = 0;
for($i =0; $i<count($stringToArrayKey); $i++){
  
   $arrayAssoc[$stringToArrayKey[$i]] = $stringToArrayValue[$i];
}
$sql = "select last_verified_info from all_info_together where  id = ".$user_id." ";

$result = mysqli_query($conn, $sql);
  if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
  }


$array =  explode('@#$' , $row['last_verified_info']);
//desired array
$arrayKey_from_database =  $stringToArrayKey_from_verified_info = explode(',' , $array[0] );
$arrayValue_from_database = $stringToArrayValue_from_verified_info = explode(',' , $array[1] );
$arrayNew = [];
for($i=0; $i<count($arrayValue_from_database) ; $i++){
  if($arrayValue_from_database[$i] != $arrayValue_tobeUpdated[$i]){
    $arrayNew[$arrayKey_from_database[$i]] = [$arrayValue_tobeUpdated[$i], $arrayValue_from_database[$i]] ; 
  }
}

if(count($arrayNew)==0){

  $sql = "update all_info_together set change_request = 'not_requested'  where id = ".$user_id." ";
  mysqli_query($conn , $sql);

}

 $conn->close();
}



else if($d1->purpose == 'email'){


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
}else if($d1->purpose == 'forgot_password'){


  $email1 = $d1->email;

	//echo $email1;

  $randomNumber = md5(rand(10,1000));
  $purpose = 'generate_crypto';

  $conn = get_mysqli_connection();
  $sql = "call update_profile_forgot_password( ? , ? , ? , @result)";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('sss' , $email1 , $randomNumber , $purpose );

  $stmt->execute();
  $stmt->close();
  $sql = 'select @result as st'; 
  $result = mysqli_query($conn, $sql);
  $row = mysqli_fetch_assoc($result);

  if($row['st']=='no_email_found'){
    echo $row['st'];
  }else if($row['st']=='crypto_added'){


    $mailto = $email1;
    $mailSub = 'Password recovery , friends Forever';
    $mailMsg = 'Click to recover your password <br>'. $rootAdress.'pages/forgot.php?e='.$email1.'&c='.$randomNumber;


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

  }



}else if($d1->purpose == 'getProfileBasicInfo'){

  $conn = get_mysqli_connection();
  $sql = "select * from all_info_together where id = ".$id__."";

  $result = mysqli_query($conn, $sql);
  if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    echo json_encode($row);
  } else {
    echo "0 results";
  }
  mysqli_close($conn);


	// $i = 0;
// echo json_encode(var_dump($row));
}else if($d1->purpose == 'forgot_password_recovery'){

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

	// $i = 0;
// echo json_encode(var_dump($row));
}else if($d1->purpose == 'verify_email_otp'){


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
}else if($d1->purpose == 'profile_completeness_100'){

  $user_type = $d1->user_type;
  $conn = get_mysqli_connection();
  $sql = '';
  if($user_type == 'admin'){
    $sql = "call user_request(? , @result)";
  }else if($user_type == 'user'){
    $sql = "update all_info_together set completeness = 100 where id = (?)";
  }

  $stmt = $conn->prepare($sql);
  $stmt->bind_param('i' , $id__ );

  $stmt->execute();
  $stmt->close();
  $conn->close();

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