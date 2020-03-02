<script>
	


	var email = `<div class="container-fluid bg-light mt-5 ">
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
	<p class="h3 text-white pl-4 pt-2"> <i class="fas fa-info-circle mr-0"></i> Change email</p>
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class="" v-bind:style=' changes.email.smallText ' > <span>New email 
	<span v-show="email_validity == 'valid'" class="text-success"> {{ email_validity }} </span>
	<span v-show="email_validity == 'invalid'" class="text-danger"> {{ email_validity }} </span>
	</span> <span @click="enable_input('email')" id="idSpanEmailChangeDashboard" v-bind:style="changes.email.smallButton" class="small_button">Change</span></small>
	<input @keyup="validityCheckInput('email')" v-model="email" :disabled='email_input == true' id="idInputEmailUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your Name Here" type="email" value="" >
	</div>
	<div class="col-10 mx-0 px-0 ">
	<v-btn :loading='loading' color="error" @click="submit()" id="idButtonUpdateProfileDashboard" class=" btn-block mb-3 mx-0 rounded-0">
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
	<v-col v-if="otp_text_box_show" col="12" class="mt-n8">
	<v-text-field
	label="OTP sent to your email" v-model="otp"
	></v-text-field>
	<v-btn @click="changeEmail()" :loading="loading" color="success">
	Validate
	</v-btn>
	</v-col>
	<v-card-actions>
	<v-spacer></v-spacer>
	<v-btn
	color="green darken-1"
	text
	@click="email_change_logout()"
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
	<a v-bind:href="address.profile_change_passwordPage"><v-btn  large class="ml-1 mt-2" color="success">change Password</v-btn></a>
	<a v-bind:href="address.profile_change_emailPage"><v-btn disabled large class="ml-1 mt-2" color="success">change Email</v-btn></a>
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









	Vue.component('profile_change_email' , {
		props: ['profile_photo' ],
		template: email,
		data(){
			return {
				name: 'riyad---vue',
				email_change_status: false,
				dialog: false,
				status_text: '',
				email_input: true,
				email: '',
				email_validity: '',
				status_text_show: false,
				otp_text_box_show: false,
				loading: false,
				recent_photo: '',
				otp: '',
				changes:{
					email:{
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
				if(name=='email'){
					this.email_input = false;
					this.changes.email.smallText.color = 'red';
					this.changes.email.smallButton.color = 'white';
					this.changes.email.smallButton.backgroundColor = 'red';
					//alert(this.email_input);
				}
			},
			validityCheckInput( inputName  ){
				if(inputName == 'email'){
					
					var patt= /^[a-zA-Z]{1}[a-zA-Z1-9._]{3,15}@[a-zA-Z]{1}[a-zA-Z1-9]{3,15}\.[a-zA-Z]{2,10}(\.[a-zA-Z]{2})*$/g;
					var result = patt.test(this.email);
					result == false ? this.email_validity = 'invalid' : this.email_validity = 'valid';
				}
			},
			changeEmail(){
				axios.post( this.model.modelProfile_change_email ,
				{
					purpose: 'changeEmail',
					email: this.email,
					otp: this.otp,
				}
				).then(function(response){
					
					if(response.data == 'success'){
						this.otp_text_box_show = true;
						this.status_text = 'email changed successfully';
						this.email_change_status = true;
					}else{
						this.otp_text_box_show = false;
						this.status_text = 'invalid otp';
						this.email_change_status = false;
					}
					this.loading = false;
					this.dialog = true;
					this.email_validity = 'invalid';

				}.bind(this))
				.catch(function(error){
					this.loading = false;
					
				}.bind(this));
			},
			email_change_logout(){
				this.dialog = false;
				if(this.email_change_status == true){
					window.location.href = this.address.loginPage;
				}
			},
			submit(){
				//alert(this.blood_group);
				this.validityCheckInput('email');
				
				if(this.email_validity == 'valid' ){
					this.loading = true;
					axios.post( this.model.modelProfile_change_email ,
					{
						purpose: 'email',
						email: this.email,
					}
					).then(function(response){
						
						if(response.data == 'success'){
							this.otp_text_box_show = true;
							this.status_text = '';
						}else{
							this.otp_text_box_show = false;
							this.status_text = 'email already used';
						}
						this.loading = false;
						this.dialog = true;
					}.bind(this))
					.catch(function(error){
						this.loading = false;
						
					}.bind(this));

					
				}else{
					this.status_text = 'email is not valid';
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
				

				if(response.data.recent_photo !='not_set'){
					this.recent_photo = this.directories.upload_recent_photo_directory+response.data.recent_photo;

					// console.log(response.data.recent_photo);
					// console.log(this.directories.upload_recent_photo_directory);
				}else{
					this.recent_photo = this.directories.upload_recent_photo_directory+'default.jpg';
				}




				//
				//this.email = response.data.full_name;
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