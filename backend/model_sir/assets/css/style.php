
<style>

    label {
       color: #428df5;
       font-size: 20px;
       font-weight: bolder;
   }


   .dashboard_backgorund_color{
    background-color: #d3d3d3;
}

.dashboard_vertical_menu_height{
	
	background-color: #343a40;
    min-height: 100vh;
}


/*login page*/
._background{
	height: 100vh;
	background-color:  #d3d3d3 ;
}


/*main margin*/
.margin_{
	margin-top: 2%;
}



/*login page*/
/*registration page*/
.reg_background{
	
	background-color:  #d3d3d3 ;
    height: 100vh;
}

/*registration page*/




/*forgot passwor page*/


/*forgot passwor page*/




.no-padding {
	padding-left: 0;
	padding-right: 0;
}









/*dashboard starts*/



/*css variable function*/
:root{
    color_info:#51A5D0;

}

#autosearch {
    z-index: 99999; /* adjust this value */
}


/*mouse clickable*/
a[href], input[type='submit'], input[type='image'], label[for], select, button, .pointer {
 cursor: pointer;
} 

/*registration page msg show*/
.new_class {
    color: white;
    background: green;
}

a:hover{
    text-decoration: none;
}

/*main body styles*/
body{
	font-family: 'PT Sans', sans-serif;

} 

/*bootstrap testing starts*/
.yes{
    width: 200px;
    height: 200px;
}
/*bootstrap testing ends*/


/*contact starts*/
.p_style{
	color:red;
	margin-top: 10px;
	font-style: italic;
	font-size: 20px;
}
/*contact ends*/


/*category details starts*/
.catergory_color{
	color: var(color_info);
}
/*category details ends*/

/*admin page starts*/
.admin_navbar_veritcal{

    /*height: 100vh;*/
    /* z-index: 1001;
    top: 0;
    left:0; */


}

.admin_navbar_horizontal{

    /*position: relative;*/
    /*width: calc(100vw - 250px);*/
    color: white;
/* z-index: 1000;
top:0;
left:250px; */
height: 59px;


}

.admin_margin{



}


/*admin page ends*/





/*index starts*/

/*carousel container background color*/
.admin_background{
	background-color: lightgrey;
}






/*for index page*/
.image_div {
    position: relative;
    width: 12.5%;
    max-width: 12.5%;
    float: left;
    color: white;
    overflow: hidden;
    border: 1px solid lightgrey;
    transition: all .5s ease;
    background-color: white;

}


.image_div:hover {
    box-shadow: 0 0 10px #888888;
    overflow: visible;
    transform:  scale3d(1.03,1.03,1.03);
    z-index: 200;
    border: none;
    cursor: pointer;
}

.imageOverlay2 {
    opacity: 1;
    width: 100%;
    height: auto;
    transition: .5s ease;
    backface-visibility: hidden;
}


/*used for product box div*/
.w_p{
    width: 99%;
    max-width: 99%;
    height: auto;
    transition: all 1s ease;
}
.w_p:hover{
    box-shadow: 0 0 10px #888888;
    overflow: visible;
    transform:  scale3d(1.01,1.01,1.01);
    z-index: 200;
    border: none;
    cursor: pointer;
}







@media only screen and (max-width: 768px) {

    /*index page media query starts*/
    .image_div {
        position: relative;
        width: 25%;
        max-width: 25%;
        float: left;
        color: white;
        overflow: hidden;
        border: 1px solid lightgrey;
        transition: all .5s ease;
        background-color: white;

    }



    .reg_background{

        background-color:  #d3d3d3 ;
        height: 800px ;
        margin-top: 10px;
    }

    /*index page media query starts*/

}



@media only screen and (min-width: 768px) and (max-width: 1200px) {
    .reg_background{

        background-color:  #d3d3d3 ;
        height: 900px ;
        margin-top: 10px;
    }

    

}


/*dash board*/
.box1{
    height: 150px;
    width: 110px;
}

.box2{
    height: 75px;
    width: 110px;
    
}





/*admin profile update page starts*/
.small_button{

    color: white;
    float: right;
    background: red;
    padding:1px 5px;
}
.small_button:hover{


    cursor: pointer;
}

/*admin profile update page ends*/

/*view add product css */
.classFormAddProductBySeller{
 /*margin-top:200px;*/
}





.top-margin{
    margin-top: 0px;
}








/*dashboard ends*/
















@media only screen and (max-width: 768px) {

    /*login page*/
    /*main margin*/
    .margin_{
       /*margin-top: 5%;*/
   }
   /*login page*/


}
</style >