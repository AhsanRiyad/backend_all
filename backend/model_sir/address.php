<?php 
//define('$rootAdress', "$_SERVER[DOCUMENT_ROOT]/project_for_Arif_sir/");

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);


session_start();

$APP_ROOT = $_SERVER['DOCUMENT_ROOT']."/backend_all/model_sir/";

$rootAdress = 'http://localhost/backend_all/model_sir/';
$rootAdressDomain = 'http://localhost:8080/';




// $APP_ROOT = $_SERVER['DOCUMENT_ROOT']."/";

// $rootAdress = 'http://mdahsanr.sgedu.site/';


// $rootAdress = 'http://ndc92.cyberideaz.com/';

//hosting
//$rootAdress = 'http://ndc92.friendsbd.website/';
/*

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');

*/


cors() ;

function cors() {

    // Allow from any origin
    if (isset($_SERVER['HTTP_ORIGIN'])) {
        // Decide if the origin in $_SERVER['HTTP_ORIGIN'] is one
        // you want to allow, and if so:
        header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
        header('Access-Control-Allow-Credentials: true');
        header('Access-Control-Max-Age: 86400');    // cache for 1 day
    }

    // Access-Control headers are received during OPTIONS requests
    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {

        if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
            // may also be using PUT, PATCH, HEAD etc
            header("Access-Control-Allow-Methods: GET, POST, OPTIONS");         

        if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
            header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");

        exit(0);
    }

    
}


/*header("Access-Control-Allow-Origin: *");*/


// assets
$bootstrap_grid = $rootAdress."assets/css/bootstrap-grid.css" ; 
$bootstrap_reboot = $rootAdress."assets/css/bootstrap-reboot.css" ; 
$bootstrap = $rootAdress."assets/css/bootstrap.css" ; 
$jquery_ui_structure = $rootAdress."assets/css/jquery-ui.structure.css" ; 
$jquery_ui_theme = $rootAdress."assets/css/jquery-ui.theme.css" ; 
$style = $rootAdress."assets/css/style.php" ; 



// images
$logoSrc = $rootAdress."assets/img/logo.jpg";
$fev_icon = $rootAdress."assets/img/fev_icon.jpg";
$profile_photo = $rootAdress."assets/img/uploads/default.jpg";
$default_photo = $rootAdress."assets/img/uploads/default.jpg";


// pages
$reg_for_admin = $APP_ROOT.'pages/reg_for_admin.php';
$dashboard_head = $APP_ROOT.'pages/dashboard_head.php';
$dashboard_foot = $APP_ROOT.'pages/dashboard_foot.php';
$linkerCss = $APP_ROOT.'assets/linker/linkerCss.php';
$linkerJs = $APP_ROOT.'assets/linker/linkerJs.php';
$db = $APP_ROOT.'assets/linker/db.php' ; 



// address
$registationPage =  $rootAdress."pages/registration.php" ;
$loginPage = $rootAdress.'pages/login.php';
$forgotPage = $rootAdress.'pages/forgot.php';
$dashboardPage = $rootAdress.'pages/add_user.php';
$add_user = $rootAdress.'pages/add_user.php';
$reg_req = $rootAdress.'pages/reg_req.php';
$profilePage = $rootAdress.'pages/profile.php?pn=basic';




$profile_basicPage = $rootAdress.'pages/profile_basic.php';
$profile_personalPage = $rootAdress.'pages/profile_personal.php';
$profile_addressPage = $rootAdress.'pages/profile_address.php';
$profile_change_passwordPage = $rootAdress.'pages/profile_change_password.php';
$profile_change_emailPage = $rootAdress.'pages/profile_change_email.php';
$profile_photo_uploadPage = $rootAdress.'pages/profile_photo_upload.php';
$profile_verify_emailPage = $rootAdress.'pages/profile_verify_email.php';
$profile_password_recoveryPage = $rootAdress.'pages/profile_password_recovery.php';
$profile_forgot_passwordPage = $rootAdress.'pages/profile_forgot_password.php';




$photo_galleryPage = $rootAdress.'pages/photo_gallery.php';
$data_privacyPage = $rootAdress.'pages/data_privacy.php';
$new_user_requestPage = $rootAdress.'pages/new_user_request.php';
$data_update_requestPage = $rootAdress.'pages/data_update_request.php';



$privacyPage = $rootAdress.'pages/privacy.php';
$galleryPage = $rootAdress.'pages/gallery.php';
$searchPage = $rootAdress.'pages/search.php';
$not_authorisedPage = $rootAdress.'pages/not_authorised.php';








//model
$modelRegirstration = $rootAdress."model/registration.php" ; 
$modelLogin = $rootAdress."model/login.php" ; 
$modelReg_req = $rootAdress."model/reg_req.php" ; 
$modeltest = $rootAdress."model/test.php" ; 
$modelUploadPhotos = $rootAdress."model/upload_photos.php";
$modelPrivacy = $rootAdress."model/privacy.php";
$modelGallery = $rootAdress."model/gallery.php";
$modelProfile_update = $rootAdress."model/profile_update.php";







$modelProfile_basic = $rootAdress."model/profile_basic.php";
$modelProfile_personal = $rootAdress."model/profile_personal.php";
$modelProfile_address = $rootAdress."model/profile_address.php";
$modelProfile_change_password = $rootAdress."model/profile_change_password.php";
$modelProfile_change_email = $rootAdress."model/profile_change_email.php";
$modelProfile_photo_upload = $rootAdress."model/profile_photo_upload.php";
$modelProfile_verify_email = $rootAdress."model/profile_verify_email.php";
$modelProfile_password_recovery = $rootAdress."model/profile_password_recovery.php";
$modelProfile_forgot_password = $rootAdress."model/profile_forgot_password.php";




$modelphoto_gallery = $rootAdress."model/photo_gallery.php";
$modeldata_privacy = $rootAdress."model/data_privacy.php";
$modelnew_user_request = $rootAdress."model/new_user_request.php";
$modeldata_update_request = $rootAdress."model/data_update_request.php";



$modelcommon_request = $rootAdress."model/common_request.php";






$modelSearch = $rootAdress."model/search.php";
$modelAdminChangeInfo = $rootAdress."model/admin_change_info.php";




//directories
$upload_img_directory = $rootAdress."assets/img/uploads/";
$upload_group_photo_directory = $rootAdress."assets/img/uploads/group_photos/";
$upload_recent_photo_directory = $rootAdress."assets/img/uploads/recent_photos/";
$upload_old_photo_directory = $rootAdress."assets/img/uploads/old_photos/";




// database
$hostName = 'localhost';
$userName = 'root';
$password = '';
$databaseName = 'intern_project';


// database hosting
// $hostName = '127.0.0.1';
// $userName = 'frieomkc_riyad';
// $password = '01919448787';
// $databaseName = 'frieomkc_intern_project';

// database hosting
// $hostName = '127.0.0.1';
// $userName = 'ndc92';
// $password = 'ndc92';
// $databaseName = 'ndc92';



// $hostName = 'localhost';
// $userName = 'mdahsanr_riyad';
// $password = '01919448787';
// $databaseName = 'mdahsanr_intern_project';

//CSRF_TOKEN token securty session
//$_SESSION['csrf_token1'] = bin2hex(random_bytes(32));



//session email
$session_info = $APP_ROOT.'assets/linker/session_info.php';
$admin__ = false;
$user__ = false;
$verified__ = false;
$email_verified__ = false;
$login__ = false;
$id__ = '';
$email__='';
$name__ = '';
$cr__ = 0;
$vr__ = 0;



if(isset($_SESSION['users_info'])){
	$email__ = $_SESSION['users_info']['email'];
	$id__ = $_SESSION['users_info']['id'];
	$name__ = $_SESSION['users_info']['full_name'];
}


?>
