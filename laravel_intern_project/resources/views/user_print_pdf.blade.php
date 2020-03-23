<!DOCTYPE html>
<html>
<head>

  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">


  <title>User's Info</title>



  <style>
    /*this class will be used for page break*/
    .page-break {
      page-break-after: always;
    }
  </style>


</head>
<body>


  <div class=" container">

    <div class="row" >

      <div class="col-12">


        <h1 class="text-center bg-success text-white"> {{ $users_info[0]['field_value'] }}'s  Info </h1>


        <table class="table ">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col">Field Name</th>
              <th scope="col">Value</th>
            </tr>
          </thead>



          <tbody>


            @for ($i = 0; $i < count($users_info); $i++)

            {{ $users_info[$i]['alias_field_name'] }}

            
            @if ( $users_info[$i]['field_name'] != 'social_network' && $users_info[$i]['field_name'] != 'number_of_children'   )

            <tr>
              <th scope="row">{{ $i+1 }}</th>
              <td>  {{ $users_info[$i]['alias_field_name'] }} </td>
              <td>  {{ $users_info[$i]['field_value'] }}   </td>
            </tr>

            @endif

            @endfor

          </tbody>
        </table>

      </div>


    </div>
  </div>




<!-- 
  <div>
    <h1 class="text-center bg-dark white text-white"> Hellow dear </h1> 
  </div>
 -->





  <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>

</body>
</html>