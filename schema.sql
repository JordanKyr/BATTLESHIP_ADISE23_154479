DROP TABLE IF EXISTS ships;
DROP TABLE IF EXISTS  game_status;
DROP TABLE IF EXISTS projection;
DROP TABLE IF EXISTS players;


CREATE TABLE players (                          /* pinakas paikton*/
    player_id tinyint(1)  NOT NULL,
    username VARCHAR(20) DEFAULT NULL,
    token VARCHAR(100) DEFAULT NULL,
    last_action TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY(player_id)

);







/*CREATE TABLE board (
        board_id tinyint(1)  NOT NULL,
        player_id tinyint(1) DEFAULT NULL,
        x tinyint(1) NOT NULL,
        y tinyint(1) NOT NULL,
        
        PRIMARY KEY (board_id, x, y),

        CONSTRAINT fk_type 
        FOREIGN KEY(player_id) 
        REFERENCES players(player_id)
); */


CREATE TABLE projection (                                       /*pinakas toy board kathe paikti*/
        projection_id tinyint(1) NOT NULL,
        player_id tinyint(1) DEFAULT NULL, 
        x_p tinyint(1) NOT NULL,
        y_p tinyint(1) NOT NULL,
        
        cell_status tinyint(1) DEFAULT NULL, 

        PRIMARY KEY(projection_id,x_p,y_p),

        CONSTRAINT fk_type2 
        FOREIGN KEY(player_id) 
        REFERENCES players(player_id)
        ON DELETE CASCADE 
    
);


CREATE TABLE game_status (                                                                                      /*pinakas katastasis paixnidiou*/
        game_stat ENUM('not active','initialized','started','ended','aborded') NOT NULL DEFAULT 'not active',
        p_turn ENUM('1','2') DEFAULT NULL,
        result ENUM('1','2') DEFAULT NULL,
        last_change TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
);

INSERT INTO game_status(game_stat,p_turn,result,last_change)  VALUE                     /*arxikopoiisi status paixnidiou*/
('not active','1', NULL, NULL); 

INSERT INTO players(player_id,username,token,last_action) VALUES                        /*eisagogi paikton ston pinaka, to paixnidi paizetai apo 2 paiktes*/
                (1,'protos',NULL,NULL), 
                (2, 'deuteros',NULL,NULL);


CREATE TABLE ships (                                                                    /*pinakas karavion, ton onomaton kai ton xaraktiristikon tous*/
        ship_id tinyint(1) NOT NULL AUTO_INCREMENT,
        player_id tinyint(1) DEFAULT NULL,
        ship_name VARCHAR(100) DEFAULT NULL,
        ship_size tinyint(1) DEFAULT NULL,
        start_row tinyint(1) DEFAULT NULL,
        end_row tinyint(1) DEFAULT NULL,
        start_col tinyint(1) DEFAULT NULL,
        end_col tinyint(1) DEFAULT NULL,
        PRIMARY KEY(ship_id),

        CONSTRAINT fk_type3
        FOREIGN KEY(player_id)
        REFERENCES players(player_id)
        ON DELETE CASCADE 
);

INSERT INTO ships(player_id,ship_name,ship_size,start_row,end_row,start_col,end_col) VALUES             /*arxikopoisi pinaka ploion*/
                (1, "Carrier", 5 , NULL, NULL, NULL,NULL ),
                (2, "Carrier", 5 , NULL, NULL, NULL,NULL),
                (1, "Battleship", 4 , NULL, NULL, NULL,NULL ),
                (2, "Battleship", 4 , NULL, NULL, NULL,NULL ),
                (1, "Cruiser", 3 , NULL, NULL, NULL,NULL ),
                (2, "Cruiser", 3 , NULL, NULL, NULL,NULL ),
                (1, "Submarine", 3 , NULL, NULL, NULL,NULL ),
                (2, "Submarine", 3 , NULL, NULL, NULL,NULL ),
                (1, "Niki", 2 , NULL, NULL, NULL,NULL ),
                (2, "Niki", 2 , NULL, NULL, NULL,NULL );

                







/*
INSERT INTO board(board_id, player_id, x, y) VALUES
                            (1, 1, 1, 1),
                            (1, 1, 2, 1),
                            (1, 1, 3, 1),
                            (1, 1, 4, 1),
                            (1, 1, 5, 1),
                            (1, 1, 6, 1),
                            (1, 1, 7, 1),
                            (1, 1, 8, 1),
                            (1, 1, 9, 1),
                            (1, 1, 10, 1),
                            (1, 1, 1, 2),
                            (1, 1, 2, 2),
                            (1, 1, 3, 2),
                            (1, 1, 4, 2),
                            (1, 1, 5, 2),
                            (1, 1, 6, 2),
                            (1, 1, 7, 2),
                            (1, 1, 8, 2),
                            (1, 1, 9, 2),
                            (1, 1, 10, 2),
                            (1, 1, 1, 3),
                            (1, 1, 2, 3),
                            (1, 1, 3, 3),
                            (1, 1, 4, 3),
                            (1, 1, 5, 3),
                            (1, 1, 6, 3),
                            (1, 1, 7, 3),
                            (1, 1, 8, 3),
                            (1, 1, 9, 3),
                            (1, 1, 10, 3),
                            (1, 1, 1, 4),
                            (1, 1, 2, 4),
                            (1, 1, 3, 4),
                            (1, 1, 4, 4),
                            (1, 1, 5, 4),
                            (1, 1, 6, 4),
                            (1, 1, 7, 4),
                            (1, 1, 8, 4),
                            (1, 1, 9, 4),
                            (1, 1, 10, 4),
                            (1, 1, 1, 5),
                            (1, 1, 2, 5),
                            (1, 1, 3, 5),
                            (1, 1, 4, 5),
                            (1, 1, 5, 5),
                            (1, 1, 6, 5),
                            (1, 1, 7, 5),
                            (1, 1, 8, 5),
                            (1, 1, 9, 5),
                            (1, 1, 10, 5),
                            (1, 1, 1, 6),
                            (1, 1, 2, 6),
                            (1, 1, 3, 6),
                            (1, 1, 4, 6),
                            (1, 1, 5, 6),
                            (1, 1, 6, 6),
                            (1, 1, 7, 6),
                            (1, 1, 8, 6),
                            (1, 1, 9, 6),
                            (1, 1, 10, 6),
                            (1, 1, 1, 7),
                            (1, 1, 2, 7),
                            (1, 1, 3, 7),
                            (1, 1, 4, 7),
                            (1, 1, 5, 7),
                            (1, 1, 6, 7),
                            (1, 1, 7, 7),
                            (1, 1, 8, 7),
                            (1, 1, 9, 7),
                            (1, 1, 10, 7),
                            (1, 1, 1, 8),
                            (1, 1, 2, 8),
                            (1, 1, 3, 8),
                            (1, 1, 4, 8),
                            (1, 1, 5, 8),
                            (1, 1, 6, 8),
                            (1, 1, 7, 8),
                            (1, 1, 8, 8),
                            (1, 1, 9, 8),
                            (1, 1, 10, 8),
                            (1, 1, 1, 9),
                            (1, 1, 2, 9),
                            (1, 1, 3, 9),
                            (1, 1, 4, 9),
                            (1, 1, 5, 9),
                            (1, 1, 6, 9),
                            (1, 1, 7, 9),
                            (1, 1, 8, 9),
                            (1, 1, 9, 9),
                            (1, 1, 10, 9),
                            (1, 1, 1, 10),
                            (1, 1, 2, 10),
                            (1, 1, 3, 10),
                            (1, 1, 4, 10),
                            (1, 1, 5, 10),
                            (1, 1, 6, 10),
                            (1, 1, 7, 10),
                            (1, 1, 8, 10),
                            (1, 1, 9, 10),
                            (1, 1, 10, 10),

                            (2, 2, 1, 1),
                            (2, 2, 2, 1),
                            (2, 2, 3, 1),
                            (2, 2, 4, 1),
                            (2, 2, 5, 1),
                            (2, 2, 6, 1),
                            (2, 2, 7, 1),
                            (2, 2, 8, 1),
                            (2, 2, 9, 1),
                            (2, 2, 10, 1),
                            (2, 2, 1, 2),
                            (2, 2, 2, 2),
                            (2, 2, 3, 2),
                            (2, 2, 4, 2),
                            (2, 2, 5, 2),
                            (2, 2, 6, 2),
                            (2, 2, 7, 2),
                            (2, 2, 8, 2),
                            (2, 2, 9, 2),
                            (2, 2, 10, 2),
                            (2, 2, 1, 3),
                            (2, 2, 2, 3),
                            (2, 2, 3, 3),
                            (2, 2, 4, 3),
                            (2, 2, 5, 3),
                            (2, 2, 6, 3),
                            (2, 2, 7, 3),
                            (2, 2, 8, 3),
                            (2, 2, 9, 3),
                            (2, 2, 10, 3),
                            (2, 2, 1, 4),
                            (2, 2, 2, 4),
                            (2, 2, 3, 4),
                            (2, 2, 4, 4),
                            (2, 2, 5, 4),
                            (2, 2, 6, 4),
                            (2, 2, 7, 4),
                            (2, 2, 8, 4),
                            (2, 2, 9, 4),
                            (2, 2, 10, 4),
                            (2, 2, 1, 5),
                            (2, 2, 2, 5),
                            (2, 2, 3, 5),
                            (2, 2, 4, 5),
                            (2, 2, 5, 5),
                            (2, 2, 6, 5),
                            (2, 2, 7, 5),
                            (2, 2, 8, 5),
                            (2, 2, 9, 5),
                            (2, 2, 10, 5),
                            (2, 2, 1, 6),
                            (2, 2, 2, 6),
                            (2, 2, 3, 6),
                            (2, 2, 4, 6),
                            (2, 2, 5, 6),
                            (2, 2, 6, 6),
                            (2, 2, 7, 6),
                            (2, 2, 8, 6),
                            (2, 2, 9, 6),
                            (2, 2, 10, 6),
                            (2, 2, 1, 7),
                            (2, 2, 2, 7),
                            (2, 2, 3, 7),
                            (2, 2, 4, 7),
                            (2, 2, 5, 7),
                            (2, 2, 6, 7),
                            (2, 2, 7, 7),
                            (2, 2, 8, 7),
                            (2, 2, 9, 7),
                            (2, 2, 10, 7),
                            (2, 2, 1, 8),
                            (2, 2, 2, 8),
                            (2, 2, 3, 8),
                            (2, 2, 4, 8),
                            (2, 2, 5, 8),
                            (2, 2, 6, 8),
                            (2, 2, 7, 8),
                            (2, 2, 8, 8),
                            (2, 2, 9, 8),
                            (2, 2, 10, 8),
                            (2, 2, 1, 9),
                            (2, 2, 2, 9),
                            (2, 2, 3, 9),
                            (2, 2, 4, 9),
                            (2, 2, 5, 9),
                            (2, 2, 6, 9),
                            (2, 2, 7, 9),
                            (2, 2, 8, 9),
                            (2, 2, 9, 9),
                            (2, 2, 10, 9),
                            (2, 2, 1, 10),
                            (2, 2, 2, 10),
                            (2, 2, 3, 10),
                            (2, 2, 4, 10),
                            (2, 2, 5, 10),
                            (2, 2, 6, 10),
                            (2, 2, 7, 10),
                            (2, 2, 8, 10),
                            (2, 2, 9, 10),
                            (2, 2, 10, 10);
*/

INSERT INTO projection(projection_id, player_id, x_p, y_p, cell_status) VALUES                                                  /*dimiourgia ton board ton 2 paikton*/
                                (1, 1, 1, 1, NULL),
                                (1, 1, 2, 1, NULL),
                                (1, 1, 3, 1, NULL),
                                (1, 1, 4, 1, NULL),
                                (1, 1, 5, 1, NULL),
                                (1, 1, 6, 1, NULL),
                                (1, 1, 7, 1, NULL),
                                (1, 1, 8, 1, NULL),
                                (1, 1, 9, 1, NULL),
                                (1, 1, 10, 1, NULL),
                                (1, 1, 1, 2, NULL),
                                (1, 1, 2, 2, NULL),
                                (1, 1, 3, 2, NULL),
                                (1, 1, 4, 2, NULL),
                                (1, 1, 5, 2, NULL),
                                (1, 1, 6, 2, NULL),
                                (1, 1, 7, 2, NULL),
                                (1, 1, 8, 2, NULL),
                                (1, 1, 9, 2, NULL),
                                (1, 1, 10, 2, NULL),
                                (1, 1, 1, 3, NULL),
                                (1, 1, 2, 3, NULL),
                                (1, 1, 3, 3, NULL),
                                (1, 1, 4, 3, NULL),
                                (1, 1, 5, 3, NULL),
                                (1, 1, 6, 3, NULL),
                                (1, 1, 7, 3, NULL),
                                (1, 1, 8, 3, NULL),
                                (1, 1, 9, 3, NULL),
                                (1, 1, 10, 3, NULL),
                                (1, 1, 1, 4, NULL),
                                (1, 1, 2, 4, NULL),
                                (1, 1, 3, 4, NULL),
                                (1, 1, 4, 4, NULL),
                                (1, 1, 5, 4, NULL),
                                (1, 1, 6, 4, NULL),
                                (1, 1, 7, 4, NULL),
                                (1, 1, 8, 4, NULL),
                                (1, 1, 9, 4, NULL),
                                (1, 1, 10, 4, NULL),
                                (1, 1, 1, 5, NULL),
                                (1, 1, 2, 5, NULL),
                                (1, 1, 3, 5, NULL),
                                (1, 1, 4, 5, NULL),
                                (1, 1, 5, 5, NULL),
                                (1, 1, 6, 5, NULL),
                                (1, 1, 7, 5, NULL),
                                (1, 1, 8, 5, NULL),
                                (1, 1, 9, 5, NULL),
                                (1, 1, 10, 5, NULL),
                                (1, 1, 1, 6, NULL),
                                (1, 1, 2, 6, NULL),
                                (1, 1, 3, 6, NULL),
                                (1, 1, 4, 6, NULL),
                                (1, 1, 5, 6, NULL),
                                (1, 1, 6, 6, NULL),
                                (1, 1, 7, 6, NULL),
                                (1, 1, 8, 6, NULL),
                                (1, 1, 9, 6, NULL),
                                (1, 1, 10, 6, NULL),
                                (1, 1, 1, 7, NULL),
                                (1, 1, 2, 7, NULL),
                                (1, 1, 3, 7, NULL),
                                (1, 1, 4, 7, NULL),
                                (1, 1, 5, 7, NULL),
                                (1, 1, 6, 7, NULL),
                                (1, 1, 7, 7, NULL),
                                (1, 1, 8, 7, NULL),
                                (1, 1, 9, 7, NULL),
                                (1, 1, 10, 7, NULL),
                                (1, 1, 1, 8, NULL),
                                (1, 1, 2, 8, NULL),
                                (1, 1, 3, 8, NULL),
                                (1, 1, 4, 8, NULL),
                                (1, 1, 5, 8, NULL),
                                (1, 1, 6, 8, NULL),
                                (1, 1, 7, 8, NULL),
                                (1, 1, 8, 8, NULL),
                                (1, 1, 9, 8, NULL),
                                (1, 1, 10, 8, NULL),
                                (1, 1, 1, 9, NULL),
                                (1, 1, 2, 9, NULL),
                                (1, 1, 3, 9, NULL),
                                (1, 1, 4, 9, NULL),
                                (1, 1, 5, 9, NULL),
                                (1, 1, 6, 9, NULL),
                                (1, 1, 7, 9, NULL),
                                (1, 1, 8, 9, NULL),
                                (1, 1, 9, 9, NULL),
                                (1, 1, 10, 9, NULL),
                                (1, 1, 1, 10, NULL),
                                (1, 1, 2, 10, NULL),
                                (1, 1, 3, 10, NULL),
                                (1, 1, 4, 10, NULL),
                                (1, 1, 5, 10, NULL),
                                (1, 1, 6, 10, NULL),
                                (1, 1, 7, 10, NULL),
                                (1, 1, 8, 10, NULL),
                                (1, 1, 9, 10, NULL),
                                (1, 1, 10, 10, NULL),

                                (2, 2, 1, 1, NULL),
                                (2, 2, 2, 1, NULL),
                                (2, 2, 3, 1, NULL),
                                (2, 2, 4, 1, NULL),
                                (2, 2, 5, 1, NULL),
                                (2, 2, 6, 1, NULL),
                                (2, 2, 7, 1, NULL),
                                (2, 2, 8, 1, NULL),
                                (2, 2, 9, 1, NULL),
                                (2, 2, 10, 1, NULL),
                                (2, 2, 1, 2, NULL),
                                (2, 2, 2, 2, NULL),
                                (2, 2, 3, 2, NULL),
                                (2, 2, 4, 2, NULL),
                                (2, 2, 5, 2, NULL),
                                (2, 2, 6, 2, NULL),
                                (2, 2, 7, 2, NULL),
                                (2, 2, 8, 2, NULL),
                                (2, 2, 9, 2, NULL),
                                (2, 2, 10, 2, NULL),    
                                (2, 2, 1, 3, NULL),
                                (2, 2, 2, 3, NULL),
                                (2, 2, 3, 3, NULL),
                                (2, 2, 4, 3, NULL),
                                (2, 2, 5, 3, NULL),
                                (2, 2, 6, 3, NULL),
                                (2, 2, 7, 3, NULL),
                                (2, 2, 8, 3, NULL),
                                (2, 2, 9, 3, NULL),
                                (2, 2, 10, 3, NULL),
                                (2, 2, 1, 4, NULL),
                                (2, 2, 2, 4, NULL),
                                (2, 2, 3, 4, NULL),
                                (2, 2, 4, 4, NULL),
                                (2, 2, 5, 4, NULL),
                                (2, 2, 6, 4, NULL),
                                (2, 2, 7, 4, NULL),
                                (2, 2, 8, 4, NULL),
                                (2, 2, 9, 4, NULL),
                                (2, 2, 10, 4, NULL),
                                (2, 2, 1, 5, NULL),
                                (2, 2, 2, 5, NULL),
                                (2, 2, 3, 5, NULL),
                                (2, 2, 4, 5, NULL),
                                (2, 2, 5, 5, NULL),
                                (2, 2, 6, 5, NULL),
                                (2, 2, 7, 5, NULL),
                                (2, 2, 8, 5, NULL),
                                (2, 2, 9, 5, NULL),
                                (2, 2, 10, 5, NULL),
                                (2, 2, 1, 6, NULL),
                                (2, 2, 2, 6, NULL),
                                (2, 2, 3, 6, NULL),
                                (2, 2, 4, 6, NULL),
                                (2, 2, 5, 6, NULL),
                                (2, 2, 6, 6, NULL),
                                (2, 2, 7, 6, NULL),
                                (2, 2, 8, 6, NULL),
                                (2, 2, 9, 6, NULL),
                                (2, 2, 10, 6, NULL),
                                (2, 2, 1, 7, NULL),
                                (2, 2, 2, 7, NULL),
                                (2, 2, 3, 7, NULL),
                                (2, 2, 4, 7, NULL),
                                (2, 2, 5, 7, NULL),
                                (2, 2, 6, 7, NULL),
                                (2, 2, 7, 7, NULL),
                                (2, 2, 8, 7, NULL),
                                (2, 2, 9, 7, NULL),
                                (2, 2, 10, 7, NULL),
                                (2, 2, 1, 8, NULL),
                                (2, 2, 2, 8, NULL),
                                (2, 2, 3, 8, NULL),
                                (2, 2, 4, 8, NULL),
                                (2, 2, 5, 8, NULL),
                                (2, 2, 6, 8, NULL),
                                (2, 2, 7, 8, NULL),
                                (2, 2, 8, 8, NULL),
                                (2, 2, 9, 8, NULL),
                                (2, 2, 10, 8, NULL),
                                (2, 2, 1, 10, NULL),
                                (2, 2, 2, 10, NULL),
                                (2, 2, 3, 10, NULL),
                                (2, 2, 4, 10, NULL),
                                (2, 2, 5, 10, NULL),
                                (2, 2, 6, 10, NULL),
                                (2, 2, 7, 10, NULL),
                                (2, 2, 8, 10, NULL),
                                (2, 2, 9, 10, NULL),
                                (2, 2, 10, 10, NULL);


DROP PROCEDURE IF EXISTS set_piece;
                                                                                                                                /*procedure gia tin topothetisi ton ploion*/
DELIMITER //
        CREATE PROCEDURE set_piece(s_id tinyint, p_id tinyint, start_x tinyint, end_x tinyint, start_y tinyint, end_y tinyint)
        BEGIN 
              DECLARE outofbounds, place_occupied VARCHAR(255);        
              DECLARE c_stat tinyint(1); 
              SELECT cell_status INTO c_stat FROM projection
              WHERE  x_p=start_x AND y_p=start_y AND player_id=p_id;

                                                                                        /*elegxos gia lathos timon theseon ploion*/
              SET outofbounds='Ouf of Bounds.';
              SET place_occupied='Ship Already There.';  

                IF (start_x < 1 OR start_x > 10 OR end_x < 1 OR end_x > 10 OR start_y < 1 OR start_y > 10 OR end_y < 1 OR end_y > 10 )THEN
                SELECT CONCAT('ERROR: ', outofbounds) ;
                
                ELSEIF (c_stat IS NOT NULL) THEN
                SELECT CONCAT('ERROR: ', place_occupied);

                ELSE 
                UPDATE ships
                set start_row=start_x, end_row=end_x,start_col=start_y, end_col=end_y                                                 /*enimerosi thesis ploiou kai game status*/
                where ship_id=s_id and player_id=p_id;
 
                END IF; 

                UPDATE game_status set p_turn=if(p_turn='1','2','1'); 
                UPDATE projection set cell_status=1 WHERE x_p=start_x AND y_p=start_y;
                END//
DELIMITER ;

/*

CALL set_piece(1,1,2,2,2,6);

*/

/*
 ELSE IF (select start_row, start_col, end_row, end_col from ships 
					 				WHERE start_row IS NOT NULL AND start_col IS NOT NULL
									 AND end_row IS NOT NULL AND end_col IS NOT NULL
									 AND player_id=p_id ) THEN
*/                                                                         