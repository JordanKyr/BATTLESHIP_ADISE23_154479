<?php

require_once "../lib/projection.php";
require_once "../lib/dbconnect.php";
require_once "../lib/game.php";
require_once "../lib/users.php";
require_once "../lib/ships.php";

$method = $_SERVER['REQUEST_METHOD'];

$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
 // $request = explode('/', trim($_SERVER['SCRIPT_NAME'],'/')); 
// Σε περίπτωση που τρέχουμε php–S 

$input = json_decode(file_get_contents('php://input'),true);


switch ($r=array_shift($request)) {
    
    case 'projection' :
        switch ($b=array_shift($request)) {
            case '':
            case null: handle_projection($method); 
                break;
            
            default: header("HTTP/1.1 404 Not Found"); break;
        } break; 
        
    case 'game_status': 
			if(sizeof($request)==0) {handle_game_status($method);}
			else {header("HTTP/1.1 404 Not Found");}
			break;
	
    case 'players': handle_players($method, $request,$input);
			    break;

    case 'ships': 
            switch ($c=array_shift($request)) {
                case '':
                case null: handle_ships($method); 
                    break;
                case 'ship_name': handle_ship_name($method,$request[0],  $input);
                    break;
                default: header("HTTP/1.1 404 Not Found"); break; }
        break;}



    function handle_projection($method) {
        if($method=='GET') {
                show_projection();
               

        } else if ($method=='POST') {
                reset_game();
        } else {
            header('HTTP/1.1 405 Method Not Allowed');
        }
        
    }

    function handle_game_status($method) {
        if($method=='GET') {
            show_game_status();
        } else {
            header('HTTP/1.1 405 Method Not Allowed');
        }
    }


    function handle_ships($method) {

        if($method=='GET') {
            show_ships();
        } else {
            header('HTTP/1.1 405 Method Not Allowed');
        }


    }

    function handle_players($method, $p,$input) {
        switch ($b=array_shift($p)) {
        //	case '':
        //	case null: if($method=='GET') {show_users($method);}
        //			   else {header("HTTP/1.1 400 Bad Request"); 
        //					 print json_encode(['errormesg'=>"Method $method not allowed here."]);}
        //                break;
            case '1': 
            case '2': handle_user($method, $b,$input);
                        break;
            default: header("HTTP/1.1 404 Not Found");
                     print json_encode(['errormesg'=>"Player $b not found."]);
                     break;
        }
    }

 
    function handle_ship_name($method,$ship_name, $input){
   
        if ($method=='PUT'){
            place_ship($ship_name, $input['start_row'], $input['start_col'], $input['end_row'], $input['end_col'], $input['token']  );
        }
 



    }
    





?>