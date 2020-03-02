<script>

	var forgot_password = `
	<div class="container-fluid">
	<div class="row justify-content-xl-center justify-content-md-center _background ">
	<div class="col-12 col-xl-4 col-md-4 align-self-center ">
	<div class="container margin_">
	<div class="row py-4 ">

	<p class="text-dark h4" id="login_id">
	Forgot Password?
	<br>
	Please enter your email to recover..
	<br>
	<span v-show="login_status=='no_email_found'" class="red--text"> Account not found </span>
	
	<span v-show="login_status== 'crypto_added' " class="green--text"> recovery link sent to your email </span>


	</p>
	<span v-show="login_status=='server_problem'" class="red--text"> Email server problem , try later. </span>
	</p>

	</div>

	<div class="row justify-content-xl-center bg-white py-5 mb-5">

	<div class="col-12 col-xl-9 ">

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

	<v-btn color="success" :loading = 'loading' @click="submit" type="submit" name="submit" value="submit" class="btn btn-success rounded-0 mb-1 w-100 py-2">Recover Password</v-btn >

	<!-- <button type="submit" name="submit" value="submit" class="btn btn-info rounded-0 mb-1 w-100 py-2">Back to Login</button> -->

	<br>

	<div class="row justify-content-end">
	<div class="col-lg-auto">
	<a v-bind:href="address.loginPage" class="">Go Back to Login</a>
	</div>
	</div>





	</div>



	</div>
	</div>
	</div>
	</div>


	

	</div>
	
	`;
	


	Vue.component('profile_forgot_password' , {
		template: forgot_password,
		data(){
			return{
				loading: false,
				status_text: '',
				email: '',
				email_validity: '',
				login_status: '',
			}
		},
		methods: {
			submit: function(){
				//alert('submit clicked');
				this.invalid_link = '';

				this.loading = true;
				if(this.email_validity == 'valid'){

					axios.post( this.model.modelProfile_forgot_password , {
						purpose: 'forgot_password',
						email: this.email,
						
					})
					.then( function(response){
						this.loading = false;
					//window.location.href = 'http://google.com';
					// response.data == 'YES' ? window.location.href = this.address.profilePage : this.login_status = 'email/password doesnt match';  
					this.login_status = response.data;


					
				}.bind(this))
					.catch(function (error) {
						
						this.loading = false;
                //return 'hi';
            }.bind(this)); 

				}else{
					this.loading = false;
					this.login_status = 'invalid_email';

				}

				
			},
			onChangeValidity(inputName){

				if(inputName == 'email'){
					
					var patt= /^[a-zA-Z]{1}[a-zA-Z1-9._]{3,15}@[a-zA-Z]{1}[a-zA-Z1-9]{3,15}\.[a-zA-Z]{2,10}(\.[a-zA-Z]{2})*$/g;
					var result = patt.test(this.email);

					result == false ? this.email_validity = 'invalid' : this.email_validity = 'valid';

				}





			},

		},
		created(){

		},
		updated(){

		}
	})



	var forgot = new Vue({
		el: '#app' ,
		vuetify: new Vuetify(), 
		data : {
		} , 
		methods : {
			

		},
		beforeCreate(){
			
		},
		created(){},
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