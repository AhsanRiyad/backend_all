<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 
header("Content-Type: application/json; charset=UTF-8");
$data =  file_get_contents('php://input');
$d2 = json_decode($data);





if($d2->purpose == 'getProfileBasicInfo'){
	$user_id = $d2->user_id;
	$conn = get_mysqli_connection();
	$sql = "select * from all_info_together where id = ".$user_id." ";
	
	$result = mysqli_query($conn, $sql);
	if (mysqli_num_rows($result) > 0) {
		$row = mysqli_fetch_assoc($result);
	}

	
	$conn->close();
	echo json_encode($row);
	// $i = 0;
// echo json_encode(var_dump($row));
}else if($d2->purpose=='approve_user'){
	//echo 'hi';
	$email = $d2->email;
	$user_id = $d2->user_id;
	//echo $email;
	// mysqli_close($conn);
	$conn = get_mysqli_connection();
	//mysqli_close($conn);
	$sql = "call user_request(".$user_id." , @result)";
	mysqli_query($conn , $sql);
	//mysqli_close($conn);
	
	$conn->close();
}else if($d2->purpose=='reject_user'){
	//echo 'hi';
	$email = $d2->email;
	$user_id = $d2->user_id;
	//echo $email;
	// mysqli_close($conn);
	$conn = get_mysqli_connection();
	//mysqli_close($conn);
	$sql = "UPDATE all_info_together SET status ='rejected' , completeness = 80  WHERE id = ".$user_id." ";
	$result = mysqli_query($conn, $sql);
	mysqli_close($conn);
	
	// $conn->close();
}else if($d2->purpose=='get_data'){
	//echo 'get data';
	$conn = get_mysqli_connection();
	$sql = "select * from all_info_together where status = 'not_verified'  and completeness = 100 and email_verification_status = 'verified' limit 0 , 20";
	$result = mysqli_query($conn, $sql);
	//$row = mysqli_fetch_assoc($result);
	//$array2d[0] = json_encode($row);
	//echo json_encode($array2d);
	mysqli_close($conn);
//print_r($row);
	$i = 0 ;
//echo json_encode($row);
	
	//echo mysqli_num_rows($result);
	//print_r(mysqli_fetch_assoc($result));
	if (mysqli_num_rows($result) > 1) {
    // output data of each row
		$array2d ;
		while($row = mysqli_fetch_assoc($result)) {
			//$GLOBALS['array2d'][$i++] = $row;
			$array2d[$i++] = $row;
    	// $array2d[$i++][$row];
			//echo $row['status'];
		}
		//echo 'get_>1';
		echo json_encode($array2d);
	} else if (mysqli_num_rows($result) == 1) {
		// echo 'get_=1';
		$row = mysqli_fetch_assoc($result);
		$array2d[0] = json_encode($row);
		echo json_encode($array2d);
	}else{
		echo mysqli_num_rows($result);
	}
	//echo json_encode($array2d);
//echo 'hi';
}