<?php 
include "../../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

//echo 'in the model';


//echo 'in the model';

$data =  file_get_contents('php://input');
$d1 = json_decode($data);



if($d1->purpose == 'add_brand'){


	$conn = get_mysqli_connection();


	$brand_name = mysqli_real_escape_string($conn ,  $d1->brand_name);
	$brand_details = mysqli_real_escape_string($conn ,  $d1->brand_details);    
	$who_is_adding = mysqli_real_escape_string($conn ,  $d1->who_is_adding);

	echo $brand_name;

	$sql = "select count(*) as st from brand where brand_name = '".$brand_name."' ";
	$result = mysqli_query($conn, $sql);

	$row = mysqli_fetch_assoc($result);
// echo $row['st'];

// echo $row['st'];
	if($row['st'] == 0){

		$sql = "INSERT INTO brand (brand_name , brand_description) VALUES ( '".$brand_name."' , '".$brand_details."' )";
		$result = mysqli_query($conn, $sql);
		echo 'successful';

	}else{
		echo 'duplicate brand_name';
	}

	$conn->close();


}else if($d1->purpose == 'get_brand_list'){

	$conn = get_mysqli_connection();
	$sql = "select * from brand";
	$result = mysqli_query($conn, $sql);
	$arrayBrand;
	$i = 0;
	while($row = mysqli_fetch_assoc($result)){

		$arrayBrand['brand_list'][$i++] = $row;

	}
	$conn->close();
	echo json_encode($arrayBrand);


}else if($d1->purpose == 'get_brand_details'){

	$conn = get_mysqli_connection();
	$sql = "select * from brand where brand_id =  ".$d1->brand_id." ";
	$result = mysqli_query($conn, $sql);
	$arrayBrand;
	$i = 0;
	$arrayBrand['brand_details'] = mysqli_fetch_assoc($result);
	$conn->close();
	echo json_encode($arrayBrand);

}



?>