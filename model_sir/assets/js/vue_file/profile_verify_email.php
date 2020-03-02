<script>
	
	
var verify_email_otp = `<div class="container-fluid bg-light mt-5 ">
	<div class="row justify-content-center align-items-center">
	<!-- update top part starts-->
	<div class="  col-12 col-xl-4 col-md-7  px-0 py-1" style="box-shadow: 0 0 10px lightgrey; ">
	<div class="row bg-white mx-1">
	<div class="col-3 mr-0 pr-0 my-2">
	<img class="rounded img-thumbnail img-fluid" v-bind:src="profile_photo" alt="">
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
	<p class="h3 text-white pl-4 pt-2"> <i class="fas fa-info-circle mr-0"></i> Verify Email</p>
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallverify_email_otpChangeDashboard'  class="" v-bind:style=' changes.verify_email_otp.smallText ' > <span>Enter OTP
	<span v-show="verify_email_otp_validity == 'valid'" class="text-success"> {{ verify_email_otp_validity }} </span>
	<span v-show="verify_email_otp_validity == 'invalid'" class="text-danger"> {{ verify_email_otp_validity }} </span>
	</span> <span @click="enable_input('verify_email_otp')" id="idSpanverify_email_otpChangeDashboard" v-bind:style="changes.verify_email_otp.smallButton" class="small_button">Change</span></small>
	<input @keyup="validityCheckInput('verify_email_otp')" v-model="verify_email_otp" :disabled='verify_email_otp_input == true' id="idInputverify_email_otpUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your Name Here" type="verify_email_otp" value="" >
	</div>
	<div class="col-10 mx-0 px-0 ">
	<v-btn color="success" @click="submit()" id="idButtonUpdateProfileDashboard" class=" btn-block mb-3 mx-0 rounded-0">
	Verify
	</v-btn>
	<v-btn :loading='loading' color="primary" @click="sendOtpAgain()" id="idButtonUpdateProfileDashboard" class=" btn-block mb-3 mx-0 rounded-0">
	Send OTP
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
	<a v-bind:href="address.profile_personalPage"><v-btn   large class="ml-1" color="success">Personal</v-btn></a>
	<a v-bind:href="address.profile_addressPage"><v-btn    large class="ml-1" color="success">address</v-btn></a>
	<a v-bind:href="address.profile_photo_uploadPage"><v-btn   large class="ml-1" color="success">photo</v-btn></a>
	<div class="w-100"></div>
	<a v-bind:href="address.profile_change_passwordPage"><v-btn  large class="ml-1 mt-2" color="success">change Password</v-btn></a>
	<a v-bind:href="address.profile_change_emailPage"><v-btn   large class="ml-1 mt-2" color="success">change Email</v-btn></a>
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





Vue.component('profile_verify_email' , {
	props: ['profile_photo' ],
	template: verify_email_otp,
	data(){
		return {
			name: 'riyad---vue',
			dialog: false,
			status_text: '',
			verify_email_otp_input: true,
			verify_email_otp: '',
			verify_email_otp_validity: '',
			loading: false,
			changes:{
				verify_email_otp:{
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
			if(name=='verify_email_otp'){
				this.verify_email_otp_input = false;
				this.changes.verify_email_otp.smallText.color = 'red';
				this.changes.verify_email_otp.smallButton.color = 'white';
				this.changes.verify_email_otp.smallButton.backgroundColor = 'red';
					//alert(this.verify_email_otp_input);
				}
			},
			validityCheckInput( inputName  ){
				if(inputName == 'verify_email_otp'){
					
					var patt= /^[\d]{4}$/g;
					var result = patt.test(this.verify_email_otp);
					result == false ? this.verify_email_otp_validity = 'invalid' : this.verify_email_otp_validity = 'valid';
				}
			},
			submit(){
				//alert(this.blood_group);
				this.validityCheckInput('verify_email_otp');
				
				if(this.verify_email_otp_validity == 'valid' ){
					//alert(this.verify_email_otp);
					axios.post( this.model.modelProfile_verify_email ,
					{
						purpose: 'verify_email_otp',
						verify_email_otp: this.verify_email_otp,
						
					}
					).then(function(response){
						
						
						if(response.data == 'email_verified'){
							this.status_text = 'email verified successfully';
							
							this.dialog = true;
						}else{
							this.status_text = 'invalid otp, try again' ;
							this.dialog = true;
						}
					}.bind(this))
					.catch(function(error){
						
					}.bind(this));
				}else{
					this.status_text = 'OTP is not valid ';
					this.dialog = true;
					//alert('all filed are not valid');
				}
			},
			sendOtpAgain(){
				// alert('send otp');

				this.loading = true;
				axios.post( this.model.modelProfile_verify_email ,
				{
					purpose: 'send_otp',
				}
				).then(function(response){
					
					if(response.data == 'otp_sent'){
						this.status_text = 'OTP sent, check your email';
						this.dialog = true;
					}if(response.data == 'server_problem'){
						this.status_text = 'email server problem, try again later';
						this.dialog = true;
					}
					this.loading = false;
				}.bind(this))
				.catch(function(error){
					this.loading = false;
					
				}.bind(this));
			}
		},
		created(){
			axios.post( this.model.modelProfile_update ,
			{
				purpose: 'getProfileBasicInfo',
				
			}
			).then(function(response){
				
				//
				//this.verify_email_otp = response.data.full_name;
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