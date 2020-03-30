<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 


$data =  file_get_contents('php://input');
$d2 = json_decode($data);

$sql = '';
$conn = get_mysqli_connection();
$purpose = $d2->purpose;



if($purpose == 'change_institution_id_label'){

	$sql = "UPDATE admin_options SET institution_id_label= '".$d2->institution_id_label."'  WHERE admin_options_id = 1";

	try {
		if (!mysqli_query($conn , $sql)) {
			throw new Exception('Data Server Problem');
		}else{
			echo 'success';
		}

	} catch (Exception $e) {
		echo 'Caught exception: ',  $e->getMessage(), "\n";
	}

}else if($purpose == 'get_institution_id_label'){

	$sql = "SELECT institution_id_label FROM admin_options WHERE admin_options_id = 1 ";

	$result = mysqli_query($conn , $sql);

	if (mysqli_num_rows($result) > 0) {
		$row = mysqli_fetch_assoc($result);
	}

	echo $row['institution_id_label'];

}else if($purpose == 'get_form_field_rules'){
	$conn = get_mysqli_connection();

	$sql = "SELECT * FROM form_fields_rule";

	$result = mysqli_query($conn , $sql);

	if (mysqli_num_rows($result) > 0) {
	// $row = mysqli_fetch_assoc($result);

		$i = 0;
		$arrryData ;
		while($row = mysqli_fetch_assoc($result)){
		// print_r($row);
			$arrayData[$i] = $row;
			$i++;
		}
	//print_r($arrayData);
		echo json_encode($arrayData);
	}
	$conn->close();

}else if($purpose == 'set_form_field_rules'){
	//echo 'ind the model';
	$conn = get_mysqli_connection();
	$rule;
	$d2->rule == true ? $rule = 'mandatory' : $rule = 'optional' ;
	$sql = "update form_fields_rule set rule = '".$rule."' where field_name = 	'".$d2->field_name."' ";

	echo $sql;
	$result = mysqli_query($conn , $sql);

	$conn->close();

}