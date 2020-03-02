



<script>



  Vue.mixin({
    data: function() {
      return {


      }
    }
  })





  var gallery = `
 <div class="container">
  <div class="row justify-content-md-center">



  <div class="col col-md-5">
  <h1 class="text-center">Recent Photo</h1>


  <img class="text-center img-fluid img-thumbnail" v-if="recent_photo != 'not_set'"
  :src="rootAdress+recent_photos+recent_photo"
   style="max-height: 400px; width: 600px;">


  <img class="text-center img-fluid img-thumbnail" v-if="recent_photo == 'not_set'"
  :src="images.default_photo"
  style="max-height: 400px; width: 600px;">
  </div>




  <div class="w-100">
  </div>
  
  <div class="col col-md-5">
  <h1 class="text-center">old Photo</h1>


  <img class="text-center img-fluid img-thumbnail" v-if="old_photo != 'not_set'"
  :src="rootAdress+old_photos+old_photo"
   style="max-height: 400px; width: 600px;">


  <img class="text-center img-fluid img-thumbnail" v-if="old_photo == 'not_set'"
  :src="images.default_photo"
  style="max-height: 400px; width: 600px;">
  </div>



  </div>

  <div class="row  justify-content-center">
  <div class="row col-md-8">

  <div class="col-md-12">
  <h1 class="text-center" > Group Photos </h1>
  </div> 

  <div class="col-md-4" v-for="(photo , index) in group_photo">
  <img @click="zoom_in(rootAdress+group_photos+photo , photo)" style="height: 250px; width: 250px;" 
  aspect-ratio="1"
  :src="rootAdress+group_photos+photo" class="rounded mx-auto d-block img-fluid img-thumbnail" alt="...">
  </div>
  </div>
  </div>
  


  
  <v-row justify="center">
  <v-dialog v-model="dialog" scrollable max-width="700px">

  <v-card>
  <v-card-title>Image</v-card-title>
  <v-divider></v-divider>
  <v-card-text style="height: 400px;">
  
  <v-row align="center" justify="center">
  <v-img
  :src="dialog_photo"
  class="grey lighten-2"
  max-width="600"

  aspect-ratio="1"
  ></v-img>
  </v-row>

  </v-card-text>
  <v-divider></v-divider>
  <v-card-actions class="mb-5">
  
  <v-container>
  <v-row class="ml-3">
  
  <p class="red--text"> <b>{{ photo_delete_status }} </b></p>
  </v-row>
  <v-row>
  <v-col xs="12">
  <v-btn :disabled="button_disabled" @click="deletePhoto()" large :loading='loading' color="error"  >Delete</v-btn>
  <v-btn large color="primary"  @click="dialog = false">Close</v-btn>
  </v-col>
  </v-row>
 </v-container>


  </v-card-actions>
  </v-card>
  </v-dialog>
  </v-row>













  </div>

  `;



  Vue.component('gallery' , {
   template: gallery,
   data(){
    return {
      dialogm1: '',
      dialog: false,
      dialog_photo: '',
      dialog_photo_baseName: '',
      recent_photo: '' ,
      old_photo: '' ,
      group_photo: [],
      recent_photos: 'assets/img/uploads/recent_photos/',
      old_photos: 'assets/img/uploads/old_photos/',
      group_photos:  'assets/img/uploads/group_photos/',
      uploads:  'assets/img/uploads/',
      loading:false,
      photo_delete_status: '',
      button_disabled: false,

    }
  },
  methods : {
    zoom_in(photo , baseName){
      //alert(photo);
      this.button_disabled = false;
      this.photo_delete_status = '';
      this.dialog_photo_baseName = baseName;
      this.dialog_photo = photo;
      this.dialog = true;
      // alert('zooming in photo');
    },
    deletePhoto(){
      this.loading = true;

      //alert('deleting photo');
      axios.post( this.model.modelGallery ,
      {
        purpose: 'deletePhoto',
        basename: this.dialog_photo_baseName,
        
      }
      ).then(function(response){
        this.loading = false;
        this.recent_photo = response.data.recent_photo;
        this.old_photo = response.data.old_photo;
        this.group_photo = response.data.group_photo;
        this.photo_delete_status = "Your photo has been deleted";
        this.button_disabled = true ;
        


      }.bind(this))
      .catch(function(error){

        this.loading = false;


        //console.log(error);
      }.bind(this));


    },
  },
  created(){

      //alert(this.model.modelGallery);

      axios.post( this.model.modelGallery ,
      {

        purpose: 'getPhotos',
      }
      ).then(function(response){
        //this.users_info = response.data;
        // alert(rootAdress+'/assets/img/uploads/recent_photo/'+recent_photo);

        
        this.recent_photo = response.data.recent_photo;
        this.old_photo = response.data.old_photo;
        this.group_photo = response.data.group_photo;

        //alert(this.rootAdress+'assets/img/uploads/recent_photos/'+this.recent_photo);
        //alert(this.rootAdress+'assets/img/uploads/group_photos/'+this.group_photo[0]);

      }.bind(this))
      .catch(function(error){

        //console.log(error);
      }.bind(this));




    }

  })




  var gallery = new Vue({
    el: '#app' ,
    vuetify: new Vuetify(), 
  })





</script>
