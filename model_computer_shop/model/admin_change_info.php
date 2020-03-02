<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 


$data =  file_get_contents('php://input');
$d2 = json_decode($data);

$sql = '';
$conn = get_mysqli_connection();
$purpose = $d2->purpose;
$email = $d2->email;
$user_id = $d2->user_id;
$value = $d2->value;


if($purpose != 'email'){


	if($purpose == 'full_name')
	{
		$sql = "update all_info_together set full_name = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'mobile')
	{
		$sql = "update all_info_together set mobile = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'institution_id')
	{
		$sql = "update all_info_together set institution_id = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'nid_or_passport')
	{
		$sql = "update all_info_together set nid_or_passport = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'fathers_name')
	{
		$sql = "update all_info_together set fathers_name = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'mother_name')
	{
		$sql = "update all_info_together set mother_name = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'spouse_name')
	{
		$sql = "update all_info_together set spouse_name = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'number_of_children')
	{
		$sql = "update all_info_together set number_of_children = ".$value." where id = ".$user_id." ";	
	}else if($purpose == 'profession')
	{
		$sql = "update all_info_together set profession = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'designation')
	{
		$sql = "update all_info_together set designation = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'institution')
	{
		$sql = "update all_info_together set institution = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'workplace_or_institution')
	{
		$sql = "update all_info_together set workplace_or_institution = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'blood_group')
	{
		$sql = "update all_info_together set blood_group = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'date_of_birth')
	{
		$sql = "update all_info_together set date_of_birth = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'present_line1')
	{
		$sql = "update all_info_together set present_line1 = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'present_district')
	{
		$sql = "update all_info_together set present_district = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'present_post_code')
	{
		$sql = "update all_info_together set present_post_code = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'present_country')
	{
		$sql = "update all_info_together set present_country = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'parmanent_line1')
	{
		$sql = "update all_info_together set parmanent_line1 = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'parmanent_district')
	{
		$sql = "update all_info_together set parmanent_district = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'parmanent_post_code')
	{
		$sql = "update all_info_together set parmanent_post_code = '".$value."' where id = ".$user_id." ";	
	}else if($purpose == 'parmanent_country')
	{
		$sql = "update all_info_together set parmanent_country = '".$value."' where id = ".$user_id." ";	
	}

	mysqli_query($conn , $sql);
	echo 'success';


}else if($purpose == 'email'){
	$sql = "call update_profile_email( ".$user_id." , '".$email."' , '".$value."' , 'change_email_for_admin' , @result )";


	mysqli_query($conn , $sql);
	$sql = "select @result as rs";
	$result = mysqli_query($conn, $sql);
	if (mysqli_num_rows($result) > 0) {
		$row = mysqli_fetch_assoc($result);

		echo $row['rs'];
	}




}