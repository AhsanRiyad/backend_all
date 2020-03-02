<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

include 'email_config.php';


$id__ = 1;
$data =  file_get_contents('php://input');
$d1 = json_decode($data);


if($d1->purpose == 'forgot_password'){


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
    $mailMsg = 'Click to recover your password <br>'. $rootAdressDomain.'profile_password_recovery?e='.$email1.'&c='.$randomNumber;


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



}