<script>
	
	var personal = `<div class="container-fluid bg-light mt-5 ">
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
	<p class="h3 text-white pl-4 pt-2"> <i class="fas fa-info-circle mr-0"></i> Personal Info</p>
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class="" v-bind:style=' changes.fathers_name.smallText ' > <span>Fathers Name
	<span v-show="fathers_name_validity == 'valid'" class="text-success"> {{ fathers_name_validity }} </span>
	<span v-show="fathers_name_validity == 'invalid'" class="text-danger"> {{ fathers_name_validity }} </span>
	</span> <span @click="enable_input('fathers_name')" id="idSpanEmailChangeDashboard" v-bind:style="changes.fathers_name.smallButton" class="small_button">Change</span></small>
	<input v-model="fathers_name" @keyup="onChangeValidity('fathers_name')" :disabled='fathers_name_input == true' id="idInputEmailUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your fathers name Here" type="text" value="" >
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class="" v-bind:style=' changes.mothers_name.smallText ' > <span>Mothers Name
	<span v-show="mothers_name_validity == 'valid'" class="text-success"> {{ mothers_name_validity }} </span>
	<span v-show="mothers_name_validity == 'invalid'" class="text-danger"> {{ mothers_name_validity }} </span>
	</span> <span @click="enable_input('mothers_name')" id="idSpanEmailChangeDashboard" v-bind:style="changes.mothers_name.smallButton" class="small_button">Change</span></small>
	<input v-model="mothers_name" @keyup="onChangeValidity('mothers_name')"  :disabled='mothers_name_input == true' id="idInputEmailUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your mothers_name Here" type="text" value="" >
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class="" v-bind:style=' changes.spouse_name.smallText ' > <span>Spouse Name
	<span v-show="spouse_name_validity == 'valid'" class="text-success"> {{ spouse_name_validity }} </span>
	<span v-show="spouse_name_validity == 'invalid'" class="text-danger"> {{ spouse_name_validity }} </span>
	</span> <span @click="enable_input('spouse_name')" id="idSpanEmailChangeDashboard" v-bind:style="changes.spouse_name.smallButton" class="small_button">Change</span></small>
	<input v-model="spouse_name" @keyup="onChangeValidity('spouse_name')" :disabled='spouse_name_input == true' id="idInputEmailUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your spouse_name Here" type="text" value="" >
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class="" v-bind:style=' changes.number_of_children.smallText ' > <span>Number of children
	<span v-show="number_of_children_validity == 'valid'" class="text-success"> {{ number_of_children_validity }} </span>
	<span v-show="number_of_children_validity == 'invalid'" class="text-danger"> {{ number_of_children_validity }} </span>
	</span> <span @click="enable_input('number_of_children')" id="idSpanEmailChangeDashboard" v-bind:style="changes.number_of_children.smallButton" class="small_button">Change</span></small>
	<input v-model="number_of_children" @keyup="onChangeValidity('number_of_children')"  :disabled='number_of_children_input == true' id="idInputEmailUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your number_of_children Here" type="text" value="" >
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class="" v-bind:style=' changes.profession.smallText ' > <span>Profession
	<span v-show="profession_validity == 'valid'" class="text-success"> {{ profession_validity }} </span>
	<span v-show="profession_validity == 'invalid'" class="text-danger"> {{ profession_validity }} </span>
	</span> <span @click="enable_input('profession')" id="idSpanEmailChangeDashboard" v-bind:style="changes.profession.smallButton" class="small_button">Change</span></small>
	<input v-model="profession" @keyup="onChangeValidity('profession')" 
	:disabled='profession_input == true' id="idInputEmailUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your profession Here" type="text" value="" >
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class="" v-bind:style=' changes.workplace_or_institution.smallText ' > <span>Workplace/Institution
	<span v-show="workplace_or_institution_validity == 'valid'" class="text-success"> {{ workplace_or_institution_validity }} </span>
	<span v-show="workplace_or_institution_validity == 'invalid'" class="text-danger"> {{ workplace_or_institution_validity }} </span>
	</span> <span @click="enable_input('workplace_or_institution')" id="idSpanEmailChangeDashboard" v-bind:style="changes.workplace_or_institution.smallButton" class="small_button">Change</span></small>
	<input v-model="workplace_or_institution" @keyup="onChangeValidity('workplace_or_institution')" 
	:disabled='workplace_or_institution_input == true' id="idInputEmailUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your workplace_or_institution Here" type="text" value="" >
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class="" v-bind:style=' changes.designation.smallText ' > <span>Designation
	<span v-show="designation_validity == 'valid'" class="text-success"> {{ designation_validity }} </span>
	<span v-show="designation_validity == 'invalid'" class="text-danger"> {{ designation_validity }} </span>
	</span> <span @click="enable_input('designation')" id="idSpanEmailChangeDashboard" v-bind:style="changes.designation.smallButton" class="small_button">Change</span></small>
	<input v-model="designation" @keyup="onChangeValidity('designation')"  :disabled='designation_input == true' id="idInputEmailUpdateProfileDashboard" class="d-block border-0 w-100 pb-1 mr-0 pl-2" placeholder="Type Your designation Here" type="text" value="" >
	</div>
	<div class="col-10 mx-0 px-0 ">
	<button :disabled = "submit_disabled" @click="submit()" id="idButtonUpdateProfileDashboard" class="btn btn-danger btn-block mb-3 mx-0 rounded-0">
	Update Info
	</button>
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
	<a v-bind:href="address.profile_personalPage"><v-btn disabled  large class="ml-1" color="success">Personal</v-btn></a>
	<a v-bind:href="address.profile_addressPage"><v-btn    large class="ml-1" color="success">address</v-btn></a>
	<a v-bind:href="address.profile_photo_uploadPage"><v-btn   large class="ml-1" color="success">photo</v-btn></a>
	<div class="w-100"></div>
	<a v-bind:href="address.profile_change_passwordPage"><v-btn  large class="ml-1 mt-2" color="success">change Password</v-btn></a>
	<a v-bind:href="address.profile_change_emailPage"><v-btn   large class="ml-1 mt-2" color="success">change Email</v-btn></a>
	</div>
	</div>
	`;



	var alert = `	
	<div class="container">
	<div class="row justify-content-center no-gutters">
	<div class="col col-xl-4 col-md-7 ">
	<a v-bind:href="address.profile_verify_emailPage">
	<v-alert type="error" v-if="email_verification_status == 'not_verified'">
	Your email is not verified , click to solve
	</v-alert></a>
	<a>
	<v-alert type="warning" v-if="completeness < 100"> {{ profile_completeness_msg }} 
	</v-alert></a>
	<a>
	<v-alert type="warning" v-if="completeness == 100 && users_info.status == 'not_verified' "> You are not verified yet, wait for verifiaction 
	</v-alert></a>
	</div>
	</div>
	</div>
	`;


	var bus = new Vue();


	Vue.component('alert' , {
		template: alert ,
		data(){
			return {
				email_verification_status: true,
				status: true,
				completeness: '',
				change_request: '',
				profile_completeness_msg: 'default',
				users_info: ''
			}
		},
		methods: {
			verify_email_otp(){
				//alert('veriy');
				
			},
			profile_completeness_bus(){
			}
		},
		created(){
			/*bus.$on('email_verification_status' , (data)=>{
				this.email_verification_status = data;
			});*/
			
			bus.$on('users_info' , (response)=>{
				
				// console.log('bus received');
				this.users_info = response;
				if(this.users_info.full_name == 'not_set' || this.users_info.full_name == null){
					this.profile_completeness_msg = 'full_name is not set';
				}else if(this.users_info.mobile == 'not_set' || this.users_info.mobile == null){
					this.profile_completeness_msg = 'mobile is not set';	
				}else if(this.users_info.institution_id == 'not_set' || this.users_info.institution_id == null){
					this.profile_completeness_msg = 'institution_id is not set';	
				}else if(this.users_info.nid_or_passport == 'not_set' || this.users_info.nid_or_passport == null){
					this.profile_completeness_msg = 'nid_or_passport is not set';	
				}else if(this.users_info.blood_group == 'not_set' || this.users_info.blood_group == null){
					this.profile_completeness_msg = 'blood_group is not set';	
				}else if(this.users_info.date_of_birth == 'not_set' || this.users_info.date_of_birth == null){
					this.profile_completeness_msg = 'date_of_birth is not set';	
				}else if(this.users_info.fathers_name == 'not_set' || this.users_info.fathers_name == null){
					this.profile_completeness_msg = 'fathers_name is not set';	
				}else if(this.users_info.mother_name == 'not_set' || this.users_info.mother_name == null){
					this.profile_completeness_msg = 'mother_name is not set';	
				}else if(this.users_info.spouse_name == 'not_set' || this.users_info.spouse_name == null){
					this.profile_completeness_msg = 'spouse_name is not set';	
				}else if(this.users_info.number_of_children == 'not_set' || this.users_info.number_of_children == null){
					this.profile_completeness_msg = 'number_of_children is not set';	
				}else if(this.users_info.profession == 'not_set' || this.users_info.profession == null){
					this.profile_completeness_msg = 'profession is not set';	
				}else if(this.users_info.institution == 'not_set' || this.users_info.institution == null){
					this.profile_completeness_msg = 'institution is not set';	
				}else if(this.users_info.designation == 'not_set' || this.users_info.designation == null){
					this.profile_completeness_msg = 'designation is not set';	
				}else if(this.users_info.present_line1 == 'not_set' || this.users_info.present_line1 == null){
					this.profile_completeness_msg = 'present_line1 is not set';	
				}else if(this.users_info.present_district == 'not_set' || this.users_info.present_district == null){
					this.profile_completeness_msg = 'present_district is not set';	
				}else if(this.users_info.present_post_code == 'not_set' || this.users_info.present_post_code == null){
					this.profile_completeness_msg = 'present_post_code is not set';	
				}else if(this.users_info.present_country == 'not_set' || this.users_info.present_country == null){
					this.profile_completeness_msg = 'present_country is not set';	
				}else if(this.users_info.parmanent_line1 == 'not_set' || this.users_info.parmanent_line1 == null){
					this.profile_completeness_msg = 'parmanent_line1 is not set';	
				}else if(this.users_info.parmanent_district == 'not_set' || this.users_info.parmanent_district == null){
					this.profile_completeness_msg = 'parmanent_district is not set';	
				}else if(this.users_info.parmanent_post_code == 'not_set' || this.users_info.parmanent_post_code == null){
					this.profile_completeness_msg = 'parmanent_post_code is not set';	
				}else if(this.users_info.parmanent_country == 'not_set' || this.users_info.parmanent_country == null){
					this.profile_completeness_msg = 'parmanent_country is not set';	
				}else if(this.users_info.recent_photo == 'not_set' || this.users_info.recent_photo == null){
					this.profile_completeness_msg = 'recent_photo is not set';	
				}else{
					axios.post( this.model.modelProfile_basic ,
					{
						purpose: 'profile_completeness_100',
						user_type: this.users_info.type ,
					}
					).then(function(response){
						
						this.users_info.type == 'admin' ? this.profile_completeness_msg = 'Profile completed , Thank You' : this.profile_completeness_msg = 'Profile completed , Wait for verfification';  
					}.bind(this))
					.catch(function(error){
						
					}.bind(this));
				}
			});
axios.post( this.model.modelProfile_basic ,
{
	purpose: 'getProfileBasicInfo',
}
).then(function(response){
	// console.log(response);
				//this.email = response.data.full_name;
				this.email_verification_status = response.data.email_verification_status;
				this.completeness = response.data.completeness;
				this.users_info = response.data;
			}.bind(this))
.catch(function(error){
	
}.bind(this));
},
updated(){
	if(this.users_info.full_name == 'not_set' || this.users_info.full_name == null){
		this.profile_completeness_msg = 'full_name is not set';
	}else if(this.users_info.mobile == 'not_set' || this.users_info.mobile == null){
		this.profile_completeness_msg = 'mobile is not set';	
	}else if(this.users_info.institution_id == 'not_set' || this.users_info.institution_id == null){
		this.profile_completeness_msg = 'institution_id is not set';	
	}else if(this.users_info.nid_or_passport == 'not_set' || this.users_info.nid_or_passport == null){
		this.profile_completeness_msg = 'nid_or_passport is not set';	
	}else if(this.users_info.blood_group == 'not_set' || this.users_info.blood_group == null){
		this.profile_completeness_msg = 'blood_group is not set';	
	}else if(this.users_info.date_of_birth == 'not_set' || this.users_info.date_of_birth == null){
		this.profile_completeness_msg = 'date_of_birth is not set';	
	}else if(this.users_info.fathers_name == 'not_set' || this.users_info.fathers_name == null){
		this.profile_completeness_msg = 'fathers_name is not set';	
	}else if(this.users_info.mother_name == 'not_set' || this.users_info.mother_name == null){
		this.profile_completeness_msg = 'mother_name is not set';	
	}else if(this.users_info.spouse_name == 'not_set' || this.users_info.spouse_name == null){
		this.profile_completeness_msg = 'spouse_name is not set';	
	}else if(this.users_info.number_of_children == 'not_set' || this.users_info.number_of_children == null){
		this.profile_completeness_msg = 'number_of_children is not set';	
	}else if(this.users_info.profession == 'not_set' || this.users_info.profession == null){
		this.profile_completeness_msg = 'profession is not set';	
	}else if(this.users_info.institution == 'not_set' || this.users_info.institution == null){
		this.profile_completeness_msg = 'institution is not set';	
	}else if(this.users_info.designation == 'not_set' || this.users_info.designation == null){
		this.profile_completeness_msg = 'designation is not set';	
	}else if(this.users_info.present_line1 == 'not_set' || this.users_info.present_line1 == null){
		this.profile_completeness_msg = 'present_line1 is not set';	
	}else if(this.users_info.present_district == 'not_set' || this.users_info.present_district == null){
		this.profile_completeness_msg = 'present_district is not set';	
	}else if(this.users_info.present_post_code == 'not_set' || this.users_info.present_post_code == null){
		this.profile_completeness_msg = 'present_post_code is not set';	
	}else if(this.users_info.present_country == 'not_set' || this.users_info.present_country == null){
		this.profile_completeness_msg = 'present_country is not set';	
	}else if(this.users_info.parmanent_line1 == 'not_set' || this.users_info.parmanent_line1 == null){
		this.profile_completeness_msg = 'parmanent_line1 is not set';	
	}else if(this.users_info.parmanent_district == 'not_set' || this.users_info.parmanent_district == null){
		this.profile_completeness_msg = 'parmanent_district is not set';	
	}else if(this.users_info.parmanent_post_code == 'not_set' || this.users_info.parmanent_post_code == null){
		this.profile_completeness_msg = 'parmanent_post_code is not set';	
	}else if(this.users_info.parmanent_country == 'not_set' || this.users_info.parmanent_country == null){
		this.profile_completeness_msg = 'parmanent_country is not set';	
	}else if(this.users_info.recent_photo == 'not_set' || this.users_info.recent_photo == null){
		this.profile_completeness_msg = 'recent_photo is not set';	
	}else{
		
		this.users_info.type == 'admin' ? this.profile_completeness_msg = 'Profile completed , Thank You' : this.profile_completeness_msg = 'Profile completed , Wait for verfification';  
	}
	
}
})


















Vue.component('buttons' , {
	template: buttons,
	data(){
		return {}
	},
	methods: {
	},
})





Vue.component('profile_personal' , {
	props: ['profile_photo' , 'CSRF_TOKEN' ],
	template: personal,
	data(){
		return {
			name: 'riyad---vue',
			dialog: '' , 
			status_text: '',
			fathers_name_input: true,
			mothers_name_input: true,
			spouse_name_input: true,
			number_of_children_input: true,
			dob_input: true,
			profession_input: true,
			workplace_or_institution_input: true,
			designation_input: true,
			fathers_name: '',
			mothers_name: '',
			spouse_name: '',
			number_of_children: '',
			dob: '',
			profession: '',
			workplace_or_institution: '',
			designation: '',
			designation_validity: false,
			fathers_name_validity: false,
			mothers_name_validity: false,
			spouse_name_validity: false,
			number_of_children_validity: false,
			dob_validity: false,
			profession_validity: false,
			workplace_or_institution_validity: false,
			designation_validity: false,
			users_info: '',
			submit_disabled: false,
			type: '',
			recent_photo:'',
			changes:{
				fathers_name:{
					smallText: {
						color: '#2196f3'					
					},
					smallButton: {
						color: 'white',
						backgroundColor: '#2196f3' 
					}
				},
				mothers_name:{
					smallText: {
						color: '#2196f3'					
					},
					smallButton: {
						color: 'white',
						backgroundColor: '#2196f3' 
					}
				},
				spouse_name:{
					smallText: {
						color: '#2196f3'					
					},
					smallButton: {
						color: 'white',
						backgroundColor: '#2196f3' 
					}
				},
				number_of_children:{
					smallText: {
						color: '#2196f3'					
					},
					smallButton: {
						color: 'white',
						backgroundColor: '#2196f3' 
					}
				},
				profession:{
					smallText: {
						color: '#2196f3'					
					},
					smallButton: {
						color: 'white',
						backgroundColor: '#2196f3' 
					}
				},
				workplace_or_institution:{
					smallText: {
						color: '#2196f3'					
					},
					smallButton: {
						color: 'white',
						backgroundColor: '#2196f3' 
					}
				},
				designation:{
					smallText: {
						color: '#2196f3'					
					},
					smallButton: {
						color: 'white',
						backgroundColor: '#2196f3' 
					}
				}				
			} 
		}
	},
	methods: {
		enable_input: function(name){
			if(name=='fathers_name'){
				this.fathers_name_input = false;
				this.changes.fathers_name.smallText.color = 'red';
				this.changes.fathers_name.smallButton.color = 'white';
				this.changes.fathers_name.smallButton.backgroundColor = 'red';
					//alert(this.fathers_name_input);
				}else if(name=='mothers_name'){
					this.mothers_name_input = false;
					this.changes.mothers_name.smallText.color = 'red';
					this.changes.mothers_name.smallButton.color = 'white';
					this.changes.mothers_name.smallButton.backgroundColor = 'red';
					//alert(this.mobile_input);
				}else if(name=='spouse_name'){
					this.spouse_name_input = false;
					this.changes.spouse_name.smallText.color = 'red';
					this.changes.spouse_name.smallButton.color = 'white';
					this.changes.spouse_name.smallButton.backgroundColor = 'red';
					//alert(this.mobile_input);
				}else if(name=='number_of_children'){
					this.number_of_children_input = false;
					this.changes.number_of_children.smallText.color = 'red';
					this.changes.number_of_children.smallButton.color = 'white';
					this.changes.number_of_children.smallButton.backgroundColor = 'red';
					//alert(this.mobile_input);
				}else if(name=='profession'){
					this.profession_input = false;
					this.changes.profession.smallText.color = 'red';
					this.changes.profession.smallButton.color = 'white';
					this.changes.profession.smallButton.backgroundColor = 'red';
					//alert(this.mobile_input);
				}else if(name=='workplace_or_institution'){
					this.workplace_or_institution_input = false;
					this.changes.workplace_or_institution.smallText.color = 'red';
					this.changes.workplace_or_institution.smallButton.color = 'white';
					this.changes.workplace_or_institution.smallButton.backgroundColor = 'red';
					//alert(this.mobile_input);
				}else if(name=='designation'){
					this.designation_input = false;
					this.changes.designation.smallText.color = 'red';
					this.changes.designation.smallButton.color = 'white';
					this.changes.designation.smallButton.backgroundColor = 'red';
					//alert(this.mobile_input);
				}
			},
			onChangeValidity(inputName){
				//console.log(this.fathers_name);
				if(inputName == 'fathers_name'){
					//console.log(this.fathers_name);
					var patt= /[A-Za-z.\s]{5,}/g;
					var result = patt.test(this.fathers_name);
					result == false ? this.fathers_name_validity = 'invalid' : this.fathers_name_validity = 'valid';
				}else if(inputName == 'mothers_name'){
					//console.log(this.mothers_name);
					var patt= /[A-Za-z.\s]{5,}/g;
					var result = patt.test(this.mothers_name);
					result == false ? this.mothers_name_validity = 'invalid' : this.mothers_name_validity = 'valid';
				}else if(inputName == 'spouse_name'){
					//console.log(this.spouse_name);
					var patt= /[A-Za-z.\s]{5,}/g;
					var result = patt.test(this.spouse_name);
					result == false ? this.spouse_name_validity = 'invalid' : this.spouse_name_validity = 'valid';
				}else if(inputName == 'number_of_children'){
					//console.log(this.number_of_children);
					var patt= /^[\d]{1,2}$/g;
					var result = patt.test(this.number_of_children);
					result == false ? this.number_of_children_validity = 'invalid' : this.number_of_children_validity = 'valid';
				}else if(inputName == 'profession'){
					//console.log(this.profession);
					var patt= /[A-Za-z.\s]{5,}/g;
					var result = patt.test(this.profession);
					result == false ? this.profession_validity = 'invalid' : this.profession_validity = 'valid';
				}else if(inputName == 'workplace_or_institution'){
					//console.log(this.workplace_or_institution);
					var patt= /[A-Za-z.\s]{5,}/g;
					var result = patt.test(this.workplace_or_institution);
					result == false ? this.workplace_or_institution_validity = 'invalid' : this.workplace_or_institution_validity = 'valid';
				}else if(inputName == 'designation'){
					//console.log(this.designation);
					var patt= /[A-Za-z.\s]{5,}/g;
					var result = patt.test(this.designation);
					result == false ? this.designation_validity = 'invalid' : this.designation_validity = 'valid';
				}
			},
			submit(){
				
				this.onChangeValidity('fathers_name');
				this.onChangeValidity('mothers_name');
				this.onChangeValidity('spouse_name');
				this.onChangeValidity('number_of_children');
				this.onChangeValidity('profession');
				this.onChangeValidity('workplace_or_institution');
				this.onChangeValidity('designation');
				if( this.fathers_name_validity == 'valid' &&  this.mothers_name_validity == 'valid' && this.spouse_name_validity == 'valid' && this.number_of_children_validity == 'valid' &&  this.profession_validity == 'valid' && this.workplace_or_institution_validity == 'valid' && this.designation_validity == 'valid' ){
					axios.post( this.model.modelProfile_personal ,
					{
						purpose: 'personal',
						fathers_name: this.fathers_name,
						mothers_name: this.mothers_name,
						spouse_name: this.spouse_name,
						number_of_children: this.number_of_children,
						profession: this.profession,
						workplace_or_institution: this.workplace_or_institution,
						designation: this.designation,
					}
					).then(function(response){
						
						this.type == 'admin' ? this.status_text = 'Updated, Thank You' : this.status_text = 'Update requested successfully! wait for admin approval';
						this.dialog = true;
						this.get_users_data();
					}.bind(this))
					.catch(function(error){
        //console.log(error);
    }.bind(this));
					this.status_text = 'All fields are valid';
					this.dialog = true ;
				}else{
					this.status_text = 'invalid fields detected';
					this.dialog = true ;
				}
			},
			get_users_data(){
				axios.post( this.model.modelProfile_personal ,
				{
					purpose: 'getProfileBasicInfo',
				}
				).then(function(response){
					
					this.present_line1 = response.data.present_line1;
					this.present_district = response.data.present_district;
					this.present_post_code = response.data.present_post_code;
					this.present_country = response.data.present_country;
					this.permanent_line1 = response.data.parmanent_line1;
					this.permanent_district = response.data.parmanent_district;
					this.permanent_post_code = response.data.parmanent_post_code;
					this.permanent_country = response.data.parmanent_country;
					this.type = response.data.type;

					bus.$emit('users_info' , response.data);

					
				}.bind(this))
				.catch(function(error){
        //console.log(error);
    }.bind(this));
			}
		},
		created(){
			axios.post( this.model.modelProfile_personal ,
			{
				purpose: 'getProfileBasicInfo',
				
			}
			).then(function(response){
				
				this.full_name = response.data.full_name;
				this.fathers_name = response.data.fathers_name;
				this.mothers_name = response.data.mother_name;
				this.spouse_name = response.data.spouse_name;
				this.number_of_children = response.data.number_of_children;
				this.number_of_children = response.data.number_of_children;
				this.profession = response.data.profession;
				this.workplace_or_institution = response.data.institution;
				this.designation = response.data.designation;
				this.users_info = response.data;
				this.type = response.data.type;
				if(this.users_info.completeness == 100 & this.users_info.status == 'not_verified'){
					this.submit_disabled = true;
				}


				if(response.data.recent_photo !='not_set'){
					this.recent_photo = this.directories.upload_recent_photo_directory+response.data.recent_photo;

					// console.log(response.data.recent_photo);
					// console.log(this.directories.upload_recent_photo_directory);
				}else{
					this.recent_photo = this.directories.upload_recent_photo_directory+'default.jpg';
				}

				bus.$emit('users_info' , this.users_info);
			}.bind(this))
			.catch(function(error){
				
        //console.log(error);
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