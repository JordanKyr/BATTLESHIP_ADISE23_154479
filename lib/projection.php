<?php



function show_projection() {
    global $mysqli;



    $sql= 'select * from projection' ;
    $st = $mysqli->prepare($sql);

    $st->execute();
    $res= $st->get_result();

    header('Content-type: application/json');
    print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);

}

function reset_game() {
    global $mysqli;

    $sql='call clean_all()';
    $mysqli->query($sql);
    show_projection();
}

?>