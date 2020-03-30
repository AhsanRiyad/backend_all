<script>

// registration page
// dob datepicker  



var code = `<!-- registration page starts now -->

<div class="container-fluid">
<div  class="row justify-content-xl-center align-items-center 
 justify-content-md-center reg_background no-gutters">
<div class="col-12 col-md-9 col-xl-6 ">
<div class="container">
<div class="row pt-4 pb-1">


<p class="text-dark  h4" id='msg'>
Welcome, Create your Account 

<span  class="red--text" v-if='registratrion_status === "NO"'> Email Already used! </span>

<span  class="green--text" v-if='registratrion_status === "YES"'> Registration Successful! </span>


</p>		



<span class="ml-auto mt-xl-auto mt-md-0 pt-3"><small >Alredy member? <a v-bind:href="address.loginPage">Login</a> here</small></span>
</div>

<div class="row justify-content-xl-center bg-white py-5 mb-5">

<!-- email input -->
<div class="col-12 col-xl-5 ">

<p class="text-danger h4 bg-white">

</p>



<!-- full name input -->
<div class="form-group mt-3">
<label for="exampleInputEmail1"><small id="lnLabel">full Name*



<span v-show="full_name_validity == 'valid'" class="text-success"> {{ full_name_validity }} </span>
<span v-show="full_name_validity == 'invalid'" class="text-danger"> {{ full_name_validity }}  </span>



</small>

<br>


</label>
<input @keyup="onChangeValidity('full_name')" name="full_name"  type="text" class="form-control rounded-0" id="lnInput" aria-describedby="full_nameHelp" placeholder="Enter full name"  ref='full_name' >
</div>

<!-- institution_id input -->
<div class="form-group mt-3">
<label for="exampleInputEmail1"><small id="lnLabel">institution_id*



<span v-show="institution_id_validity == 'valid'" class="text-success"> {{ institution_id_validity }} </span>
<span v-show="institution_id_validity == 'invalid'" class="text-danger"> {{ institution_id_validity }}  </span>



</small>
<small class="text-danger">

</small>
<br>


</label>

<input @keyup="onChangeValidity('institution_id')"  name="institution_id" v-model='institution_id'  type="text" class="form-control rounded-0" id="lnInput" aria-describedby="emailHelp" placeholder="Enter institution_id" value="">
</div>




<!-- mobile number input -->
<div class="form-group mb-xl-3 mb-md-0">
<label for="exampleInputEmail1"><small id="exampleLabelMobile">Mobile Number*

<span v-show="mobile_validity == 'valid'" class="text-success"> {{ mobile_validity }} </span>
<span v-show="mobile_validity == 'invalid'" class="text-danger"> {{ mobile_validity }}  </span>


</small>

<small class="text-danger">

</small>

<br>

</label>

<input @keyup="onChangeValidity('mobile')" v-model='mobile' name="mobile" type="text" class="form-control rounded-0" id="exampleInputMobile" aria-describedby="emailHelp" placeholder="Enter mobile number"
value="">
</div>







<!-- <p class="text-danger h5 mt-4"><i>Already have an account?</i></p>

<a href="reg.php"><button type="button" class="btn btn-primary rounded-0 w-100 py-2">Register Here</button></a> -->

</div>


<div class="col-12 col-xl-5 ">



<!-- Email input -->
<div class="form-group mb-xl-3  mt-xl-3 mt-md-0 mb-md-0">
<label for="exampleInputEmail1"><small id="exampleLabelMobile">Email*


<span v-show="email_validity == 'valid'" class="text-success"> {{ email_validity }} </span>
<span v-show="email_validity == 'invalid'" class="text-danger"> {{ email_validity }}  </span>



<span class="text-danger">

</span>

</small>

<small class="text-danger">

</small>

<br>

</label>

<input @keyup="onChangeValidity('email')" name="email" v-model='email' type="text" class="form-control rounded-0" id="exampleInputemail" aria-describedby="emailHelp" placeholder="Enter email address"
value="">
</div>


<div class="form-group mb-xl-3">
<label for="exampleInputPassword1"><small id='idexampleInputPassword1'>Password*



<span v-show="password_validity == 'valid'"  class="text-success"> {{ password_validity }} </span>
<span v-show="password_validity == 'invalid'" class="text-danger"> {{ password_validity }}  </span>





</small>
<br>
</label>
<input @keyup="onChangeValidity('password')"  v-model='password' name="password" type="password" class="form-control rounded-0" id="exampleInputPassword1" placeholder="Password" value="">
</div>
<!-- toc terms and condition input -->


<!-- submit button -->
<p class="mt-9 mb-0">By registering, I agree with the TOC</p>



<v-btn @click='submit()' :loading='loading' class="green white--text w-100 mt-0 pt-3 pb-3" tile>REGISTRATION</v-btn>



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



</div>


`;

registratrion_status = '';

Vue.component('registration' , {
	template: code, 
	data(){
		return {
			name: 'riyad---vue',
			dialog: false,
			status_text: '',
			full_name : 'green',
			email: '',
			mobile: '',
			institution_id: '',
			password: '',
			full_name_validity : 'green',
			email_validity: '',
			mobile_validity: '',
			institution_id_validity: '',
			password_validity: '',
			registratrion_status: 'default',
			loading: false
		}
	},
	methods:{
		full_name_change : function(){
			//alert(this.$refs.full_name.value);
			//alert('hi');
			var patt = /(^[A-Za-z\s\.]{3,}$)/g;
			var result = patt.test(this.$refs.full_name.value);
			//var result = true ;
			if(result){
				//alert('name change');
				this.name_result = 'Name is accepeted' ; 
				this.full_name_color = 'green' ; 

			}else{
				//alert('name_result');
				this.name_result = 'Name is not accepeted' ; 

				this.full_name_color = 'red' ;								
			}
		},

		
		changeType: function(){
			this.registratrion_status = 'NO';
		},

		submit: function(){
			// alert('on click');
			this.loading = true;

			if(this.full_name_validity == 'valid' && this.institution_id_validity == 'valid' && this.mobile_validity == 'valid' && this.email_validity == 'valid' && this.password_validity == 'valid'){


				axios.post(this.model.modelRegirstration, {
					full_name: this.$refs.full_name.value,
					institution_id: this.institution_id,
					email: this.email,
					mobile: this.mobile,
					password: this.password,
					who_is_doing_registration: 'user',
				})
				.then( function(response){
					this.registratrion_status = response.data ; 
					this.loading = false;

				}.bind(this))
				.catch(function (error) {
					// console.log(error);
					this.loading = false;
				//return 'hi';
			});
			}else{

				this.loading = false;
				this.status_text = 'invalid field detected';
				this.dialog = true;

			}



			

			//alert(this.registratrion_status+ 'outside');

			//window.location.href = '';
		},
		onChangeValidity(inputName){
			if(inputName == 'full_name'){
				// console.log(this.$refs.full_name.value);
				var patt= /[A-Za-z.\s]{5,}/g;
				var result = patt.test(this.$refs.full_name.value);

				result == false ? this.full_name_validity = 'invalid' : this.full_name_validity = 'valid';

			}else if(inputName == 'institution_id'){
				// console.log(this.institution_id);
				var patt= /[A-Za-z\S]{5,}/g;
				var result = patt.test(this.institution_id);

				result == false ? this.institution_id_validity = 'invalid' : this.institution_id_validity = 'valid';

			}else if(inputName == 'mobile'){
				// console.log(this.mobile);
				var patt= /[\+]{0,1}[\d]{11,}/g;
				var result = patt.test(this.mobile);

				result == false ? this.mobile_validity = 'invalid' : this.mobile_validity = 'valid';

			}else if(inputName == 'email'){
				// console.log(this.email);
				var patt= /^[a-zA-Z]{1}[a-zA-Z1-9._]{3,15}@[a-zA-Z]{1}[a-zA-Z1-9]{3,15}\.[a-zA-Z]{2,10}(\.[a-zA-Z]{2})*$/g;
				var result = patt.test(this.email);

				result == false ? this.email_validity = 'invalid' : this.email_validity = 'valid';

			}else if(inputName == 'password'){
				// console.log(this.password);
				var patt= /[\S]{6,}/g;
				var result = patt.test(this.password);

				result == false ? this.password_validity = 'invalid' : this.password_validity = 'valid';

			}

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

	}


})












var registration_page = new Vue({
	el: '#app' , 
	vuetify: new Vuetify(),
	data : {
		name: 'riyad---vue',
		name_result: '' , 
		full_name_color : 'green'
	} , 
	methods : {
		full_name_change : function(){
			//alert(this.$refs.full_name.value);
			//alert('hi');
			var patt = /(^[A-Za-z\s\.]{3,}$)/g;
			var result = patt.test(this.$refs.full_name.value);
			//var result = true ;
			if(result){
				//alert('name change');
				this.name_result = 'Name is accepeted' ; 
				this.full_name_color = 'green' ; 

			}else{
				//alert('name_result');
				this.name_result = 'Name is not accepeted' ; 

				this.full_name_color = 'red' ;								
			}
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

	}
})












</script>