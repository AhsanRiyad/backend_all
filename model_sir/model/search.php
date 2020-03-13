<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

//echo 'get data';

// header('Content-Type: application/json');

$data =  file_get_contents('php://input');
$d2 = json_decode($data);

// $id__ = 1;

if($d2->main_purpose == 'search'){
	$sql = 'select * from all_info_together limit 20';
	$name = $d2->search_text;
	$conn = get_mysqli_connection();
	$name1 =  mysqli_real_escape_string($conn , $name);


	if($d2->purpose == 'Full Name'){

		if($name == ''){
			$sql =" select * from all_info_together where status = 'approved' limit 20";
		}else{
			$sql = "select * from all_info_together where status = 'approved' and  full_name  like '%$name%'  limit 20 ";
		}
	}else if($d2->purpose == 'Membership Number'){

		if($name == ''){
			$sql =" select * from all_info_together where status = 'approved' limit 20";
		}else{
			$sql = "select * from all_info_together where  status = 'approved' and membership_number  like '%$name%' limit 20 ";
		}


		

	}else if($d2->purpose == 'Institution ID' || $d2->purpose == 'School ID'  || $d2->purpose == 'College ID'  || $d2->purpose == 'School Roll'  || $d2->purpose == 'College Roll'  || $d2->purpose == 'University Roll' ){

		if($name == ''){
			$sql =" select * from all_info_together where status = 'approved' limit 20";
		}else{
			$sql = "select * from all_info_together where status = 'approved' and  institution_id  like '%$name%' limit 20 ";
		}



		
	}
	else if($d2->purpose == 'Rejected User'){

		if($name == ''){
			$sql =" select * from all_info_together where status = 'rejected' limit 20";
		}else{
			
		$sql = "select * from all_info_together where status = 'rejected' and  full_name  like '%$name%' limit 20 ";
		}


	}

	else if($d2->purpose == 'Newly Registered'){

		if($name == ''){
			$sql =" select * from all_info_together where status = 'not_verified' limit 20";
		}else{
			
		
		$sql = "select * from all_info_together where status = 'not_verified' and  full_name  like '%$name%' limit 20 ";
		}
		
		
	}




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

}else if($d2->main_purpose == 'search_other_option'){


	if($d2->purpose=='reject_user'){
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
	}else if($d2->purpose == 'get_profile_details_for_all'){

		$email = $d2->email;
		$user_id = $d2->user_id;
		echo getPrivacyData($email , $user_id);


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




	}else if($d2->purpose == 'getProfileBasicInfo'){

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



}














function getPrivacyData($email , $user_id){
	$conn = get_mysqli_connection();

	$user_id_fresh = mysqli_real_escape_string($conn, $user_id);
	$email_fresh = mysqli_real_escape_string($conn, $email);

	$sql = 'select * from all_info_together where id ='.$user_id_fresh;
					//echo $sql;
	$result = mysqli_query($conn , $sql);
	$row_verification_info = mysqli_fetch_assoc($result);
				//echo $row_verification_info['visibility'];
	$arrayE =  explode('<@#$>', $row_verification_info['visibility']);
				//print_r($arrayE);

				//echo '<br>';
					//$hello = 'select ui.email'

					// select ua.parmanent_district , ua.parmanent_country , ua.present_district , ua.present_country ,  ui.email , ui.nid_or_passport, ui.fathers_name , ui.mother_name , ui.spouse_name , ui.number_of_children , ui.profession , ui.designation , ui.institution , ui.blood_group , ui.date_of_birth , ur.mobile , ur.institution_id , ur.registration_date from users_info ui , users_registration ur , users_address ua WHERE ui.email  = ur.email = ua.email and ur.email = "riyad298@gmail.com"


	$sql ='select CONCAT(first_name, " " , last_name) as full_name,`mobile`, `institution_id`,`nid_or_passport`, `fathers_name`, `mother_name`, `spouse_name`, `number_of_children`, `profession`, `designation`, `institution`, `blood_group`, `religion` ,`date_of_birth`, `present_line1`, `present_district`, `present_police_station` ,`present_post_code`,`present_post_office_name`, `present_country`, `parmanent_line1`, `parmanent_police_station` ,`parmanent_district`, `parmanent_post_code`,`parmanent_post_office_name`, `parmanent_country`,`second_citizenship_country`  from all_info_together  id = '.$user_id_fresh;
	$result = mysqli_query($conn , $sql);
	$row_users_registration = mysqli_fetch_assoc($result);


				//print_r($row_users_registration);
	$privacyArray;
	$arrayInfo;
	$i = 0;
	foreach ($arrayE as $key => $value) {



		$arrayInfo[$value] = $row_users_registration[$value];
					//echo $x;
	}
				//echo '<br>' ; 
	foreach ($row_users_registration as $key => $value) {
					# code...
					//echo $value;
		in_array($key, $arrayE) ? $privacyArray[$i++]= array($key , $value , 'public') : $privacyArray[$i++]= array($key , $value , 'private');
					//echo $key .'<br>'. $value;
	}
				// echo json_encode($arrayInfo);
	echo json_encode($privacyArray);
	$conn->close();
}