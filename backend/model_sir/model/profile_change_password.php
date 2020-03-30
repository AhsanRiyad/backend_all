<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

// $id__ = 1;

$data =  file_get_contents('php://input');
$d1 = json_decode($data);



if($d1->purpose == 'password'){


  $password1= md5($d1->password);

	//echo $password1;
  $id__ = $d1->id;
  $email = $d1->email;
  $conn = get_mysqli_connection();
  $sql = "call update_profile_password( ? , ? , @result)";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('is' , $id__ , $password1 );

  $stmt->execute();
  $stmt->close();
  $sql = 'select @result as st'; 
  $result = mysqli_query($conn, $sql);
  $row = mysqli_fetch_assoc($result);

  echo $row['st'];



}
else if($d1->purpose == 'getProfileBasicInfo'){

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
}