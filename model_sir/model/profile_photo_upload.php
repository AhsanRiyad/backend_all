<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

use Spatie\ImageOptimizer\OptimizerChainFactory;

require $APP_ROOT.'vendor/autoload.php';

// $optimizerChain = OptimizerChainFactory::create();

$purpose_type =  $_POST['purpose'];
$conn = get_mysqli_connection();

$target_dir = $APP_ROOT."assets/img/uploads/".$purpose_type."s/";
$target_file1 = $target_dir . basename($_FILES[$purpose_type]["name"]);
$uploadOk = 1;
$imageFileType = strtolower(pathinfo($target_file1,PATHINFO_EXTENSION));
$target_file = $target_dir . basename($_POST["user_id"].'.'.$imageFileType);
$base_name = basename($_POST["user_id"].'.'.$imageFileType);
$email = $_POST['email'];
$user_id = $_POST['user_id'];



if($purpose_type == 'group_photo'){

	$conn = get_mysqli_connection();
	$sql = "select count(*) as count from user_photos where email = '".$email."' ";
	$result = mysqli_query($conn, $sql);
	if (mysqli_num_rows($result) > 0) {
		$row = mysqli_fetch_assoc($result);
	}
				// print_r($row['count']);
	$count = $row['count'];
	$newName = basename($_POST["user_id"].'_'.++$count.'.');
					// $base_name = basename($_POST["email"].'_1.'.$imageFileType);
	$base_name = $newName.$imageFileType;
	$target_file = $target_dir . $base_name;
	move_uploaded_file($_FILES[$purpose_type]["tmp_name"], $target_file) ;

	

	$sql = "call upload_photo( ? , ? , ? , ?, @existing_file_name , @result )";
	$stmt = $conn->prepare($sql);
	$stmt->bind_param('sssi' , $purpose_type ,  $base_name , $email, $user_id );
	$stmt->execute();
	$stmt->close();
	$sql = 'select @existing_file_name as st , @result as rs'; 
	$result = mysqli_query($conn, $sql);
	$row = mysqli_fetch_assoc($result);
	$conn->close();
	echo $row['rs'];

}else if ($purpose_type == 'recent_photo' || $purpose_type == 'old_photo'){


	$sql = "select recent_photo , old_photo from user_uploads where email = '".$email."' ";
	$result = mysqli_query($conn , $sql);
	if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
  	}

  	$random_number = rand(10,100);

  	$target_file_recent_photo = $target_dir . $row['recent_photo'];
  	$target_file_old_photo = $target_dir . $row['old_photo'];
	$base_name = basename($_POST["user_id"].'_'.$random_number.'.'.$imageFileType);
	$target_file = $target_dir . $base_name;

	//echo $target_file_recent_photo;

	if (file_exists($target_file_recent_photo)){
		unlink($target_file_recent_photo); 
	}else if (file_exists($target_file_old_photo)){
		unlink($target_file_old_photo); 
	}

	move_uploaded_file($_FILES[$purpose_type]["tmp_name"], $target_file) ;
	
	$sql = "call upload_photo( ? , ? , ? , ?, @existing_file_name , @result )";
	$stmt = $conn->prepare($sql);
	$stmt->bind_param('sssi' , $purpose_type ,  $base_name , $email, $user_id );
	$stmt->execute();
	$stmt->close();
	$sql = 'select @existing_file_name as st , @result as rs'; 
	$result = mysqli_query($conn, $sql);
	$row = mysqli_fetch_assoc($result);
	$conn->close();
	echo $row['rs'];


}



?>