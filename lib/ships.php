<?php

function show_ships() {
    global $mysqli;
    //window.alert('show ships');



    $sql= 'select * from ships' ;
    $st = $mysqli->prepare($sql);

    $st->execute();
    $res= $st->get_result();

    header('Content-type: application/json');
    print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);

}

function check_placed($s_name, $token) {
                                                                //μέθοδος ελέγχου αν το πλοίοι έχει τοποθετηθεί
global $mysqli;

    $sql='select player_id as pid from players where token=?';
    $st = $mysqli->prepare($sql);
	$st->bind_param('s',$token);
    $st->execute();
	$res = $st->get_result();
    $plid= $res->fetch_assoc()['pid'];


	
    $sql = 'select * from ships where ship_name=? and player_id=?';
	$st = $mysqli->prepare($sql);
    $st->bind_param('si', $s_name, $plid);
	$st->execute();
	$res = $st->get_result();
	
    if($row=$res->fetch_assoc()) {
		return($row['start_row']);
	}return null;
}


function check_hit($x, $y, $token){
    global $mysqli;

    $hitcheck_result = null;

    $sql='select player_id as pid from players where token=?';
    $st = $mysqli->prepare($sql);
	$st->bind_param('s',$token);
    $st->execute();
	$res = $st->get_result();
    $plid= $res->fetch_assoc()['pid'];
    
    $plid=($plid==1)?$plid=2 : $plid=1;

    $sql='select target_status as t_stat from targets where player_id=? and x_t=? and y_t=?';
    $st = $mysqli->prepare($sql);
    $st->bind_param('iii',$plid,$x, $y);
    $st->execute();
	$res = $st->get_result();
    $hitcheck_result= $res->fetch_assoc()['t_stat'];

    return $hitcheck_result;


}

?>