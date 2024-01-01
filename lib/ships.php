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

function check_placed($s_name) {

	global $mysqli;
    $sql = 'select * from ships where ship_name=?';
	$st = $mysqli->prepare($sql);
    $st->bind_param('s', $s_name);
	$st->execute();
	$res = $st->get_result();
	
    if($row=$res->fetch_assoc()) {
		return($row['start_row']);
	}return null;
}

?>