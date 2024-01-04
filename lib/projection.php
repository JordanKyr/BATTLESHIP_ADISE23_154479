<?php



function show_projection($token) {
    global $mysqli;

    
    $sql='select player_id as pid from players where token=?';
    $st = $mysqli->prepare($sql);
	$st->bind_param('s',$token);
    $st->execute();
	$res = $st->get_result();
    $plid= $res->fetch_assoc()['pid'];

                                                                    //παίρνω μόνο τα στοιχεία για τον έκαστο παίκτη
    $sql= 'select * from projection where player_id=?' ;
    $st = $mysqli->prepare($sql);
    $st->bind_param('i',$plid);
    $st->execute();
    $res= $st->get_result();

    header('Content-type: application/json');
    $json_obj1 =json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
    
    
    $plid=($plid==1)?$plid=2 : $plid=1;

    $sql2= 'select * from targets where player_id=?';
    $st2 = $mysqli->prepare($sql2);
    $st2->bind_param('i', $plid);
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
    $token='1';
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
        

        if(check_coord($s_name, $x_start, $y_start, $x_end, $y_end,$token )){
        

            if(check_size($s_name, $x_start, $y_start, $x_end, $y_end)){            //αν δεν υπάρχει λάθος στις τιμές συντεταγμένων και το μέγεθος του πλοίου συνέχισε

                        $placed_check = check_placed($s_name,$token);                           //έλεγχος αν ο παίκτης έχει τοποθετήσει το πλοίο ήδη
                            if($placed_check != null){
                                    header("HTTP/1.1 400 Bad Request");
                                    print json_encode(['errormesg'=>"Ship is already placed."]);    
                                    exit;}
                                                                                                    //loop για να βαλει ο παικτης ολα τα πλοια του.
                    
                                do_place($s_name, $x_start, $y_start, $x_end, $y_end, $token);

                    
                            }

                        }
 }
function hit_ship($x,$y,$token){
   
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
    if($status['game_stat']!='ships_placed') {
        header("HTTP/1.1 400 Bad Request");
        print json_encode(['errormesg'=>"Ships are not placed."]);
        exit;
    }
    if($status['p_turn']!=$player_no) {
        header("HTTP/1.1 400 Bad Request");
        print json_encode(['errormesg'=>"It is not your turn."]);
        exit;
    }
    

    if($x>10 || $x<1 || $y>10 || $y<1 ){          //εκτός ορίων
        header("HTTP/1.1 400 Bad Request");
        print json_encode(['errormesg'=>"Coordinates error: Out of Bounds."]);    
        return(false);     
        exit;}


    $hit_check = check_hit($x,$y,$token);   
    
                                        
                                                    //έλεγχος αν ο παίκτης έχει τοποθετήσει το πλοίο ήδη
    if($hit_check != 'not_specified'){
            header("HTTP/1.1 400 Bad Request");
            print json_encode(['errormesg'=>"Coordinates already used."]);    
            exit;}
       do_hit($x,$y,$token);                                                              //loop για να βαλει ο παικτης ολα τα πλοια του.

       
       $hit_check = check_hit($x,$y,$token);   
       
        if($hit_check!='hit'){
                                                //αν δεν έχει χτυπήσει στόχο, παίζει ο επόμενος αλλιώς συνεχίζει ο ίδιος παίκτης.
            next_player();
        }
        
        $win_check = check_win($token);

        if($win_check == 3 ){                       //αν έχει 17 χτυπήματα -> έχει χτυπήσει όλα τα πλοία του αντιπάλου -> νικάει
       
         g_winner($token);


         exit;
        
        }



}

function do_hit($x,$y,$token){
    
                                        //καλώ την sql μέθοδο για το χτύπημα με τις συντεταγμένες και το token
    
    global $mysqli;
	$sql = 'call `hit_piece`(?,?,?);';
	$st = $mysqli->prepare($sql);
	$st->bind_param('iis',$x,$y,$token );
	$st->execute();

	
    show_projection($token);

}



?>