<?php 




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


$vr__ = $row['vr'];
$cr__ = $row['cr'];




if($pageName == 'login' || $pageName == 'registration' || $pageName == 'profile_forgot_password' ){
	$_SESSION['users_info'] = null;
}

 
function dbGetUserDetails($email){
	$conn = get_mysqli_connection();
	$sql = 'select * from all_info_together where email = "'.$email.'" ';  
	$result = mysqli_query($conn, $sql);
	$row1 = mysqli_fetch_assoc($result);
	$_SESSION['users_info'] = $row1;	
	$conn->close();

}

if(isset($_SESSION['users_info'])){

	
	dbGetUserDetails($email__);

	$login__ = true;
	$photo__ = $_SESSION['users_info']['recent_photo'];


	if($photo__ != 'not_set'){
		$profile_photo = $rootAdress."assets/img/uploads/recent_photos/".$photo__;
	}
	
	if($_SESSION['users_info']['type'] =='user' ){
		/*if($pageName == 'add_user' || $pageName == 'reg_req' ){
		header('location:'.$not_authorisedPage);
			
	}*/

	$user__ = true;


	if($_SESSION['users_info']['status'] =='approved' ){

		$verified__ = true;
	}
	if($_SESSION['users_info']['email_verification_status'] =='verified' ){

		$email_verified__ = true;
	}

}else if($_SESSION['users_info']['type'] =='admin'){
	$admin__ = true;
}

}else{

	$login__ = false;
	$admin__ = false;
	$user__ = false;
	$verified__ = false;
	$email_verified__ = false;

	/*if($pageName != 'login' || $pageName != 'registration' || $pageName != 'forgot_password' ){
		header('location:'.$not_authorisedPage);
	}*/

}

if($login__ == true){

	if($user__ == true){

		if($verified__ == true ){

			if($pageName == 'new_user_request' || $pageName == 'add_user'  || $pageName == 'data_update_request'){	
				header('location:'.$profile_basicPage);
			}else if ($pageName == 'profile_verify_email') {
				header('location:'.$profile_basicPage);
			}

		}else{

			if($pageName == 'photo_gallery' || 
				$pageName == 'search' || 
				$pageName == 'data_privacy'){
				header('location:'.$profile_basicPage);
		}

	}

}else if($admin__ == true){

}


}else if($login__ == false){

	if(	$pageName == 'profile_basic' ||
		$pageName == 'profile_personal' ||
		$pageName == 'profile_address' ||
		$pageName == 'profile_photo_upload' ||
		$pageName == 'profile_change_password' ||
		$pageName == 'profile_change_email' ||
		$pageName == 'profile_verify_email' ||
		$pageName == 'profile_verify_email' ||
		$pageName == 'add_user' ||
		$pageName == 'photo_gallery' || 
		$pageName == 'search' || 
		$pageName == 'data_privacy' || 
		$pageName == 'data_update_request' || 
		$pageName == 'new_user_request' ){

		header('location:'.$loginPage);
}

}



?>