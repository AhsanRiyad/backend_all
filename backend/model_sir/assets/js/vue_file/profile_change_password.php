
<script>


	var password = `<div class="container-fluid bg-light mt-5 ">
	<div class="row justify-content-center align-items-center">
	<!-- update top part starts-->
	<div class="  col-12 col-xl-4 col-md-7  px-0 py-1" style="box-shadow: 0 0 10px lightgrey; ">
	<div class="row bg-white mx-1">
	<div class="col-3 mr-0 pr-0 my-2">
	<img class="rounded img-thumbnail img-fluid" v-bind:src="recent_photo" alt="">
	<div class="w-100"></div>
	</div>
	<div class="col-9  ml-0">
	<p class="h3 ">
	</p>
	<p class="h4 ">Profile <span class="font-weight-bold"></span></p>
	</div>
	</div>
	<!-- update top part ends-->
	<!-- update field part starts -->
	<div class="row bg-white mt-4 justify-content-center mx-1">
	<div class="w-100 bg-info">
	<p class="h3 text-white pl-4 pt-2"> <i class="fas fa-info-circle mr-0"></i> Change Password</p>
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class="" v-bind:style=' changes.password.smallText ' > <span>New Password 
	<span v-show="password_validity == 'valid'" class="text-success"> {{ password_validity }} </span>
	<span v-show="password_validity == 'invalid'" class="text-danger"> {{ password_validity }} </span>
	</span> <span @click="enable_input('password')" id="idSpanEmailChangeDashboard" v-bind:style="changes.password.smallButton" class="small_button">Change</span></small>
	<input @keyup="validityCheckInput('password')" v-model="password" :disabled='password_input == true' id="idInputEmailUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your Name Here" type="password" value="" >
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class="" v-bind:style=' changes.repassword.smallText ' > <span>Re-enter repassword 
	<span v-show="repassword_validity == 'valid'" class="text-success"> {{ repassword_validity }} </span>
	<span v-show="repassword_validity == 'invalid'" class="text-danger"> {{ repassword_validity }} </span>
	</span> <span @click="enable_input('repassword')" id="idSpanEmailChangeDashboard" v-bind:style="changes.repassword.smallButton" class="small_button">Change</span></small>
	<input @keyup="validityCheckInput('repassword')" v-model="repassword" :disabled='repassword_input == true' id="idInputEmailUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your Name Here" type="password" value="" >
	</div>
	<div class="col-10 mx-0 px-0 ">
	<v-btn color="error" @click="submit()" id="idButtonUpdateProfileDashboard" class=" btn-block mb-3 mx-0 rounded-0">
	Update Info
	</v-btn>
	</div>
	<!-- update field part ends -->
	</div>
	</div>
	</div>
	<v-row justify="center">
	<v-dialog
	v-model="dialog"
	max-width="290"
	>
	<v-card>
	<v-card-title class="headline">Status</v-card-title>
	<v-card-text class="black--text">
	{{ status_text }}
	</v-card-text>
	<v-card-actions>
	<v-spacer></v-spacer>
	<v-btn
	color="green darken-1"
	text
	@click="dialog = false"
	>
	Okay
	</v-btn>
	</v-card-actions>
	</v-card>
	</v-dialog>
	</v-row>
	</div>`;




	var buttons = `
	<div class="container-fluid bg-light mt-1 mb-5">
	<div class="row justify-content-center align-items-center">
	<a v-bind:href="address.profile_basicPage"><v-btn   large class="ml-1" color="success">Basic</v-btn></a>
	<a v-bind:href="address.profile_personalPage"><v-btn  large class="ml-1" color="success">Personal</v-btn></a>
	<a v-bind:href="address.profile_addressPage"><v-btn     large class="ml-1" color="success">address</v-btn></a>
	<a v-bind:href="address.profile_photo_uploadPage"><v-btn    large class="ml-1" color="success">photo</v-btn></a>
	<div class="w-100"></div>
	<a v-bind:href="address.profile_change_passwordPage"><v-btn  disabled  large class="ml-1 mt-2" color="success">change Password</v-btn></a>
	<a v-bind:href="address.profile_change_emailPage"><v-btn large class="ml-1 mt-2" color="success">change Email</v-btn></a>
	</div>
	</div>
	`;

	Vue.component('buttons' , {
		template: buttons,
		data(){
			return {}
		},
		methods: {
		},
	})









	Vue.component('profile_change_password' , {
		props: ['profile_photo' ],
		template: password,
		data(){
			return {
				name: 'riyad---vue',
				dialog: false,
				status_text: '',
				password_input: true,
				password: '',
				password_validity: '',
				repassword_input: true,
				repassword: '',
				repassword_validity: '',
				recent_photo: '',
				changes:{
					password:{
						smallText: {
							color: '#2196f3'					
						},
						smallButton: {
							color: 'white',
							backgroundColor: '#2196f3' 
						}
					},
					repassword:{
						smallText: {
							color: '#2196f3'					
						},
						smallButton: {
							color: 'white',
							backgroundColor: '#2196f3' 
						}
					},
				} 
			}
		},
		methods: {
			enable_input: function(name){
				if(name=='password'){
					this.password_input = false;
					this.changes.password.smallText.color = 'red';
					this.changes.password.smallButton.color = 'white';
					this.changes.password.smallButton.backgroundColor = 'red';
					//alert(this.password_input);
				}
				if(name=='repassword'){
					this.repassword_input = false;
					this.changes.repassword.smallText.color = 'red';
					this.changes.repassword.smallButton.color = 'white';
					this.changes.repassword.smallButton.backgroundColor = 'red';
					//alert(this.password_input);
				}
			},
			validityCheckInput( inputName  ){
				if(inputName == 'password'){
					
					var patt= /[\S]{6,}/g;
					var result = patt.test(this.password);
					result == false ? this.password_validity = 'invalid' : this.password_validity = 'valid';
				}else if(inputName == 'repassword'){
					
					var patt= /[\S]{6,}/g;
					var result = patt.test(this.repassword);
					result == false ? this.repassword_validity = 'invalid' : this.repassword_validity = 'valid';
				}
			},
			submit(){
				//alert(this.blood_group);
				this.validityCheckInput('password');
				this.validityCheckInput('repassword');
				if(this.password_validity == 'valid' && this.password == this.repassword){
					axios.post( this.model.modelProfile_change_password ,
					{
						purpose: 'password',
						password: this.password,
					}
					).then(function(response){
						
						this.status_text = 'Password Updated successfully';
						this.dialog = true;
					}.bind(this))
					.catch(function(error){
        //console.log(error);
    }.bind(this));
				}else{
					this.status_text = 'password doesnt match';
					this.dialog = true;
					//alert('all filed are not valid');
				}
			}
		},
		created(){
			axios.post( this.model.modelProfile_basic ,
			{
				purpose: 'getProfileBasicInfo',
				
			}
			).then(function(response){
				
				//
				//this.password = response.data.full_name;

				if(response.data.recent_photo !='not_set'){
					this.recent_photo = this.directories.upload_recent_photo_directory+response.data.recent_photo;
				}else{
					this.recent_photo = this.directories.upload_recent_photo_directory+'default.jpg';
				}



			}.bind(this))
			.catch(function(error){

			}.bind(this));
		}
	})




	var reg_req = new Vue({
		el: '#app' ,
		vuetify: new Vuetify(), 
		data : {
			name: 'riyad---vue',
			full_name_input: true,
			mobile_input: true,
			institution_id_input: true,
			number_of_children_input: true,
			dob_input: true,
			profile_photo: '',


		}, 
		methods : {
			enable_input: function(name){

			}
		},
		beforeCreate(){
		},
		created(){

		},
		beforeMount(){
		},
		mounted(){
		},
		beforeUpdated(){
		},
		updated(){
		//alert(this.CSRF_TOKEN);
		var dashboard_height = $('#dashboard_height').height();
		var windowHeight = $(document).height();
		var ht = dashboard_height+'px';
		$('.dashboard_vertical_menu_height').height(ht);
		
	}
})





</script>