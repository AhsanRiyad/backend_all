<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 
header("Content-Type: application/json; charset=UTF-8");
//print_r(json_encode($_REQUEST));
//print_r($_REQUEST['title']);
$data =  file_get_contents('php://input');
$d2 = json_decode($data);
//echo $d2->purpose;
if($d2->purpose=='get_data'){
	//echo 'get data';
	$conn = get_mysqli_connection();
	$sql = "select * from all_info_together where status = 'not_verified'  and email_verification_status = 'verified' limit 0 , 20";
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
}else if($d2->purpose=='get_change_req_user'){
	//echo 'get data';
	$conn = get_mysqli_connection();
	$sql = "select * from all_info_together where status = 'approved' and change_request = 'requested' limit 0 , 20";
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
}else if($d2->purpose=='get_change_req_data'){
$conn = get_mysqli_connection();
$user_id = $d2->user_id;
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

$conn->close();
echo json_encode($arrayNew);
}
else if($d2->purpose=='reject_user'){
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
}
else if($d2->purpose=='reject_user_user_request'){
	$email = $d2->email;
	$user_id = $d2->user_id;
	$conn = get_mysqli_connection();
$sql = "select last_verified_info from all_info_together where  id = ".$user_id." ";

$result = mysqli_query($conn, $sql);
	if (mysqli_num_rows($result) > 0) {
		$row = mysqli_fetch_assoc($result);
	}

$array =  explode('@#$' , $row['last_verified_info']);
$arrayValue_from_database = $stringToArrayValue_from_verified_info = explode(',' , $array[1] );

$update_sql_users_registration = "update all_info_together set `full_name`='".$arrayValue_from_database[0]."', `mobile`='".$arrayValue_from_database[1]."', `institution_id`='".$arrayValue_from_database[2]."'  where  email = '".$email."'";
mysqli_query($conn , $update_sql_users_registration);
$update_sql_users_info = "update all_info_together set `nid_or_passport`='".$arrayValue_from_database[3]."', `fathers_name`='".$arrayValue_from_database[4]."', `mother_name`='".$arrayValue_from_database[5]."', `spouse_name`='".$arrayValue_from_database[6]."', `number_of_children`=".$arrayValue_from_database[7].", `profession`='".$arrayValue_from_database[8]."', `designation`='".$arrayValue_from_database[9]."', `institution`='".$arrayValue_from_database[10]."', `blood_group`='".$arrayValue_from_database[11]."', `date_of_birth`='".$arrayValue_from_database[12]."'  where  email = '".$email."'";
mysqli_query($conn , $update_sql_users_info);
$update_sql_users_address = "update all_info_together set `present_line1`='".$arrayValue_from_database[13]."', `present_district`='".$arrayValue_from_database[14]."', `present_post_code`='".$arrayValue_from_database[15]."', `present_country`='".$arrayValue_from_database[16]."', `parmanent_line1`='".$arrayValue_from_database[17]."',  `parmanent_district`='".$arrayValue_from_database[18]."', `parmanent_post_code`='".$arrayValue_from_database[19]."', `parmanent_country`='".$arrayValue_from_database[20]."'  where  email = '".$email."'";
mysqli_query($conn , $update_sql_users_address);
$update_rejected_sql = "update all_info_together set change_request = 'rejected' where id = ".$user_id."";
mysqli_query($conn , $update_rejected_sql);
$conn->close();
}
else if($d2->purpose=='approve_user'){
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
}
else if($d2->purpose=='approve_user_change_request'){
	//echo 'hi';
	$email = $d2->email;
	$user_id = $d2->user_id;
	//echo $email;
	// mysqli_close($conn);
	$conn = get_mysqli_connection();
	//mysqli_close($conn);
	$sql = "update all_info_together set change_request = 'approved' where id = ".$user_id." ";
	mysqli_query($conn , $sql);
	mysqli_close($conn);
	
	$conn->close();
}else if($d2->purpose == 'make_admin'){
	$email = $d2->email;
	$user_id = $d2->user_id;
	$conn = get_mysqli_connection();
	$sql = "update all_info_together set type = 'admin' where id = ".$user_id." ";
	$result = mysqli_query($conn, $sql);

	
	$conn->close();
}else if($d2->purpose == 'make_user'){
	$email = $d2->email;
	$user_id = $d2->user_id;
	$conn = get_mysqli_connection();
	$sql = "update all_info_together set type = 'user' where id = ".$user_id." ";
	$result = mysqli_query($conn, $sql);
	
	$conn->close();
}
else if($d2->purpose=='get_user_details'){
	//echo 'hi';
	
	$email = $d2->email;
	//echo 'hi';
	//echo $email;
	$conn = get_mysqli_connection();
	$sql = "select * from users_registration ur , verification_info vi , users_info ui , users_address ua where ur.email = vi.email and ur.email = ui.email and ur.email = ua.email and vi.email = '".$email."' ";
	$result = mysqli_query($conn, $sql);
	//print_r($row);
	$i = 0 ;
//echo json_encode($row);
	$array2d ;
	while($row = mysqli_fetch_assoc($result)) {
		$GLOBALS['array2d'][$i++] = $row;
	}
	
	$conn->close();
	echo json_encode($array2d);
}
else if($d2->purpose == 'getProfileBasicInfo'){
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
}
else if($d2->purpose == 'number_of_request'){
	
	$conn = get_mysqli_connection();
	$sql = "call count_request(@verification_request, @change_request)";
	$result = mysqli_query($conn , $sql);
	// $stmt = $conn->prepare($sql);
	// $stmt->execute();
	$sql = "select @verification_request as vr , @change_request as cr";
	$result = mysqli_query($conn , $sql);
	if (mysqli_num_rows($result) > 0) {
		$row = mysqli_fetch_assoc($result);
	}
	$conn->close();
	echo json_encode($row);
	// $i = 0;
// echo json_encode(var_dump($row));
}
else{
	echo $d2->purpose;
	echo $d2->email;
}