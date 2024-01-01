//global metavlites

var me={};
var game_status={};

$( function() {
    draw_start_table();
    fill_projection();


    draw_ship_info_table();
    fill_ships();
    
    $('#do_place').click( do_place);


    $('#projection_reset').click(reset_projection);
    $('#battleships_login').click(login_to_game);
    $('#place_div').hide();


});

function draw_ship_info_table(){
    var t3='<table id="table_ship_info">';
    for(var i=1; i<=5; i++) {
        
        t3 += '<tr>';
        for(var j=1; j<=3; j++) {
            t3 += '<td class="table_ship_inform" id="square_info_'+i+'_'+j+'">'+i+','+j+'</td>';
        }
        t3+='</tr>';

    }
    t3+='</table>';
    $('#ships_info').html(t3);

    $('#square_info_1_1').html('<img src="./images/carrier.png" alt="hit_image" ></img>');
    $('#square_info_2_1').html('<img src="./images/battleship.png" alt="hit_image" ></img>');
    $('#square_info_3_1').html('<img src="./images/cruiser.png" alt="hit_image" ></img>');
    $('#square_info_4_1').html('<img src="./images/submarine.png" alt="hit_image" ></img>');
    $('#square_info_5_1').html('<img src="./images/destroyer.png" alt="hit_image" ></img>');


}


function fill_ships(){
    $.ajax({
        type: 'GET',
        url: "battleships.php/ships/",
        success: fill_ships_by_data  
       
      });

}


function fill_ships_by_data(data){


var i=1;
    for(var j=0; j<5; j++ ){
     var ship_info=data[j];





                    var id = '#square_info_' + i + '_2';
                   
                    $(id).html(ship_info.ship_name);

                    id='#square_info_'+ i +'_3';
                    $(id).html(ship_info.ship_size + ' spots' );

        i++;
                }

            
}


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
            
            
            if(o.cell_status=='1') {

                    switch(o.ship_name){
                        case 'Carrier': $(id).html('<img src="./images/carrier.png" alt="carrier_image" ></img>') ;  break;
                        case 'Battleship': $(id).html('<img src="./images/battleship.png" alt="battleship_image" ></img>') ;  break;
                        case 'Cruiser': $(id).html('<img src="./images/cruiser.png" alt="cruiser_image" ></img>') ;  break;
                        case 'Submarine': $(id).html('<img src="./images/submarine.png" alt="submarine_image" ></img>') ;  break;
                        case 'Destroyer': $(id).html('<img src="./images/destroyer.png" alt="destroyer_image" ></img>') ;  break;
                        default: $(id).html(''); break;
                    }

            }else { $(id).html('');}


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


function login_to_game() {
	if($('#username').val()=='') {
		alert('You have to set a username');
		return;
	}
	var p_id = $('#player_id').val();
	draw_start_table(p_id);
	fill_projection();
	
	$.ajax({
            type: 'PUT',
            url: "battleships.php/players/"+p_id, 
			
			dataType: "json",
			contentType: 'application/json',
			data: JSON.stringify( {username: $('#username').val(), player_id: p_id}),
			success: login_result,
			error: login_error});
}

function login_result(data) {
	me = data[0];
	$('#game_initializer').hide();
	update_info();
	game_status_update();
}

function login_error(data,y,z,c) {
	var x = data.responseJSON;
	alert(x.errormesg);
}

function update_info(){
	$('#game_info').html("I am Player: "+me.player_id+", my name is "+me.username +'<br>Token='+me.token+'<br>Game state: '+game_status.game_stat+', '+ game_status.p_turn+' must play now.');
	
}





function game_status_update() {
	$.ajax({url: "battleships.php/game_status/", success: update_status });
}

function update_status(data) {
	game_status=data[0];
	update_info();
	if(game_status.p_turn==me.player_id &&  me.player_id!=null) {
		x=0;
		// do play
		$('#place_div').show(500);
		setTimeout(function() { game_status_update();}, 15000);
	} else {
		// must wait for something
		$('#place_div').hide(500);
		setTimeout(function() { game_status_update();}, 4000);
	}
 	
}




function do_place() {
	var s = $('#place_ship').val();
	
	var a = s.trim().split(/[ ]+/);
    
	if(a.length!=5) {
		alert('Must give a ship name and 4 numbers');
		return;
	}
	$.ajax({url: "battleships.php/ships/ship_name/"+a[0], 
			type: 'PUT',
			dataType: "json",
			contentType: 'application/json',
			data: JSON.stringify( {start_row: a[1], start_col: a[2], end_row: a[3], end_col: a[4], token: me.token}),
			success: move_result,
			error: login_error});
	
}


function move_result(data) 
{
    fill_projection_by_data(data);
  

}