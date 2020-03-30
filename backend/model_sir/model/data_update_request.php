<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 
header("Content-Type: application/json; charset=UTF-8");
$data =  file_get_contents('php://input');
$d2 = json_decode($data);




if($d2->purpose=='get_change_req_user'){
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
	$sql = "select `first_name` , `last_name` ,`mobile`, `institution_id`,`nid_or_passport`, `fathers_name`, `mother_name`, `spouse_name`, `number_of_children`, `profession`, `designation`, `institution`, `blood_group`, `religion` ,`date_of_birth`, `present_line1`, `present_district`, `present_police_station` ,`present_post_code`,`present_post_office_name`, `present_country`, `parmanent_line1`, `parmanent_police_station` ,`parmanent_district`, `parmanent_post_code`,`parmanent_post_office_name`, `parmanent_country`,`second_citizenship_country`  from all_info_together where  id =".$user_id." ";

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
	// print_r($array);
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


}else if($d2->purpose == 'getProfileBasicInfo'){


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




}else if($d2->purpose=='approve_user_change_request'){

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

}else if($d2->purpose=='reject_user_user_request'){

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

$arrayKey_from_database = $stringToArrayValue_from_verified_info = explode(',' , $array[0] );


// print_r($arrayKey_from_database);
// echo '<br>';
// print_r($arrayValue_from_database);



$update_sql_users_registration = "update users_registration set `first_name`='".$arrayValue_from_database[0]."', `last_name`='".$arrayValue_from_database[1]."', ,`mobile`='".$arrayValue_from_database[2]."', `institution_id`='".$arrayValue_from_database[3]."'  where  email = '".$email."'";
mysqli_query($conn , $update_sql_users_registration);



if($arrayValue_from_database[7] == NULL || $arrayValue_from_database[7] == ''){
	$arrayValue_from_database[7] = 0;
}



$update_sql_users_info = "update users_info set `nid_or_passport`='".$arrayValue_from_database[4]."', `fathers_name`='".$arrayValue_from_database[5]."', `mother_name`='".$arrayValue_from_database[6]."', `spouse_name`='".$arrayValue_from_database[7]."', `number_of_children`=".$arrayValue_from_database[8].", `profession`='".$arrayValue_from_database[9]."', `designation`='".$arrayValue_from_database[10]."', `institution`='".$arrayValue_from_database[11]."', `blood_group`='".$arrayValue_from_database[12]."', `religion`='".$arrayValue_from_database[12]."'  where  email = '".$email."'";
mysqli_query($conn , $update_sql_users_info);



if($arrayValue_from_database[15] == NULL or $arrayValue_from_database[15] == ''){
	$arrayValue_from_database[15] = 0000;
}
if($arrayValue_from_database[19] == NULL or $arrayValue_from_database[19] == ''){
	$arrayValue_from_database[19] = 0000;
}





$update_sql_users_address = "update users_address set `date_of_birth`='".$arrayValue_from_database[13]."', `present_line1`='".$arrayValue_from_database[14]."', `present_district`='".$arrayValue_from_database[15]."', `present_police_station`='".$arrayValue_from_database[16]."', `present_post_code`='".$arrayValue_from_database[17]."',  `present_post_office_name`='".$arrayValue_from_database[18]."', `present_country`='".$arrayValue_from_database[19]."', `parmanent_line1`='".$arrayValue_from_database[20]."', `parmanent_police_station`='".$arrayValue_from_database[21]."', `parmanent_district`='".$arrayValue_from_database[22]."', `parmanent_post_code`='".$arrayValue_from_database[23]."', `parmanent_post_office_name`='".$arrayValue_from_database[24]."' , `parmanent_country`='".$arrayValue_from_database[25]."'  , `second_citizenship_country`='".$arrayValue_from_database[26]."'  where  email = '".$email."'";
mysqli_query($conn , $update_sql_users_address);


$update_rejected_sql = "update all_info_together set change_request = 'rejected' where id = ".$user_id."";
mysqli_query($conn , $update_rejected_sql);
$conn->close();



	
}