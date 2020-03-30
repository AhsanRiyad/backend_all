<script>
	// This is a global mixin, it is applied to every vue instance
	
	Vue.mixin({
		data: function() {
			return {
				csrf_token1: '<?php echo $_SESSION['csrf_token1'] = bin2hex(random_bytes(32)); ?>',

			}
		}
	})





	var login = `

	<div class="container-fluid">
	<div class="row justify-content-xl-center justify-content-md-center _background ">
	<div class="col-12 col-md-9 col-xl-6 align-self-md-center ">
	<div class="container margin_">
	<div class="row py-4 ">


	<p class="text-dark h4" id="login_id">
	Welcome Back! Please login 
	<br>

	<span class="text-danger">
	{{ login_status }}
	</span>
	</p>
	</div>

	<div class="row justify-content-xl-center bg-white py-5 mb-5">

	<div class="col-12 col-xl-6 ">

	<div class="form-group">
	<label for="exampleInputEmail1" ><small id="idExampleInputEmail1Small">Email address*

	<span v-show="email_validity == 'valid'" class="text-success"> {{ email_validity }} </span>
	<span v-show="email_validity == 'invalid'" class="text-danger"> {{ email_validity }}  </span>

	</small>
	<br>



	</label>
	<input @keyup="onChangeValidity('email')" v-model='email' type="text" class="form-control rounded-0" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Enter email"
	value=""
	>
	</div>
	<div class="form-group">
	<label for="exampleInputPassword1"><small>Password*

	<span v-show="password_validity == 'valid'" class="text-success"> {{ password_validity }} </span>
	<span v-show="password_validity == 'invalid'" class="text-danger"> {{ password_validity }}, min 6 chars </span>
	


	</small>
	<br>



	</label>
	<input  @keyup="onChangeValidity('password')"  @keyup.enter="submit()" name="password" v-model='password' type="password" class="form-control rounded-0" id="exampleInputPassword1" placeholder="Password"
	value=""

	>
	<p class="text-right text-danger">
	<small><a v-bind:href="address.profile_forgot_passwordPage">Forgot password?</a></small>
	</p>
	</div>

	</div>
	<div class="col-12 col-xl-5 align-self-xl-center">
	<v-btn tile block :loading="loading" color="success" @click="submit()" class="">Log In</v-btn>

	<p class="text-danger h5 mt-2"><i>Not a member yet?</i></p>

	<a v-bind:href="address.registationPage"><button type="button" class="btn btn-primary rounded-0 w-100 py-2">Register Here</button></a>

	</div>


	</div>
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
	

	Vue.component('login' , {
		template: login,
		data(){
			return{
				loading: false,
				dialog: false,
				status_text: '',
				email: '',
				password: '',
				email_validity: '',
				password_validity: '',
				login_status: '',
			}
		},
		methods: {
			submit: function(){
				//alert('submit clicked');

				this.loading = true;
				if(this.email_validity == 'valid' && this.password_validity == 'valid'){

					axios.post( this.model.modelLogin , {
						email: this.email,  
						password: this.password,
						csrf_token1: this.csrf_token1,

					})
					.then( function(response){
						this.loading = false;
					//window.location.href = 'http://google.com';
					response.data == 'YES_USER' || response.data == 'YES_ADMIN' ? window.location.href = this.address.profile_basicPage : this.login_status = 'email/password doesnt match';  

					
					
				}.bind(this))
					.catch(function (error) {
						
						this.loading = false;
                //return 'hi';
            }.bind(this)); 

				}else{
					this.loading = false;
					this.status_text = 'invalid field detected'; 
					this.dialog = true;

				}

				
			},
			onChangeValidity(inputName){

				

				if(inputName == 'email'){
					
					var patt= /^[a-zA-Z]{1}[a-zA-Z1-9._]{3,15}@[a-zA-Z]{1}[a-zA-Z1-9]{3,15}\.[a-zA-Z]{2,10}(\.[a-zA-Z]{2})*$/g;
					var result = patt.test(this.email);

					result == false ? this.email_validity = 'invalid' : this.email_validity = 'valid';

				}else if(inputName == 'password'){
					
					var patt= /[\S]{6,}/g;
					var result = patt.test(this.password);

					result == false ? this.password_validity = 'invalid' : this.password_validity = 'valid';

				}
			},

		},
		created(){

		},
		updated(){

		}
	})









	var login = new Vue({
		el: '#app' ,
		vuetify: new Vuetify(), 
		data : {
			
		} , 
		methods : {
			

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


		}
	})







</script>