<?php 
include "../address.php";
include $APP_ROOT.'assets/linker/db.php' ; 


$pdo = get_PDO_connection();
        // calling stored procedure command
$sql = 'CALL PROC_TEST(?)';
        // prepare for execution of the stored procedure
$stmt = $pdo->prepare($sql);

$email = "riyad298@gmail.com";
        // pass value to the command
$stmt->bindParam(1, $email, PDO::PARAM_STR|PDO::PARAM_INPUT_OUTPUT, 100);

        // execute the stored procedure
$stmt->execute();
//$stmt->closeCursor();

$row = $pdo->query("SELECT @email AS level")->fetch(PDO::FETCH_ASSOC);
print_r($row);
        // execute the second query to get customer's level
print "  1: {$email}\n";





?>