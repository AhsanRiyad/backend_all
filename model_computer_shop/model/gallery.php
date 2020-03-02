
<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 



// echo 'you are in gallery';

$data =  file_get_contents('php://input');
$d2 = json_decode($data);
// echo $d2->purpose;

// echo $d2->purpose;

$email = $email__;
$user_id = $id__;





function getPhotos(){


	$conn = get_mysqli_connection();
	$sql = "select * from all_info_together where  id = ".$user_id." ";
	
	//print_r($row);


	//echo json_encode($row);
	$array2d ;

	$result = mysqli_query($conn, $sql);
	if (mysqli_num_rows($result) > 0) {
		$row = mysqli_fetch_assoc($result);
	}

	$recent_photo = $row['recent_photo'];
	$old_photo = $row['old_photo'];

	$arrayPhoto = array( 'recent_photo' => $recent_photo , 'old_photo' => $old_photo );


	$sql = "select * from user_photos up where up.email = '".$email."' ";
	$result = mysqli_query($conn, $sql);
// $row = $result->fetch_assoc();


	$i = 0;
// echo json_encode(var_dump($row));
	while($row = mysqli_fetch_assoc($result)) {

		$arrayPhoto['group_photo'][$i] = $row['group_photo']; 
		$i++;
	}

	
	$conn->close();


	return json_encode($arrayPhoto);




}




if($d2->purpose == 'getPhotos'){

	$conn = get_mysqli_connection();
	$sql = "select * from all_info_together  where id = ".$user_id."  ";
	
	//print_r($row);


//echo json_encode($row);
	$array2d ;

	$result = mysqli_query($conn, $sql);
	if (mysqli_num_rows($result) > 0) {
		$row = mysqli_fetch_assoc($result);
	}

	$recent_photo = $row['recent_photo'];
	$old_photo = $row['old_photo'];

	$arrayPhoto = array( 'recent_photo' => $recent_photo , 'old_photo' => $old_photo );


	$sql = "select * from user_photos up where up.email = '".$email."' ";
	$result = mysqli_query($conn, $sql);
// $row = $result->fetch_assoc();


	$i = 0;
// echo json_encode(var_dump($row));
	while($row = mysqli_fetch_assoc($result)) {

		$arrayPhoto['group_photo'][$i] = $row['group_photo']; 
		$i++;
	}

	
	$conn->close();


	echo json_encode($arrayPhoto);




}else if($d2->purpose == 'getPhotos_for_all_users'){

	$email = $d2->email;
	$user_id = $d2->user_id;
	$conn = get_mysqli_connection();
	$sql = "select * from all_info_together  where  id = ".$user_id." ";
	
	//print_r($row);

	//echo json_encode($row);
	$array2d ;

	$result = mysqli_query($conn, $sql);
	if (mysqli_num_rows($result) > 0) {
		$row = mysqli_fetch_assoc($result);
	}

	$recent_photo = $row['recent_photo'];
	$old_photo = $row['old_photo'];

	$arrayPhoto = array( 'recent_photo' => $recent_photo , 'old_photo' => $old_photo );


	$sql = "select * from user_photos up where up.email = '".$email."' ";
	$result = mysqli_query($conn, $sql);
// $row = $result->fetch_assoc();


	$i = 0;
// echo json_encode(var_dump($row));
	while($row = mysqli_fetch_assoc($result)) {

		$arrayPhoto['group_photo'][$i] = $row['group_photo']; 
		$i++;
	}

	
	$conn->close();


	echo json_encode($arrayPhoto);




}else if($d2->purpose=='deletePhoto'){

	// $basename = trim($d2->basename)
	$email = $d2->email;
	$user_id = $d2->user_id;


	$bs = trim($d2->basename);
	//echo 'inside delete photo';
	$conn = get_mysqli_connection();
	//$sql = "delete FROM user_photos WHERE group_photo='$bs' and email='$email'";
	$sql = "delete FROM user_photos WHERE group_photo=(?) and email=(?)";
	$stmt = $conn->prepare($sql);
	// echo $sql;
	//mysqli_query($conn , $sql);
	//mysqli_close($conn);

	//echo trim($d2->basename);
	$stmt->bind_param('ss' ,  $bs , $email);
	$stmt->execute();

	$target_dir = $APP_ROOT."assets/img/uploads/group_photos/";
	$target_file = $target_dir . $bs;
	if (file_exists($target_file)){
		unlink($target_file);
	}

	
	$conn->close();

	
	$conn = get_mysqli_connection();
	$sql = "select * from all_info_together where id = ".$user_id." ";
	
	//print_r($row);


//echo json_encode($row);
	$array2d ;

	$result = mysqli_query($conn, $sql);
	if (mysqli_num_rows($result) > 0) {
		$row = mysqli_fetch_assoc($result);
	}

	$recent_photo = $row['recent_photo'];
	$old_photo = $row['old_photo'];

	$arrayPhoto = array( 'recent_photo' => $recent_photo , 'old_photo' => $old_photo );


	$sql = "select * from user_photos up where up.email = '".$email."' ";
	$result = mysqli_query($conn, $sql);
// $row = $result->fetch_assoc();


	$i = 0;
// echo json_encode(var_dump($row));
	while($row = mysqli_fetch_assoc($result)) {

		$arrayPhoto['group_photo'][$i] = $row['group_photo']; 
		$i++;
	}

	
	$conn->close();


	echo json_encode($arrayPhoto);

}





?>