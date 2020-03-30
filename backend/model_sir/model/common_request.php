<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 
// header("Content-Type: application/json; charset=UTF-8");
//print_r(json_encode($_REQUEST));
//print_r($_REQUEST['title']);
$data =  file_get_contents('php://input');
$d2 = json_decode($data);
//echo $d2->purpose;


if($d2->purpose == 'number_of_request'){
	
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