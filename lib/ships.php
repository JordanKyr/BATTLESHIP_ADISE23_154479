<?php

function show_ships() {
    global $mysqli;
                                        //επιστροφή πίνακα πλοίων



    $sql= 'select * from ships' ;
    $st = $mysqli->prepare($sql);

    $st->execute();
    $res= $st->get_result();

    header('Content-type: application/json');
    print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);

}

function check_coord($s_name, $x_start, $y_start, $x_end, $y_end,$token){       //έλεγχος μεταβλητών συντεταγμένων

    global $mysqli;
    
    $sql= 'select ship_size as s_size from ships where ship_name=? limit 1' ;
    $st = $mysqli->prepare($sql);                                           //παίρνω το μέγεθος του πλοίου
    $st->bind_param('s',$s_name);
    $st->execute();
    $res= $st->get_result();
    $s_size=$res->fetch_assoc()['s_size'];

    $sql='select player_id as pid from players where token=?';
    $st = $mysqli->prepare($sql);                                      //παίρνω τον παίκτη
	$st->bind_param('s',$token);
    $st->execute();
	$res = $st->get_result();
    $plid= $res->fetch_assoc()['pid'];


    if($x_start==$x_end && $y_start==$y_end)
    {
        header("HTTP/1.1 400 Bad Request");                                     //μέγεθος=1 λάθος
        print json_encode(['errormesg'=>"Coordinates error: Wrong Size."]);
        return(false);     
        exit;
    }

    if($x_start>$x_end || $y_start>$y_end){                     
        header("HTTP/1.1 400 Bad Request");                                                 //συντεταγμένες αρχής μικρότερες απο συντεταγμένες τέλους
        print json_encode(['errormesg'=>"Coordinates error: Start x|y < End x|y!"]);    
        return(false);     
        exit;
    }

    if($x_start>10 || $x_start<1 || $x_end>10 || $x_end<1 || $y_start>10 || $y_start<1 || $y_end>10 || $y_end<1 ){          //εκτός ορίων
        header("HTTP/1.1 400 Bad Request");
        print json_encode(['errormesg'=>"Coordinates error: Out of Bounds."]);    
        return(false);     
        exit;

    }

    if($x_start!=$x_end && $y_start!=$y_end)
    {
        header("HTTP/1.1 400 Bad Request");                                     //δεν πατάει σε άξονα
        print json_encode(['errormesg'=>"Coordinates error: No X or Y Axis."]);
        return(false);     
        exit;
    }
            
                                                            //sql έλεγχος αν τα κελιά σε κάθε άξονα είναι ελεύθερα για να τοποθετηθεί το πλοίο


    $c_stat_x=null;
    $count_x=0;
    $c_stat_y=null;
    $count_y=0;


                                                                                    //έλεγχος για άδεια κελιά ανά γραμμή
            while( $c_stat_x!=1 && $count_x < ($x_end - $x_start + 1) ){
                $sum_count_start_x= $count_x+$x_start;

                $sql= 'select cell_status as c_stat from projection where x_p=? and y_p=? and player_id=?';
                $st = $mysqli->prepare($sql);                                          
                $st->bind_param('iii',$sum_count_start_x,$y_start,$plid);
                $st->execute();
                $res= $st->get_result();
                $c_stat_x=$res->fetch_assoc()['c_stat'];
              
                $count_x= $count_x+1;

            }
                                                                                            //έλεγχος για άδεια κελιά ανα στύλη
            while( $c_stat_y!=1 && $count_y < ($y_end - $y_start + 1) ){
                $sum_count_start_y= $count_y+$y_start;
                $sql= 'select cell_status as c_stat from projection where y_p=? and x_p=? and player_id=?';
                $st = $mysqli->prepare($sql);                                          
                $st->bind_param('iii', $sum_count_start_y,$x_start,$plid);
                $st->execute();
                $res= $st->get_result();
                $c_stat_y=$res->fetch_assoc()['c_stat'];
                $count_y= $count_y+1;

            }
   

        if($c_stat_x==1 ||  $c_stat_y==1) {
            header("HTTP/1.1 400 Bad Request");                                     //υπάρχει ήδη πλοίο στο σημέιο αυτό
            print json_encode(['errormesg'=>"Coordinates error: Place Occupied."]);
                return(false);     
                exit;

        }


return(true);


}

function check_size($s_name, $x_start, $y_start, $x_end, $y_end){           //έλεγχος μεγέθους πλοίου με τις συντεταγμένες
    global $mysqli;
    
    $sql= 'select ship_size as s_size from ships where ship_name=? limit 1' ;
    $st = $mysqli->prepare($sql);
    $st->bind_param('s',$s_name);                                                 //παίρνω το μέγεθος του πλοίου
    $st->execute();
    $res= $st->get_result();
    $s_size=$res->fetch_assoc()['s_size'];

    if($x_start==$x_end && ($y_end-$y_start!=$s_size-1)  ){                   //λάθος μέγεθος πλοίου άξονας Χ
        header("HTTP/1.1 400 Bad Request");                                                     
        print json_encode(['errormesg'=>"Coordinates error: Wrong Ship Size."]);    
        return(false);     
        exit;
    }
    if($y_start==$y_end && ($x_end-$x_start!=$s_size-1) ){           //λάθος μέγεθος πλοίου άξονας Υ
        header("HTTP/1.1 400 Bad Request");
        print json_encode(['errormesg'=>"Coordinates error: Wrong Ship Size."]);    
        return(false);     
        exit;
    }

    return(true);


}

function check_placed($s_name, $token) {
                                                                //μέθοδος ελέγχου αν το πλοίο έχει τοποθετηθεί
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


function check_hit($x, $y, $token){                      //έλεγχος αν έχουν χρησιμοποιηθεί οι συντεταγμένες
    global $mysqli;

   

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

    return($hitcheck_result);


}

function check_win($token){                      //έλεγχος αν έχουν χρησιμοποιηθεί οι συντεταγμένες
    global $mysqli;

   

    $sql='select player_id as pid from players where token=?';
    $st = $mysqli->prepare($sql);                                       //παίρνω τον παίκτη
	$st->bind_param('s',$token);
    $st->execute();
	$res = $st->get_result();
    $plid= $res->fetch_assoc()['pid'];
    
    $plid=($plid==1)?$plid=2 : $plid=1;

    $sql='select count(*) as hit_count from targets where player_id=? and target_status="hit"';         //μετράω και επιστρέφω πόσα χτυπήματα έχει πετύχει
    $st = $mysqli->prepare($sql);
    $st->bind_param('i',$plid);
    $st->execute();
	$res = $st->get_result();
    $wincheck_result= $res->fetch_assoc()['hit_count'];

    return($wincheck_result);


}




?>