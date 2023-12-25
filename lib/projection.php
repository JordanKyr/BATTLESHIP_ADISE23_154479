<?php



function show_projection() {
    global $mysqli;



    $sql= 'select * from projection' ;
    $st = $mysqli->prepare($sql);

    $st->execute();
    $res= $st->get_result();

    header('Content-type: application/json');
    $json_obj1 =json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
    

    $sql2= 'select * from targets' ;
    $st2 = $mysqli->prepare($sql2);

    $st2->execute();
    $res2= $st2->get_result();

    header('Content-type: application/json');
    $json_obj2 =json_encode($res2->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);

    print $jsonmerged = json_encode(array_merge ( json_decode($json_obj1, true ), json_decode($json_obj2, true)   ));




}

function reset_game() {
    global $mysqli;

    $sql='call clean_all()';
    $mysqli->query($sql);
    show_projection();
}

?>