<script>
	
	var photos = `<div class="container-fluid bg-light mt-5 ">
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
	<p class="h3 text-white pl-4 pt-2"> <i class="fas fa-info-circle mr-0"></i> Upload Photos</p>
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class=""  > <span>recent Photo</span></small>
	<div class="custom-file">
	<input type="file" ref="recent_photo" v-on:change="handleFileUpload_recent()" class="custom-file-input" id="inputGroupFile01" aria-describedby="inputGroupFileAddon01">
	<label class="custom-file-label" for="inputGroupFile01">{{ recent_photo_name }}</label>
	</div>
	</div>
	<div class="col-10 mx-0 px-0 ">
	<v-btn :loading='loading_recent_photo' @click="uploadPhoto_recent()" block depressed color="blue-grey" id="idButtonUpdateProfileDashboard" class="white--text">
	Upload <v-icon right dark>mdi-cloud-upload</v-icon>
	</v-btn>
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class=""  > <span>old Photo</span></small>
	<div class="custom-file">
	<input type="file" ref="old_photo" v-on:change="handleFileUpload_old()" class="custom-file-input" id="inputGroupFile01" aria-describedby="inputGroupFileAddon01">
	<label class="custom-file-label" for="inputGroupFile01">{{ old_photo_name }}</label>
	</div>
	</div>
	<div class="col-10 mx-0 px-0 ">
	<v-btn :loading='loading_old_photo' @click="uploadPhoto_old()" block depressed color="blue-grey" id="idButtonUpdateProfileDashboard" class="white--text">
	Upload <v-icon right dark>mdi-cloud-upload</v-icon>
	</v-btn>
	</div>
	<div class="col-10 mt-3 border border-right-0 border-top-0 border-left-0 pl-0 pr-0"> 
	<small id='idSmallEmailChangeDashboard'  class=""  > <span>group Photo</span></small>
	<div class="custom-file">
	<input type="file" ref="group_photo" v-on:change="handleFileUpload_group()" class="custom-file-input" id="inputGroupFile01" aria-describedby="inputGroupFileAddon01">
	<label class="custom-file-label" for="inputGroupFile01">{{ group_photo_name }}</label>
	</div>
	</div>
	<div class="col-10 mx-0 px-0 ">
	<v-btn :loading='loading_group_photo' @click="uploadPhoto_group()" block depressed color="blue-grey" id="idButtonUpdateProfileDashboard" class="white--text">
	Upload <v-icon right dark>mdi-cloud-upload</v-icon>
	</v-btn>
	</div>
	<!-- update field part ends -->
	</div>
	</div>
	</div>
	<v-dialog
	v-model="dialog"
	max-width="290"
	>
	<v-card>
	<v-card-title class="headline">Photo Upload Status</v-card-title>
	<v-card-text class="black--text">
	{{ status }}
	</v-card-text>
	<v-card-actions>
	<v-spacer></v-spacer>
	<v-btn
	color="green darken-1"
	text
	@click="dialog = false"
	>
	OK
	</v-btn>
	</v-card-actions>
	</v-card>
	</v-dialog>
	</div>	`;
	
	




	var buttons = `
	<div class="container-fluid bg-light mt-1 mb-5">
	<div class="row justify-content-center align-items-center">
	<a v-bind:href="address.profile_basicPage"><v-btn   large class="ml-1" color="success">Basic</v-btn></a>
	<a v-bind:href="address.profile_personalPage"><v-btn  large class="ml-1" color="success">Personal</v-btn></a>
	<a v-bind:href="address.profile_addressPage"><v-btn     large class="ml-1" color="success">address</v-btn></a>
	<a v-bind:href="address.profile_photo_uploadPage"><v-btn disabled    large class="ml-1" color="success">photo</v-btn></a>
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





	Vue.component('profile_photo_upload' , {
		template: photos,
		data(){
			return {
				name: 'riyad---vue',
				dialog: false,
				status: '',
				recent_photo: '',
				recent_photo_name: 'choose file',
				old_photo: '',
				old_photo_name: 'choose file',
				group_photo: '',
				group_photo_name: 'choose file',
				loading_recent_photo:false,
				loading_old_photo:false,
				loading_group_photo:false,
				file_type: false,
				profile_photo: '',

			}
		},
		methods: {
			uploadPhoto_recent: function(){
				//alert(this.csrf_token1);
				if(this.file_type == true){
					this.loading_recent_photo = true;
					let formData = new FormData();
					formData.append('recent_photo', this.recent_photo);
					formData.append('purpose', 'recent_photo');
					formData.append('email', this.users_info__.email__);
					formData.append('user_id', this.users_info__.id__);
					// formData.append('email', 'riyad298@gmail.com');
					// formData.append('user_id', 1);
					formData.append('csrf_token1', this.csrf_token1);
					axios.post( this.model.modelProfile_photo_upload ,
						formData,
						{	
							headers: {
								'Content-Type': 'multipart/form-data'
							}
						}
						).then(function(response){
							this.loading_recent_photo = false;
							response.data == 'success' ? this.status = 'upload successful' : this.status = 'problem uploading your photo, try again';
							
							this.dialog = true;
							this.recent_photo_name = 'choose file';
							
							this.get_users_data();
						}.bind(this))
						.catch(function(error){
							this.loading_recent_photo = false;
							this.status = 'You are not authorized';
							this.dialog = true;
							this.recent_photo_name = 'choose file';
							
						}.bind(this));
						
						this.file_type = false;
					}else{
						this.status = 'select right type of file first';
						this.dialog = true;
					}
				},
				handleFileUpload_recent: function(){
				//alert('uploading files');
				this.recent_photo = this.$refs.recent_photo.files[0];
				//console.log(this.recent_photo.size/1024/1024);
				//console.log(this.recent_photo);
				var patt = /^(image\/){1}[A-Za-z]*/g;
				var result = patt.test(this.recent_photo.type);
				if(!result){
					this.file_type = false;
					this.status = 'incorrect file type\n select again';
					this.dialog = true;
				}else{
					this.file_type = true;
					this.recent_photo_name = this.recent_photo.name.slice(0,15);
					this.recent_photo = this.$refs.recent_photo.files[0];
				}
				
			},
			get_users_data(){
				axios.post( this.model.modelProfile_basic ,
				{
					purpose: 'getProfileBasicInfo',
				}
				).then(function(response){
					

					if(response.data.recent_photo !='not_set'){
						this.profile_photo = this.directories.upload_recent_photo_directory+response.data.recent_photo;

					
				}else{
					this.profile_photo = this.directories.upload_recent_photo_directory+'default.jpg';
				}


			}.bind(this))
				.catch(function(error){
        //console.log(error);
    }.bind(this));
			},
			uploadPhoto_old: function(){
				//alert(this.csrf_token1);
				if(this.file_type == true){
					this.loading_old_photo = true;
					let formData = new FormData();
					formData.append('old_photo', this.old_photo);
					formData.append('purpose', 'old_photo');
					formData.append('email', this.users_info__.email__);
					formData.append('user_id', this.users_info__.id__);
					// formData.append('email', 'riyad298@gmail.com');
					// formData.append('user_id', 1);
					formData.append('csrf_token1', this.csrf_token1);
					axios.post( this.model.modelProfile_photo_upload,
						formData,
						{	
							headers: {
								'Content-Type': 'multipart/form-data'
							}
						}
						).then(function(response){
							this.loading_old_photo = false;
							response.data == 'success' ? this.status = 'upload successful' : this.status = 'problem uploading your photo, try again';
							this.dialog = true;
							this.old_photo_name = 'choose file';
							
						}.bind(this))
						.catch(function(error){
							this.loading_old_photo = false;
							this.status = 'You are not authorized';
							this.dialog = true;
							this.old_photo_name = 'choose file';
							
						}.bind(this));
						
						this.file_type = false;
					}else{
						this.status = 'select right type of file first';
						this.dialog = true;
					}
				},
				handleFileUpload_old: function(){
				//alert('uploading files');
				this.old_photo = this.$refs.old_photo.files[0];
				//console.log(this.old_photo.size/1024/1024);
				//console.log(this.old_photo);
				var patt = /^(image\/){1}[A-Za-z]*/g;
				var result = patt.test(this.old_photo.type);
				if(!result){
					this.file_type = false;
					this.status = 'incorrect file type\n select again';
					this.dialog = true;
				}else{
					this.file_type = true;
					this.old_photo_name = this.old_photo.name.slice(0,15);
					this.old_photo = this.$refs.old_photo.files[0];
				}
			},
			uploadPhoto_group: function(){
				//alert(this.csrf_token1);
				if(this.file_type == true){
					this.loading_group_photo = true;
					let formData = new FormData();
					formData.append('group_photo', this.group_photo);
					formData.append('purpose', 'group_photo');
					formData.append('email', this.users_info__.email__);
					formData.append('user_id', this.users_info__.id__);
					// formData.append('email', 'riyad298@gmail.com');
					// formData.append('user_id', 1);
					formData.append('csrf_token1', this.csrf_token1);
					axios.post( this.model.modelProfile_photo_upload,
						formData,
						{	
							headers: {
								'Content-Type': 'multipart/form-data'
							}
						}
						).then(function(response){
							this.loading_group_photo = false;
							response.data == 'success' ? this.status = 'upload successful' : this.status = 'problem uploading your photo, try again';
							this.dialog = true;
							this.group_photo_name = 'choose file';
							
						}.bind(this))
						.catch(function(error){
							this.loading_group_photo = false;
							this.status = 'You are not authorized';
							this.dialog = true;
							this.group_photo_name = 'choose file';
							//console.log(error);
						}.bind(this));
						
						this.file_type = false;
					}else{
						this.status = 'select right type of file first';
						this.dialog = true;
					}
				},
				handleFileUpload_group: function(){
				//alert('uploading files');
				this.group_photo = this.$refs.group_photo.files[0];
				//console.log(this.group_photo.size/1024/1024);
				//console.log(this.group_photo);
				var patt = /^(image\/){1}[A-Za-z]*/g;
				var result = patt.test(this.group_photo.type);
				if(!result){
					this.file_type = false;
					this.status = 'incorrect file type\n select again';
					this.dialog = true;
				}else{
					this.file_type = true;
					this.group_photo_name = this.group_photo.name.slice(0,15);
					this.group_photo = this.$refs.group_photo.files[0];
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
					this.profile_photo = this.directories.upload_recent_photo_directory+response.data.recent_photo;

				}else{
					this.profile_photo = this.directories.upload_recent_photo_directory+'default.jpg';
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