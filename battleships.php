<?php
$method = $_SERVER['REQUEST_METHOD'];
//$request = explode('/', trim($_SERVER['PATH_INFO'],'/’));
 $request = explode('/', trim($_SERVER['SCRIPT_NAME'],'/’)); 
// Σε περίπτωση που τρέχουμε php–S 

$input = json_decode(file_get_contents('php://input'),true);

print_r($_SERVER);
exit;

switch ($r=array_shift($request)) {
    case 'battleship' :
        switch ($b=array_shift($request)) {
            case '':
            case null: handle_board($method);break;
            case 'piece': handle_piece($method, $request[0],$request[1],$input); break;
            case 'players': handle_player($method, $request[0],$input); break;
            default: header("HTTP/1.1 404 Not Found"); break;
        } break; 
        
        default: 
        header("HTTP/1.1 404 Not Found");
        exit;


?>