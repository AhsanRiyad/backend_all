<script>


	Vue.mixin({
		data: function() {
			return {
				csrf_token1: '<?php echo $_SESSION['csrf_token1'] = bin2hex(random_bytes(32)); ?>',
				forgot_password_crypto: '<?php if(isset($_GET['c'])){echo $_GET['c'];
			} ?>',
			email: '<?php if(isset($_GET['e'])){echo $_GET['e'];
		}else {
			echo 'not_set';
		} ?>',

	}
}
})


	var password_recovery = `<div class="container-fluid bg-light " style="margin-top: 150px;">
	<div class="row justify-content-center ">

	<!-- update top part starts-->

	<div class=" align-self-center col  col-4  px-0 py-0" style="box-shadow: 0 0 10px lightgrey; ">


	<div class="row bg-white mx-1">

	
	<div class="col-9 col  ml-0">
	<p class="h3 ">

	</p>
	
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




	Vue.component('profile_password_recovery' , {
		template: password_recovery,
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

					axios.post( this.model.modelProfile_password_recovery ,
					{
						purpose: 'password_change',
						password: this.password,
						email: this.email ,

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
		created(){}
	})





	var forgot = new Vue({
		el: '#app' ,
		vuetify: new Vuetify(), 
		data : {
			componet_name: 'forgot_password',
			invalid_link: '',
			
		} , 
		methods : {
			

		},
		beforeCreate(){
			
		},
		created(){
			
			// alert(this.email);

			axios.post( this.model.modelProfile_password_recovery ,
			{
				purpose: 'forgot_password_recovery',
				email: this.email.trim(),
				forgot_password_crypto: this.forgot_password_crypto.trim(),

			}
			).then(function(response){
				
				
				console.log(response);

				if(response.data == 'allow'){
	
					
				}else{
					
				}

			}.bind(this))
			.catch(function(error){


			}.bind(this));



		},
		beforeMount(){

		},
		mounted(){
			
		},
		beforeUpdated(){

		},
		updated(){


		}
	})



</script>