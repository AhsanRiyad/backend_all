<?php 
include "../../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

//echo 'in the model';


$conn = get_mysqli_connection();
//echo 'in the model';

$data =  file_get_contents('php://input');
$d1 = json_decode($data);


if( $d1->purpose == 'add_product' ){

	$product_name = mysqli_real_escape_string($conn ,  $d1->product_name);
	$warranty_days = mysqli_real_escape_string($conn ,  $d1->warranty_days);    
	$purchase_cost = mysqli_real_escape_string($conn ,  $d1->purchase_cost);
	$selling_price = mysqli_real_escape_string($conn ,  $d1->selling_price);
	$alert_quantity = mysqli_real_escape_string($conn ,  $d1->alert_quantity);
	$product_details = mysqli_real_escape_string($conn ,  $d1->product_details);
	$category_id = mysqli_real_escape_string($conn ,  $d1->category_id);
	$product_unit = mysqli_real_escape_string($conn ,  $d1->product_unit);
	$brand_id = mysqli_real_escape_string($conn ,  $d1->brand_id);
	$having_serial = mysqli_real_escape_string($conn ,  $d1->having_serial);
	$product_code = mysqli_real_escape_string($conn ,  $d1->product_code);
	$who_is_adding = mysqli_real_escape_string($conn ,  $d1->who_is_adding);



	$sql = "select count(*) as c from products where product_name = '".$product_name."' and brand_id = ".$brand_id." ";
	$result = mysqli_query($conn, $sql);

	$row = mysqli_fetch_assoc($result);
	// echo $row['c'];


	if($row['c'] == '0'){

		$sql = "INSERT INTO products ( 
		product_name ,
		warranty_days ,
		purchase_cost ,
		selling_price ,
		alert_quantity ,
		product_details ,
		category_id , 
		product_unit , 
		brand_id , 
		having_serial,
		product_code,
		who_is_adding ) VALUES ( 
		'".$product_name."' ,
		".$warranty_days." ,
		".$purchase_cost.", 
		".$selling_price.",
		".$alert_quantity.", 
		'".$product_details."',
		".$category_id.",
		'".$product_unit."',
		".$brand_id.",
		".$having_serial." ,
		".$product_code." ,
		'".$who_is_adding."' )";
		echo $sql;

		$result = mysqli_query($conn, $sql);

		echo 'successful';

	}else{
		echo 'duplicate product';
	}

	$conn->close();

}else if($d1->purpose == 'get_category_and_brand'){



	$conn = get_mysqli_connection();
	$sql = "select * from category";
	$result = mysqli_query($conn, $sql);

	$arrayData;
	$i = 0;
	while($row = mysqli_fetch_assoc($result)){
		
		$arrayData['category'][$i++] = $row;

	}
	$sql = "select * from brand";
	$arrayData;
	$i = 0;
	$result = mysqli_query($conn, $sql);
	while($row = mysqli_fetch_assoc($result)){
		
		$arrayData['brand'][$i++] = $row;

	}

	$sql = "select max(product_code+1) as p_code from products";
	$result = mysqli_query($conn, $sql);
	$row = mysqli_fetch_assoc($result);
	$arrayData['product_code'] = $row['p_code'];



// print_r($arrayData);
	$conn->close();
	echo json_encode($arrayData);

}



?>