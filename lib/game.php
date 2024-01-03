<?php

function show_game_status() {
    global $mysqli;



    $sql= 'select * from game_status' ;
    $st = $mysqli->prepare($sql);

    $st->execute();
    $res= $st->get_result();

    header('Content-type: application/json');
    print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);

}



function update_game_status() {                 //enimerosi kai elegxos status
	global $mysqli;
	
	$sql = 'select * from game_status';
	$st = $mysqli->prepare($sql);

	$st->execute();
	$res = $st->get_result();
	$status = $res->fetch_assoc();
	
	
	$new_status=null;
	$new_turn=null;
	
	// $st3=$mysqli->prepare('select count(*) as aborted from players WHERE last_action< (NOW() - INTERVAL 5 MINUTE)');
	// $st3->execute();
	// $res3 = $st3->get_result();
	// $aborted = $res3->fetch_assoc()['aborted'];
	// if($aborted>0) {
	// 	$sql = 'UPDATE players SET username=NULL, token=NULL WHERE last_action< (now() - INTERVAL 5 MINUTE)';
	// 	$st2 = $mysqli->prepare($sql);
	// 	$st2->execute();
	// 	if($status['game_stat']=='started') {
	// 		$new_status='aborted';
	// 	}
	// }

	
	$sql = 'select count(*) as c from players where username is not null';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	$active_players = $res->fetch_assoc()['c'];
	
	
	switch($active_players) {
		case 0: $new_status='not active'; break;
		case 1: $new_status='initialized'; break;
		case 2: $new_status='started'; 
				if($status['p_turn']==null) {
					$new_turn='1'; // It was not started before...
				}
				break;
	}

	$sql = 'update game_status set game_stat=?, p_turn=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('ss',$new_status,$new_turn);
	$st->execute();
	
	
	
}       


function read_status() {

	
	global $mysqli;
	
	$sql = 'select * from game_status';
	$st = $mysqli->prepare($sql);

	$st->execute();
	$res = $st->get_result();
	$status = $res->fetch_assoc();
	return($status);
}


function placed_ships($token){
	
															//μέθοδος για να αλλάξει η κατάσταση του παιχνιδιού σε ships_placed όταν έχουν τοποθετηθεί όλα τα πλοία
	global $mysqli;											//και να ξεκινήσουν οι παίκτες τα χτυπήματα
	$sql = 'select p_turn as p from game_status';					
	$st = $mysqli->prepare($sql);
	$st->execute();										 //ελέγχω το game status και το ποιός παίκτης παίζει
	$res = $st->get_result();							//αν έχει καλέσει ο 2ος παίκητς την μέθοδο τότε σημαίνει ότι και οι δύο έχουν τοποθετήσει όλα τα πλοία τους.
	$old_player = $res->fetch_assoc()['p'];

	if($old_player=='1' ){
		next_player();
	
	}
	else {

			$new_status='ships_placed';

			$sql = 'update game_status set game_stat=?';
			$st = $mysqli->prepare($sql);
			$st->bind_param('s',$new_status);
			$st->execute();

			
			next_player();

	}

	show_game_status();
  

}

function next_player(){
	global $mysqli;										//μέθοδος για εναλλαγή παικτών
	$sql = 'select p_turn as p from game_status';		//ελέγχω με select ποιός είναι ο παίκτης τώρα και με το update αλλάζω στον επόμενο
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	$old_player = $res->fetch_assoc()['p'];

	$new_player=($old_player=='1') ? '2' : '1';
	$sql = 'update game_status set p_turn=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('s',$new_player);
	$st->execute();



	return($new_player);

}

?>