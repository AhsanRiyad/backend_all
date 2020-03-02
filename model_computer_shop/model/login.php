<?php 

include "../address.php";

include $APP_ROOT.'assets/linker/db.php' ; 



$data =  file_get_contents('php://input');

$d1 = json_decode($data);


/*if (hash_equals($_SESSION['csrf_token1'], $email = $d1->csrf_token1)) {

*/


    $conn = get_mysqli_connection();
    $password1 = md5($d1->password);
    $email = mysqli_real_escape_string($conn ,  $d1->email);

    $sql = "CALL login( '".$email."', '".$password1."', @result)";
    $result = mysqli_query($conn, $sql);
    
    
    $sql = 'select @result as st'; 
    $result = mysqli_query($conn, $sql);
    $row = mysqli_fetch_assoc($result);

    

    if($row['st'] == 'YES_USER' || $row['st'] == 'YES_ADMIN'){
        $_SESSION['email'] =  $email;
        

        $sql = 'select * from all_info_together where email ='.'"'.$email.'"';  
        $result = mysqli_query($conn, $sql);
        $row1 = mysqli_fetch_assoc($result);
        $_SESSION['users_info'] = $row1;

        // format
        // echo $_SESSION['users_info']['email'];

    }

//print_r($row);
    $conn->close();
    echo $row['st'];


/*}else{
    echo 'you are not authorized';
}
*/


?>