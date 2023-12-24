$( function() {
    draw_start_table();
    fill_projection();
});



function draw_start_table() {
	

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


function fill_projection() {

    
    $.ajax({
            type: 'GET',
            url: "battleships.php/projection/",
            success: fill_projection_by_data  
           
          }
            
     
    );
 

}

function fill_projection_by_data(data){


    for(var y=0; y<data.length; y++){
    
        var p = data[y];
        if(p.player_id==1 ){

     let i=y;

        for( ; i<100; i++)
        {
            
            var o = data[i];
            
           
            var id = '#square_' + o.x_p + '_' + o.y_p;
            var c = (o.cell_status=='1') ?  '1' :'';
            $(id).html(c);

        }
        }
    }
    

}