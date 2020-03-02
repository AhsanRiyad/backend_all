<?php 
include "../../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 

//echo 'in the model';


$conn = get_mysqli_connection();
//echo 'in the model';

$data =  file_get_contents('php://input');
$d1 = json_decode($data);


if( $d1->purpose == 'edit_product' ){

	//echo $d1->product_name;

	//echo 'in the mpdel';


	$conn = get_mysqli_connection();

	$p_id = mysqli_real_escape_string($conn ,  $d1->p_id);
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
	$who_is_adding = mysqli_real_escape_string($conn ,  $d1->who_is_adding);



	$sql = "update products set product_name = '".$d1->product_name."'  , warranty_days = ".$d1->warranty_days." ,  purchase_cost = ".$d1->purchase_cost."  , selling_price = ".$d1->selling_price." , alert_quantity = ".$d1->alert_quantity." , product_details = '".$d1->product_details."' , category_id = ".$d1->category_id." , brand_id = ".$d1->brand_id." , having_serial = ".$d1->having_serial."    where p_id = ".$d1->p_id."   ";

	$result = mysqli_query($conn, $sql);

	echo 'updated';


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
	
	$i = 0;
	$result = mysqli_query($conn, $sql);
	while($row = mysqli_fetch_assoc($result)){
		
		$arrayData['brand'][$i++] = $row;

	}

	$sql = "select max(product_code+1) as p_code from products";
	$result = mysqli_query($conn, $sql);
	$row = mysqli_fetch_assoc($result);
	$arrayData['product_code'] = $row['p_code'];


	$sql = "select concat('id: ',p.p_id, ' ', p.product_name , ' brand: ' ,b.brand_name) as product_name , p.p_id as p_id, p.brand_id from products p , brand b where p.brand_id = b.brand_id";
	$i = 0;
	$result = mysqli_query($conn, $sql);
	while($row = mysqli_fetch_assoc($result)){
		
		$arrayData['products'][$i++] = $row;

	}


// print_r($arrayData);
	$conn->close();
	echo json_encode($arrayData);

}
else if($d1->purpose == 'get_product_details'){


	$conn = get_mysqli_connection();
	$sql = "select * from category";
	$result = mysqli_query($conn, $sql);

	$arrayData;
	$i = 0;
	while($row = mysqli_fetch_assoc($result)){
		
		$arrayData['category'][$i++] = $row;

	}
	$sql = "select * from brand";
	
	$i = 0;
	$result = mysqli_query($conn, $sql);
	while($row = mysqli_fetch_assoc($result)){
		
		$arrayData['brand'][$i++] = $row;

	}

	$sql = "select max(product_code+1) as p_code from products";
	$result = mysqli_query($conn, $sql);
	$row = mysqli_fetch_assoc($result);
	$arrayData['product_code'] = $row['p_code'];


	$sql = "select concat(p.product_name , ' brand: ' ,b.brand_name) as product_name , p.brand_id from products p , brand b where p.brand_id = b.brand_id";
	$i = 0;
	$result = mysqli_query($conn, $sql);
	while($row = mysqli_fetch_assoc($result)){
		
		$arrayData['products'][$i++] = $row;

	}
	
	$sql = "select p.* , b.brand_name, c.category_name from products p , brand b , category c where p.brand_id = b.brand_id and p.category_id = c.category_id and p.p_id = ".$d1->p_id." ";
	$result = mysqli_query($conn, $sql);
	$row = mysqli_fetch_assoc($result);
	$arrayData['product_details'] = $row;


// print_r($arrayData);
	$conn->close();
	echo json_encode($arrayData);

}



?>