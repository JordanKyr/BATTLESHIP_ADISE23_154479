<?php



function show_projection($token) {
    global $mysqli;

    $test=1;
    // $sql='select player_id as pid from players where token=?';
    // $st = $mysqli->prepare($sql);
	// $st->bind_param('s',$test);
    // $st->execute();
	// $res = $st->get_result();
    // //$pid= $res->fetch_assoc()['pid'];

                                                                    //παίρνω μόνο τα στοιχεία για τον έκαστο παίκτη
    $sql= 'select * from projection where player_id=?' ;
    $st = $mysqli->prepare($sql);
    $st->bind_param('i',$test);
    $st->execute();
    $res= $st->get_result();

    header('Content-type: application/json');
    $json_obj1 =json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
    

    $sql2= 'select * from targets where player_id=?';
    $st2 = $mysqli->prepare($sql2);
    $st2->bind_param('i', $test);
    $st2->execute();
    $res2= $st2->get_result();

    header('Content-type: application/json');
    $json_obj2 =json_encode($res2->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);

    print $jsonmerged = json_encode(array_merge ( json_decode($json_obj1, true ), json_decode($json_obj2, true)   ));




}

function reset_game($token) {
    global $mysqli;

    $sql='call clean_all()';
    $mysqli->query($sql);
    show_projection($token);
}


function do_place($s_name, $x_start, $y_start, $x_end, $y_end, $token){
    global $mysqli;
	$sql = 'call `set_piece`(?,?,?,?,?,?);';
	$st = $mysqli->prepare($sql);
	$st->bind_param('siiiis',$s_name,$x_start,$y_start,$x_end,$y_end,$token );
	$st->execute();

	show_projection($token);


}

function place_ship($s_name, $x_start, $y_start, $x_end, $y_end, $token){


        if($token==null || $token=='') {
            header("HTTP/1.1 400 Bad Request");
            print json_encode(['errormesg'=>"token is not set."]);
            exit;
        }

        $player_no = current_player($token);
        if($player_no==null ) {
            header("HTTP/1.1 400 Bad Request");
            print json_encode(['errormesg'=>"You are not a player of this game."]);
            exit;
        }
        $status = read_status();
        if($status['game_stat']!='started') {
            header("HTTP/1.1 400 Bad Request");
            print json_encode(['errormesg'=>"Game is not in action."]);
            exit;
        }
        if($status['p_turn']!=$player_no) {
            header("HTTP/1.1 400 Bad Request");
            print json_encode(['errormesg'=>"It is not your turn."]);
            exit;
        }
        

        
        

        $placed_check = check_placed($s_name,$token);
            if($placed_check != null){
                    header("HTTP/1.1 400 Bad Request");
                    print json_encode(['errormesg'=>"Ship is already placed."]);    
                    exit;}
                                                                                    //loop για να βαλει ο παικτης ολα τα πλοια του.
       
                do_place($s_name, $x_start, $y_start, $x_end, $y_end, $token);
    
               }
      //  $orig_board=read_board();
       // $board=convert_board($orig_board);
       // $n = add_valid_moves_to_piece($board,$color,$x,$y);
        // if($n==0) {
        //     header("HTTP/1.1 400 Bad Request");
        //     print json_encode(['errormesg'=>"This piece cannot move."]);
        //     exit;
        // }
        // foreach($board[$x][$y]['moves'] as $i=>$move) {
        //     if($x2==$move['x'] && $y2==$move['y']) {
              
                // exit;
        //     }
        // }
        // header("HTTP/1.1 400 Bad Request");
        // print json_encode(['errormesg'=>"This move is illegal."]);
        // exit;







?>