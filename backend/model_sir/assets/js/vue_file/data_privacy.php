<script>
	var privacy = `
	<v-container>
  <v-row  justify="center">
  <v-col lg="8" class="text-center success white--text" >
  <h1>
  Privacy
  </h1>
  </v-col>
  </v-row>


  <v-row justify="center" >
  <v-col lg="8" >
  <v-simple-table>
  <template v-slot:default>
  <thead>
  <tr>
  <th class="text-left title">Name</th>
  <th class="text-left title">Privacy</th>
  </tr>
  </thead>
  <tbody>
  <tr v-for="(item , index) in users_info">
  <td class="body-1"> {{ takeName(item[0])  }} <br> {{ item[1] }}</td>
  <td>


  <v-radio-group :disabled='item[0] == "institution_id" || item[0]=="membership_number" || item[0]=="full_name"' @change="updatePrivacy(index)" v-model="item[2] ">
  <v-radio
  label="private"
  value="private"
  ></v-radio>
  <v-radio
  label="public"
  value="public"
  ></v-radio>
  </v-radio-group>

  </td>
  </tr>
  </tbody>
  </template>
  </v-simple-table>
  </v-col >
  </v-row>
  </v-container>`;


  Vue.component('data_privacy' , {
    template: privacy,
    data(){
     return{
      users_info: [],
      radioGroup: [],
      disabled: false,
    }
  },
  methods: {
    updatePrivacy(index){
      //alert('upadate privacy');

      

      axios.post( this.model.modeldata_privacy ,
      {
        users_info: this.users_info,
        purpose: 'updatePrivacy',
      }
      ).then(function(response){
        //this.users_info = response.data;
        
        
      }.bind(this))
      .catch(function(error){

        
      }.bind(this));



    },
    takeName(name){
      if(name=='full_name'){ 
        return 'Full Name';
      }else if(name == 'email'){
        return 'Email';
      }else if(name == 'mobile'){
        return 'Mobile';
      }else if(name == 'institution_id'){
        return 'Institution ID';
      }else if(name == 'nid_or_passport'){
        return 'NID/Passport';
      }else if(name == 'fathers_name'){
        return "Father's Name";
      }else if(name == 'mother_name'){
        return "Mother's Name";
      }else if(name == 'spouse_name'){
        return "Spouse's Name";
      }else if(name == 'number_of_children'){
        return "Number Of Children";
      }else if(name == 'profession'){
        return "Profession";
      }else if(name == 'designation'){
        return "Designation";
      }else if(name == 'blood_group'){
        return "Blood Group";
      }else if(name == 'date_of_birth'){
        return "Date Of Birth";
      }else if(name == 'present_line1'){
        return "Present Adress Line1";
      }else if(name == 'present_post_code'){
        return "Present Post Code";
      }else if(name == 'present_district'){
        return "Present District";
      }else if(name == 'parmanent_country'){
        return "Present Country";
      }else if(name == 'parmanent_line1'){
        return "Permanent Adress Line1";
      }else if(name == 'parmanent_post_code'){
        return "Permanent Post Code";
      }else if(name == 'parmanent_district'){
        return "Permanent District";
      }else if(name == 'parmanent_country'){
        return "Permanent Country";
      }else if(name == 'membership_number'){
        return "Member ship Number";
      }else if(name == 'type'){
        return "User Type";
      }else if(name == 'status'){
        return "Verfication Status";
      }else if(name == 'registration_date'){
        return "Account Created at";
      }else if(name == 'institution'){
          return "Workplace/Institution";
        }else if(name == 'email_verification_status'){
          return "Email Verification Status";
        }else if(name == 'change_request'){
          return "Information Update Request";
        }
    }


  },
  coumputed:{
    
  },
  created(){
    axios.post( this.model.modeldata_privacy ,
    {
      purpose: 'getPrivacy',
    },
    { 


    }
    ).then(function(response){
      this.users_info = response.data;
      
    }.bind(this))
    .catch(function(error){

      

    }.bind(this));




  },
  updated(){
   
  }
})





  var login = new Vue({
    el: '#app' ,
    vuetify: new Vuetify(), 
  })










</script>