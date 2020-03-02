<?php 




use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

// Load Composer's autoloader
require $APP_ROOT.'vendor/autoload.php';


$mail = new PHPMailer();
$mail ->IsSmtp();
$mail ->SMTPDebug = 0;
$mail ->SMTPAuth = true;
$mail ->SMTPSecure = 'ssl';
$mail ->Host = "a2plcpnl0365.prod.iad2.secureserver.net";
$mail ->Port = 465; // or 587
$mail ->IsHTML(true);
$mail ->Username = "registration@ndc92.cyberideaz.com";
$mail ->Password = "ndc92";
$mail ->SetFrom("registration@ndc92.cyberideaz.com");








 ?>