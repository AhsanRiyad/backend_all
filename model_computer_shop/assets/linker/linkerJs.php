<?php 
$jsMain = $rootAdress."assets/js/main.js";
$jsJquery = $rootAdress.'assets/js/jquery-3.4.1.js';
$jsBootstrap = $rootAdress.'assets/js/bootstrap.js';
$jsBootstrap_bundle = $rootAdress.'assets/js/bootstrap.bundle.js';
$jquery_ui = $rootAdress.'assets/js/jquery-ui.js';
?>


<!-- bootstrap js cdn -->
   <!--  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script> -->

    <!--bootstrap js on server-->
    <script src=<?php echo $jsJquery ?> type="text/javascript"></script> 
    <script src=<?php echo $jsBootstrap; ?> type="text/javascript"></script>
    <script src=<?php echo $jsBootstrap_bundle; ?> type="text/javascript"></script>
    <script src=<?php echo $jquery_ui; ?> type="text/javascript"></script>
    
    
    <!-- font-awesome js cdn -->
    <script defer src="https://use.fontawesome.com/releases/v5.5.0/js/all.js" integrity="sha384-GqVMZRt5Gn7tB9D9q7ONtcp4gtHIUEW/yG7h98J7IpE3kpi+srfFyyB/04OV6pG0" crossorigin="anonymous"></script>
    
    <!--font-awesome on server-->
    <!-- <script src="font-awesome/js/all.js" type="text/javascript"></script> -->
    
    <!-- custome js -->



    <!-- vue  2.x-->
    <script src="https://cdn.jsdelivr.net/npm/vue@2.x/dist/vue.js"></script>
    <!-- vuetify 2.1.9 -->
    <script src="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.js"></script>
    <!-- vue resource version 1.5.1-->
    <script src="https://cdn.jsdelivr.net/npm/vue-resource@1.5.1"></script>
    <!-- axios version 0.19.0-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.19.0/axios.js" ></script>

    



    
    <script>



      Vue.mixin({
        data: function() {
            return {
                APP_ROOT: '<?= $APP_ROOT ?>' , 
                rootAdress: '<?= $rootAdress ?>',
                pageName: '<?php $pageName; ?>',
                images:{
                    logoSrc: '<?php echo $logoSrc; ?>',
                    fev_icon: '<?php echo $fev_icon; ?>',
                    profile_photo: '<?php echo $profile_photo; ?>',
                    default_photo: '<?php echo $default_photo; ?>',
                    

                },
                pages:{
                    reg_for_admin: '<?= $reg_for_admin ?>',
                    dashboard_head: '<?= $dashboard_head ?>',
                },
                address:{
                    registationPage:'<?php echo $registationPage ?>',
                    loginPage: '<?php echo $loginPage; ?>',
                    forgotPage: '<?php echo $forgotPage; ?>',
                    dashboardPage: '<?php echo $dashboardPage; ?>',
                    add_user: '<?php echo $add_user; ?>',
                    reg_req: '<?php echo $reg_req; ?>',
                    profilePage: '<?php echo $profilePage; ?>',



                    profile_basicPage: '<?php echo $profile_basicPage; ?>',
                    profile_personalPage: '<?php echo $profile_personalPage; ?>',
                    profile_addressPage: '<?php echo $profile_addressPage; ?>',
                    profile_change_passwordPage: '<?php echo $profile_change_passwordPage; ?>',
                    profile_change_emailPage: '<?php echo $profile_change_emailPage; ?>',
                    profile_photo_uploadPage: '<?php echo $profile_photo_uploadPage; ?>',
                    profile_verify_emailPage: '<?php echo $profile_verify_emailPage; ?>',
                    profile_password_recoveryPage: '<?php echo $profile_password_recoveryPage; ?>',
                    profile_forgot_passwordPage: '<?php echo $profile_forgot_passwordPage; ?>',




                    photo_galleryPage: '<?php echo $photo_galleryPage; ?>',
                    data_privacyPage: '<?php echo $data_privacyPage; ?>',
                    new_user_requestPage: '<?php echo $new_user_requestPage; ?>',
                    data_update_requestPage: '<?php echo $data_update_requestPage; ?>',






                    searchPage: '<?php echo $searchPage; ?>',

                },
                model:{
                    modelRegirstration: '<?php echo $modelRegirstration; ?>',
                    modelLogin: '<?php echo $modelLogin; ?>',
                    modelReg_req: '<?php echo $modelReg_req; ?>',
                    modeltest: '<?php echo $modeltest; ?>',
                    modelPrivacy: '<?php echo $modelPrivacy; ?>',
                    modelGallery: '<?php echo $modelGallery; ?>',
                    modelProfile_update: '<?php echo $modelProfile_update; ?>',


                    modelProfile_basic: '<?php echo $modelProfile_basic; ?>',
                    modelProfile_personal: '<?php echo $modelProfile_personal; ?>',
                    modelProfile_address: '<?php echo $modelProfile_address; ?>',
                    modelProfile_change_password: '<?php echo $modelProfile_change_password; ?>',
                    modelProfile_change_email: '<?php echo $modelProfile_change_email; ?>',
                    modelProfile_photo_upload: '<?php echo $modelProfile_photo_upload; ?>',
                    modelProfile_verify_email: '<?php echo $modelProfile_verify_email; ?>',
                    modelProfile_password_recovery: '<?php echo $modelProfile_password_recovery; ?>',
                    modelProfile_forgot_password: '<?php echo $modelProfile_forgot_password; ?>',



                    modelphoto_gallery: '<?php echo $modelphoto_gallery; ?>',
                    modeldata_privacy: '<?php echo $modeldata_privacy; ?>',
                    modelnew_user_request: '<?php echo $modelnew_user_request; ?>',
                    modeldata_update_request: '<?php echo $modeldata_update_request; ?>',
                    

                    modelcommon_request: '<?php echo $modelcommon_request; ?>',





                    modelSearch: '<?php echo $modelSearch; ?>',
                    modelAdminChangeInfo: '<?php echo $modelAdminChangeInfo; ?>',

                },
                directories:{
                    upload_img_directory: '<?php echo $upload_img_directory; ?>',
                    upload_recent_photo_directory: '<?php echo $upload_recent_photo_directory; ?>',
                    upload_group_photo_directory: '<?php echo $upload_group_photo_directory; ?>',
                    upload_old_photo_directory: '<?php echo $upload_old_photo_directory; ?>',
                },
                users_info__:{
                    email__: '<?= $email__ ?>',
                    id__: '<?= $id__  ?>' , 
                    login__: '<?= $login__ ?>',
                    user__: '<?= $user__ ?>',
                    admin__: '<?= $admin__ ?>',
                    verified__: '<?= $verified__ ?>',
                    name__: '<?= $name__ ?>',
                },
                greeting_text__: '',

            }
        },
        created(){
            this.pageName = '<?php echo $pageName ?>';


            if( this.pageName == 'profile_basic' ||
                this.pageName == 'profile_personal' ||
                this.pageName == 'profile_address' ||
                this.pageName == 'profile_photo_upload' ||
                this.pageName == 'profile_change_password' ||
                this.pageName == 'profile_change_email' ||
                this.pageName == 'profile_verify_email' ||
                this.pageName == 'profile_verify_email' ||
                this.pageName == 'add_user' ||
                this.pageName == 'photo_gallery' || 
                this.pageName == 'search' || 
                this.pageName == 'data_privacy' || 
                this.pageName == 'data_update_request' || 
                this.pageName == 'new_user_request'
                ){



                

                var date1 = new Date();
            var hourMin =  date1.getHours();

            var greeting_text__ =  document.getElementById('greeting_text__');

//alert(name);
if (hourMin >=5  && hourMin < 12)  {
    greeting_text__.innerHTML = 'Good Morning, '+this.users_info__.name__;
}

else if (hourMin >= 12 && hourMin < 17){

    greeting_text__.innerHTML = 'Good Afternoon, '+this.users_info__.name__;

}

else if (hourMin >= 17 && hourMin < 21){
    greeting_text__.innerHTML = 'Good Evening, '+this.users_info__.name__;
    
}

else if (hourMin >= 21 && hourMin < 24){


    greeting_text__.innerHTML = this.users_info__.name__+ ',its time to sleep ';
}

else if (hourMin >= 0 && hourMin < 5){
    $('#greetings').html(name+ " " +/*country*/" ,it's mid night now,  you should sleep");

    greeting_text__.innerHTML = this.users_info__.name__+ ",it's mid night now,  you should sleep"; 


}
else{
    //alert(hourMin);
    greeting_text__.innerHTML =  "Hellow , "+this.users_info__.name__; 

}

// console.log('inside response');
var verification_request_badge =  document.getElementById('verification_request_badge'); ;
var change_request_badge =  document.getElementById('change_request_badge');
axios.post( this.model.modelcommon_request ,
{
    purpose: 'number_of_request',

}
).then(function(response){
    // console.log(response.data.cr);

    change_request_badge.innerHTML = response.data.cr;
    verification_request_badge.innerHTML = response.data.vr;


}.bind(this))
.catch(function(error){

}.bind(this));









}else{


}












}



})





</script>









<?php 
include $APP_ROOT."assets/js/main.php";

    // vue_file
if($pageName == 'registration'){
    include $APP_ROOT."assets/js/vue_file/registration.php";
}
else if($pageName == 'login'){
    include $APP_ROOT."assets/js/vue_file/login.php";
}
else if($pageName == 'reg_req'){
    include $APP_ROOT."assets/js/vue_file/reg_req.php";
}
else if($pageName == 'add_user'){
    include $APP_ROOT."assets/js/vue_file/add_user.php";
}
else if($pageName == 'profile'){
    include $APP_ROOT."assets/js/vue_file/profile.php";
}






else if($pageName == 'profile_basic'){
    include $APP_ROOT."assets/js/vue_file/profile_basic.php";
}
else if($pageName == 'profile_personal'){
    include $APP_ROOT."assets/js/vue_file/profile_personal.php";
}
else if($pageName == 'profile_address'){
    include $APP_ROOT."assets/js/vue_file/profile_address.php";
}
else if($pageName == 'profile_change_password'){
    include $APP_ROOT."assets/js/vue_file/profile_change_password.php";
}
else if($pageName == 'profile_change_email'){
    include $APP_ROOT."assets/js/vue_file/profile_change_email.php";
}
else if($pageName == 'profile_photo_upload'){
    include $APP_ROOT."assets/js/vue_file/profile_photo_upload.php";
}else if($pageName == 'profile_verify_email'){
    include $APP_ROOT."assets/js/vue_file/profile_verify_email.php";
}else if($pageName == 'profile_password_recovery'){
    include $APP_ROOT."assets/js/vue_file/profile_password_recovery.php";
}else if($pageName == 'profile_forgot_password'){
    include $APP_ROOT."assets/js/vue_file/profile_forgot_password.php";
}



else if($pageName == 'photo_gallery'){
    include $APP_ROOT."assets/js/vue_file/photo_gallery.php";
}
else if($pageName == 'data_privacy'){
    include $APP_ROOT."assets/js/vue_file/data_privacy.php";
}
else if($pageName == 'new_user_request'){
    include $APP_ROOT."assets/js/vue_file/new_user_request.php";
}
else if($pageName == 'data_update_request'){
    include $APP_ROOT."assets/js/vue_file/data_update_request.php";
}






else if($pageName == 'privacy'){
    include $APP_ROOT."assets/js/vue_file/privacy.php";
}
else if($pageName == 'gallery'){
    include $APP_ROOT."assets/js/vue_file/gallery.php";
}
else if($pageName == 'forgot_password'){
    include $APP_ROOT."assets/js/vue_file/forgot.php";
}
else if($pageName == 'search'){
    include $APP_ROOT."assets/js/vue_file/search.php";
}
else if($pageName == 'add_user'){
    include $APP_ROOT."assets/js/vue_file/add_user.php";
}




?>

</body>
</html>