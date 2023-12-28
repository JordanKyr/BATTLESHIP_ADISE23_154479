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
            case 'projection_id': // handle_piece($method, $request[0],$request[1],$input); 
                break;
            case 'player_id': //handle_player($method, $request[0],$input);
                 break;
            default: header("HTTP/1.1 404 Not Found"); break;
        } break; 
        
    case 'game_status': 
			if(sizeof($request)==0) {handle_game_status($method);}
			else {header("HTTP/1.1 404 Not Found");}
			break;
	
    case 'players': handle_players($method, $request,$input);
			    break;

        case 'ships': if(sizeof($request)==0) {handle_ships($method);}
        else {header("HTTP/1.1 404 Not Found");}
        break;


        default: 
        header("HTTP/1.1 404 Not Found");
        exit;

    }



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

 
    





?>