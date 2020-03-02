<?php 
include "../../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

//echo 'in the model';


//echo 'in the model';

$data =  file_get_contents('php://input');
$d1 = json_decode($data);

if($d1->purpose == 'add_people'){

	$conn = get_mysqli_connection();
	$full_name = mysqli_real_escape_string($conn ,  $d1->full_name);
	$company_name = mysqli_real_escape_string($conn ,  $d1->company_name);    
	$mobile = mysqli_real_escape_string($conn ,  $d1->mobile);
	$email = mysqli_real_escape_string($conn ,  $d1->email);
	$post_code = mysqli_real_escape_string($conn ,  $d1->post_code);
	$address = mysqli_real_escape_string($conn ,  $d1->address);
	$type = mysqli_real_escape_string($conn ,  $d1->type);
	$who_is_adding = mysqli_real_escape_string($conn ,  $d1->who_is_adding);


	$variables = " 
	'".$company_name."',
	'".$full_name."', 
	'".$email."',
	'".$mobile."',
	'".$post_code."',
	'".$address."',
	'".$type."' ,
	'".$who_is_adding."'
	" ;

//echo $variables;

	$var2 = "
	'".$mobile."',
	'".$type."',
	@result
	";




	$sql = "CALL add_people($var2)";
	$result = mysqli_query($conn, $sql);


	$sql = 'select @result as st'; 
	$result = mysqli_query($conn, $sql);
	$row = mysqli_fetch_assoc($result);
// echo $row['st'];


	if($row['st'] !=  'yes'){

		$sql = "INSERT INTO people ( full_name , company_name , mobile , email , post_code , address , type , who_is_adding ) VALUES ( '".$full_name."' , '".$company_name."' , '".$mobile."', '".$email."', '".$post_code."', '".$address."', '".$type."', '".$who_is_adding."' )";


		$result = mysqli_query($conn, $sql);

		echo 'successful';

	}else{
		echo 'duplicate number';
	}

	$conn->close();

}





}

?>