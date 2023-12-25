$( function() {
    draw_start_table();
    fill_projection();
    $('#projection_reset').click(reset_projection);

});



function draw_start_table() {
	
    var t2='<table id="table_target">';
	for(var i=1; i<=10 ; i++) {

		t2 += '<tr>';
		for(var j=1; j<=10; j++ ) {
			t2 += '<td class="table_square_target" id="square_target_'+i+'_'+j+'">' + i +','+j+'</td>'; 
		}
		t2+='</tr>';
	}
	t2+='</table>';
	
	$('#target').html(t2);


	var t='<table id="game_table">';
	for(var i=1; i<=10 ; i++) {

		t += '<tr>';
		for(var j=1; j<=10; j++ ) {
			t += '<td class="table_square" id="square_'+i+'_'+j+'">' + i +','+j+'</td>'; 
		}
		t+='</tr>';
	}
	t+='</table>';
	
	$('#projection').html(t);




}

function reset_projection(){
    $.ajax({
        type: 'POST',
        url: "battleships.php/projection/",
        success: fill_projection_by_data  
       
      });

}


function fill_projection() {

    
    $.ajax({
            type: 'GET',
            url: "battleships.php/projection/",
            success: fill_projection_by_data  
           
          }
            
     
    );
 

}

function fill_projection_by_data(data){

    

    var projection_array=data.slice(0,200);
                                         //pairno se enan pinaka ta projection kai se allon ta targets

    var targets_array=data.slice(200,400);
  

    for(var y=0; y<projection_array.length; y++){
    
        var p = projection_array[y];
        if(p.player_id==1 ){

     let i=y;

        for( ; i<100; i++)
        {
            
            var o = projection_array[i];
            
           
            var id = '#square_' + o.x_p + '_' + o.y_p;
            var c = (o.cell_status=='1') ?  '1' :'';
            $(id).html(c);

        }
        }
    }
    

    for(var y=0; y<targets_array.length; y++){
    
        var t = targets_array[y];
        if(t.target_id==2 ){

     let i=y;

        for( ; i<200; i++)
        {
            
            var o = targets_array[i];
            
                                                                                        //o 1 vlepei to target toy 2

            var id = '#square_target_' + o.x_t + '_' + o.y_t;
            //var c = (o.target_status=='not_specified') ?  '' :'1';

            var c =o.target_status;
            switch(c){
                case 'not_specified': $(id).html(''); 
                break;
                case 'hit':
                        $(id).html('<img src="./images/hit.png" alt="hit_image" ></img>') ;
                break;


                case 'miss': 
                         $(id).html('<img src="./images/miss.png" alt="miss_image" ></img>');
                break;
                default: 
                 $(id).html(''); break;

            }

           

        }
        }
    }

}