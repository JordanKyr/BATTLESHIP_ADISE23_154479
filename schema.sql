-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.21-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;




-- Dumping structure for table battleships.game_status
DROP TABLE IF EXISTS `game_status`;
CREATE TABLE IF NOT EXISTS `game_status` (
  `game_id` tinyint(1) NOT NULL AUTO_INCREMENT,
  `game_stat` enum('not active','initialized','started','ships_placed','ended','aborded') NOT NULL DEFAULT 'not active',
  `p_turn` enum('1','2') DEFAULT NULL,
  `result` enum('1st Player Wins!','2nd Player Wins!') DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`game_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table battleships.game_status: ~1 rows (approximately)
INSERT INTO `game_status` (`game_id`, `game_stat`, `p_turn`, `result`, `last_change`) VALUES
	(1, 'not active', NULL, NULL, NULL);

-- Dumping structure for procedure battleships.hit_piece
DROP PROCEDURE IF EXISTS `hit_piece`;
DELIMITER //
CREATE PROCEDURE `hit_piece`(p_id tinyint, t_id tinyint, x tinyint, y tinyint)
BEGIN 
                DECLARE enemy_player, target_from_projection, win_check, turn_flag tinyint(1);
                DECLARE miss_cell, outofbounds, hit_cell, win_game, player_turn, winner VARCHAR(255);
                SET enemy_player=if(p_id=1, 2, 1);
               

                SET target_from_projection=NULL;
                SET miss_cell='Hit Missed, Cell was Empty.';                            
                SET outofbounds='Ouf of Bounds.';
                SET hit_cell='Hit!';
                SET win_game='You Have Won the Game!';
                SET win_check= 17;

            /*    SET turn_flag=0; */
             /*   SELECT p_turn_temp INTO player_turn FROM game_status;  pairno gia temp tin seira toy paikti poy paizei tora */
                


                IF (x < 1 OR x > 10 OR y < 1 OR y > 10 )THEN
                SELECT CONCAT('ERROR: ', outofbounds) ;
                
                ELSE 
                        BEGIN

                                SELECT cell_status INTO target_from_projection FROM projection
                                WHERE player_id=enemy_player AND x_p=x AND y_p=y ;                              
                                
/*HIT LOOP*/                                       

                                        IF (target_from_projection  IS NULL)THEN 
                                        BEGIN 
                                                SELECT CONCAT('Message: ',miss_cell);
                                                UPDATE targets                                                                        /*elegxoi gia an xtipise ploio*/
                                                SET target_status='miss'
                                                WHERE player_id=p_id AND target_id=t_id AND x_t=x AND y_t=y; 
                                                UPDATE game_status set p_turn=if(p_turn='1','2','1'); 
                                                
                                        END; 

                                        ELSE    
                                        BEGIN
                                                SELECT CONCAT('Message: ', hit_cell);
                                                UPDATE targets
                                                SET target_status='hit'
                                                WHERE player_id=p_id AND target_id=t_id AND x_t=x AND y_t=y; 

                                                UPDATE projection
                                                SET cell_status=NULL 
                                                WHERE player_id=enemy_player AND x_p=x AND y_p=y;

                                                SELECT COUNT(cell_status) INTO win_check
                                                FROM projection
                                                WHERE player_id=enemy_player ;

                                                IF (win_check=0)THEN    
                                                        
                                                        BEGIN 
                                                        CASE 
                                                                WHEN p_id=1 THEN 
                                                                                UPDATE game_status SET result='1st Player Wins!';
                                                                                
                                                                ELSE 
                                                                        UPDATE game_status SET result='2nd Player Wins!';

                                                        END CASE;
                                                                                SELECT result INTO winner FROM game_status ;
                                                        SELECT CONCAT('Message: ', winner);                                                 /*elegxos an o antipalos den exei allo ploio ara niki*/
                                                        
                                                        END;
                                                 
                                                
                                                ELSE UPDATE game_status set p_turn=if(p_turn='1','2','1'); 
                                                END IF;

                                        END; 
                                        END IF;
                              
                         END;
                END IF;
         END//
DELIMITER ;

-- Dumping structure for table battleships.players
DROP TABLE IF EXISTS `players`;
CREATE TABLE IF NOT EXISTS `players` (
  `player_id` tinyint(1) NOT NULL,
  `username` varchar(20) DEFAULT NULL,
  `token` VARCHAR(255) DEFAULT NULL,
  `last_action` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table battleships.players: ~2 rows (approximately)
INSERT INTO `players` (`player_id`, `username`, `token`, `last_action`) VALUES
	(1, NULL, NULL, NULL),
	(2, NULL, NULL, NULL);

-- Dumping structure for table battleships.projection
DROP TABLE IF EXISTS `projection`;
CREATE TABLE IF NOT EXISTS `projection` (
  `projection_id` tinyint(1) NOT NULL,
  `player_id` tinyint(1) DEFAULT NULL,
  `x_p` tinyint(1) NOT NULL,
  `y_p` tinyint(1) NOT NULL,
  `cell_status` tinyint(1) DEFAULT NULL,
  ship_name VARCHAR(255) DEFAULT NULL, 
  PRIMARY KEY (`projection_id`,`x_p`,`y_p`),
  KEY `fk_type2` (`player_id`),
  CONSTRAINT `fk_type2` FOREIGN KEY (`player_id`) REFERENCES `players` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table battleships.projection: ~200 rows (approximately)
INSERT INTO `projection` (`projection_id`, `player_id`, `x_p`, `y_p`, `cell_status`) VALUES
	(1, 1, 1, 1, NULL),
	(1, 1, 1, 2, NULL),
	(1, 1, 1, 3, NULL),
	(1, 1, 1, 4, NULL),
	(1, 1, 1, 5, NULL),
	(1, 1, 1, 6, NULL),
	(1, 1, 1, 7, NULL),
	(1, 1, 1, 8, NULL),
	(1, 1, 1, 9, NULL),
	(1, 1, 1, 10, NULL),
	(1, 1, 2, 1, NULL),
	(1, 1, 2, 2, NULL),
	(1, 1, 2, 3, NULL),
	(1, 1, 2, 4, NULL),
	(1, 1, 2, 5, NULL),
	(1, 1, 2, 6, NULL),
	(1, 1, 2, 7, NULL),
	(1, 1, 2, 8, NULL),
	(1, 1, 2, 9, NULL),
	(1, 1, 2, 10, NULL),
	(1, 1, 3, 1, NULL),
	(1, 1, 3, 2, NULL),
	(1, 1, 3, 3, NULL),
	(1, 1, 3, 4, NULL),
	(1, 1, 3, 5, NULL),
	(1, 1, 3, 6, NULL),
	(1, 1, 3, 7, NULL),
	(1, 1, 3, 8, NULL),
	(1, 1, 3, 9, NULL),
	(1, 1, 3, 10, NULL),
	(1, 1, 4, 1, NULL),
	(1, 1, 4, 2, NULL),
	(1, 1, 4, 3, NULL),
	(1, 1, 4, 4, NULL),
	(1, 1, 4, 5, NULL),
	(1, 1, 4, 6, NULL),
	(1, 1, 4, 7, NULL),
	(1, 1, 4, 8, NULL),
	(1, 1, 4, 9, NULL),
	(1, 1, 4, 10, NULL),
	(1, 1, 5, 1, NULL),
	(1, 1, 5, 2, NULL),
	(1, 1, 5, 3, NULL),
	(1, 1, 5, 4, NULL),
	(1, 1, 5, 5, NULL),
	(1, 1, 5, 6, NULL),
	(1, 1, 5, 7, NULL),
	(1, 1, 5, 8, NULL),
	(1, 1, 5, 9, NULL),
	(1, 1, 5, 10, NULL),
	(1, 1, 6, 1, NULL),
	(1, 1, 6, 2, NULL),
	(1, 1, 6, 3, NULL),
	(1, 1, 6, 4, NULL),
	(1, 1, 6, 5, NULL),
	(1, 1, 6, 6, NULL),
	(1, 1, 6, 7, NULL),
	(1, 1, 6, 8, NULL),
	(1, 1, 6, 9, NULL),
	(1, 1, 6, 10, NULL),
	(1, 1, 7, 1, NULL),
	(1, 1, 7, 2, NULL),
	(1, 1, 7, 3, NULL),
	(1, 1, 7, 4, NULL),
	(1, 1, 7, 5, NULL),
	(1, 1, 7, 6, NULL),
	(1, 1, 7, 7, NULL),
	(1, 1, 7, 8, NULL),
	(1, 1, 7, 9, NULL),
	(1, 1, 7, 10, NULL),
	(1, 1, 8, 1, NULL),
	(1, 1, 8, 2, NULL),
	(1, 1, 8, 3, NULL),
	(1, 1, 8, 4, NULL),
	(1, 1, 8, 5, NULL),
	(1, 1, 8, 6, NULL),
	(1, 1, 8, 7, NULL),
	(1, 1, 8, 8, NULL),
	(1, 1, 8, 9, NULL),
	(1, 1, 8, 10, NULL),
	(1, 1, 9, 1, NULL),
	(1, 1, 9, 2, NULL),
	(1, 1, 9, 3, NULL),
	(1, 1, 9, 4, NULL),
	(1, 1, 9, 5, NULL),
	(1, 1, 9, 6, NULL),
	(1, 1, 9, 7, NULL),
	(1, 1, 9, 8, NULL),
	(1, 1, 9, 9, NULL),
	(1, 1, 9, 10, NULL),
	(1, 1, 10, 1, NULL),
	(1, 1, 10, 2, NULL),
	(1, 1, 10, 3, NULL),
	(1, 1, 10, 4, NULL),
	(1, 1, 10, 5, NULL),
	(1, 1, 10, 6, NULL),
	(1, 1, 10, 7, NULL),
	(1, 1, 10, 8, NULL),
	(1, 1, 10, 9, NULL),
	(1, 1, 10, 10, NULL),
	(2, 2, 1, 1, NULL),
	(2, 2, 1, 2, NULL),
	(2, 2, 1, 3, NULL),
	(2, 2, 1, 4, NULL),
	(2, 2, 1, 5, NULL),
	(2, 2, 1, 6, NULL),
	(2, 2, 1, 7, NULL),
	(2, 2, 1, 8, NULL),
	(2, 2, 1, 9, NULL),
	(2, 2, 1, 10, NULL),
	(2, 2, 2, 1, NULL),
	(2, 2, 2, 2, NULL),
	(2, 2, 2, 3, NULL),
	(2, 2, 2, 4, NULL),
	(2, 2, 2, 5, NULL),
	(2, 2, 2, 6, NULL),
	(2, 2, 2, 7, NULL),
	(2, 2, 2, 8, NULL),
	(2, 2, 2, 9, NULL),
	(2, 2, 2, 10, NULL),
	(2, 2, 3, 1, NULL),
	(2, 2, 3, 2, NULL),
	(2, 2, 3, 3, NULL),
	(2, 2, 3, 4, NULL),
	(2, 2, 3, 5, NULL),
	(2, 2, 3, 6, NULL),
	(2, 2, 3, 7, NULL),
	(2, 2, 3, 8, NULL),
	(2, 2, 3, 9, NULL),
	(2, 2, 3, 10, NULL),
	(2, 2, 4, 1, NULL),
	(2, 2, 4, 2, NULL),
	(2, 2, 4, 3, NULL),
	(2, 2, 4, 4, NULL),
	(2, 2, 4, 5, NULL),
	(2, 2, 4, 6, NULL),
	(2, 2, 4, 7, NULL),
	(2, 2, 4, 8, NULL),
	(2, 2, 4, 9, NULL),
	(2, 2, 4, 10, NULL),
	(2, 2, 5, 1, NULL),
	(2, 2, 5, 2, NULL),
	(2, 2, 5, 3, NULL),
	(2, 2, 5, 4, NULL),
	(2, 2, 5, 5, NULL),
	(2, 2, 5, 6, NULL),
	(2, 2, 5, 7, NULL),
	(2, 2, 5, 8, NULL),
	(2, 2, 5, 9, NULL),
	(2, 2, 5, 10, NULL),
	(2, 2, 6, 1, NULL),
	(2, 2, 6, 2, NULL),
	(2, 2, 6, 3, NULL),
	(2, 2, 6, 4, NULL),
	(2, 2, 6, 5, NULL),
	(2, 2, 6, 6, NULL),
	(2, 2, 6, 7, NULL),
	(2, 2, 6, 8, NULL),
	(2, 2, 6, 9, NULL),
	(2, 2, 6, 10, NULL),
	(2, 2, 7, 1, NULL),
	(2, 2, 7, 2, NULL),
	(2, 2, 7, 3, NULL),
	(2, 2, 7, 4, NULL),
	(2, 2, 7, 5, NULL),
	(2, 2, 7, 6, NULL),
	(2, 2, 7, 7, NULL),
	(2, 2, 7, 8, NULL),
	(2, 2, 7, 9, NULL),
	(2, 2, 7, 10, NULL),
	(2, 2, 8, 1, NULL),
	(2, 2, 8, 2, NULL),
	(2, 2, 8, 3, NULL),
	(2, 2, 8, 4, NULL),
	(2, 2, 8, 5, NULL),
	(2, 2, 8, 6, NULL),
	(2, 2, 8, 7, NULL),
	(2, 2, 8, 8, NULL),
	(2, 2, 8, 9, NULL),
	(2, 2, 8, 10, NULL),
	(2, 2, 9, 1, NULL),
	(2, 2, 9, 2, NULL),
	(2, 2, 9, 3, NULL),
	(2, 2, 9, 4, NULL),
	(2, 2, 9, 5, NULL),
	(2, 2, 9, 6, NULL),
	(2, 2, 9, 7, NULL),
	(2, 2, 9, 8, NULL),
	(2, 2, 9, 9, NULL),
	(2, 2, 9, 10, NULL),
	(2, 2, 10, 1, NULL),
	(2, 2, 10, 2, NULL),
	(2, 2, 10, 3, NULL),
	(2, 2, 10, 4, NULL),
	(2, 2, 10, 5, NULL),
	(2, 2, 10, 6, NULL),
	(2, 2, 10, 7, NULL),
	(2, 2, 10, 8, NULL),
	(2, 2, 10, 9, NULL),
	(2, 2, 10, 10, NULL);








-- Dumping structure for procedure battleships.set_piece
DROP PROCEDURE IF EXISTS set_piece;

DELIMITER //
        CREATE PROCEDURE set_piece(s_name varchar(255), start_x tinyint,  start_y tinyint, end_x tinyint, end_y tinyint, p_token varchar(255))
        BEGIN 
              DECLARE outofbounds, place_occupied  VARCHAR(255);        
              DECLARE c_stat, count_x, count_y, s_id, p_id tinyint(1); 
              SET c_stat=NULL ;
			  SET s_id=NULL;
			  SET p_id=NULL;
              SET count_x=1;
              SET count_y=1; 

			  SELECT player_id INTO p_id FROM players
			  WHERE token=p_token;

			  SELECT ship_id INTO s_id FROM ships 
			  WHERE ship_name = s_name and player_id=p_id;
              
              SELECT cell_status INTO c_stat FROM projection                            /*pairno to status toy kelioy, elefthero h oxi*/
              WHERE  x_p=start_x AND y_p=start_y AND player_id=p_id;
                
 /*LOOP CHECK*/       loop_check_rows_status: WHILE (c_stat IS NULL AND count_x < end_x-start_x-1)DO
                SELECT cell_status INTO c_stat FROM projection                            /*pairno to status toy kelioy, elefthero h oxi*/
                WHERE  x_p=start_x+count_x AND y_p=start_y AND player_id=p_id;
                SET count_x= count_x +1 ;
                END WHILE loop_check_rows_status;

 /*LOOP CHECK*/       loop_check_cols_status: WHILE (c_stat IS NULL AND count_y <=end_y-start_y-1 )DO
                SELECT cell_status INTO c_stat FROM projection                            /*pairno to status toy kelioy, elefthero h oxi*/
                WHERE  x_p=start_x AND y_p=start_y+count_y AND player_id=p_id;
                SET count_y= count_y+1;
                END WHILE loop_check_cols_status;
               
                                                                                        /*elegxos gia lathos timon theseon ploion*/
              SET outofbounds='Ouf of Bounds.';
              SET place_occupied='Ship Already There.';  

                IF (start_x < 1 OR start_x > 10 OR end_x < 1 OR end_x > 10 OR start_y < 1 OR start_y > 10 OR end_y < 1 OR end_y > 10 )THEN
                SELECT CONCAT('ERROR: ', outofbounds) ;
                ELSEIF (c_stat IS NOT NULL) THEN
                SELECT CONCAT('ERROR: ', place_occupied);
                
                ELSE 
                        BEGIN
                set count_x=start_x;
                set count_y=start_y;

/*LOOP FILL*/        fill_rows_ship: WHILE count_x <= end_x AND start_x<>end_x DO
                UPDATE projection
                set cell_status=1, ship_name=s_name WHERE player_id=p_id AND x_p=count_x and y_p=count_y;
                set count_x= count_x+1;
                END WHILE fill_rows_ship;

/*LOOP FILL*/        fill_cols_ship: WHILE count_y <= end_y AND start_y<>end_y DO
                UPDATE projection
                set cell_status=1, ship_name=s_name WHERE player_id=p_id AND x_p=count_x and y_p=count_y;
                set count_y= count_y+1;     
                END WHILE fill_cols_ship;           

                UPDATE ships
                set start_row=start_x, end_row=end_x,start_col=start_y, end_col=end_y                                                 /*enimerosi thesis ploiou kai game status*/
                where ship_id=s_id and player_id=p_id;

               END;

                END IF; 

               
             
                END//
DELIMITER ;

-- Dumping structure for table battleships.ships
DROP TABLE IF EXISTS `ships`;
CREATE TABLE IF NOT EXISTS `ships` (
  `ship_id` tinyint(1) NOT NULL AUTO_INCREMENT,
  `player_id` tinyint(1) DEFAULT NULL,
  `ship_name` VARCHAR(255) DEFAULT NULL,
  `ship_size` tinyint(1) DEFAULT NULL,
  `start_row` tinyint(1) DEFAULT NULL,
  `end_row` tinyint(1) DEFAULT NULL,
  `start_col` tinyint(1) DEFAULT NULL,
  `end_col` tinyint(1) DEFAULT NULL,
  
  PRIMARY KEY (`ship_id`),
  KEY `fk_type3` (`player_id`),
  CONSTRAINT `fk_type3` FOREIGN KEY (`player_id`) REFERENCES `players` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table battleships.ships: ~10 rows (approximately)
INSERT INTO `ships` (`ship_id`, `player_id`, `ship_name`, `ship_size`, `start_row`, `end_row`, `start_col`, `end_col`) VALUES
	(1, 1, 'Carrier', 5, NULL, NULL, NULL, NULL),
	(2, 1, 'Battleship', 4, NULL, NULL, NULL, NULL),
	(3, 1, 'Cruiser', 3, NULL, NULL, NULL, NULL),
	(4, 1, 'Submarine', 3, NULL, NULL, NULL, NULL),
	(5, 1, 'Destroyer', 2, NULL, NULL, NULL, NULL),

	(6, 2, 'Carrier', 5, NULL, NULL, NULL, NULL),
	(7, 2, 'Battleship', 4, NULL, NULL, NULL, NULL),
	(8, 2, 'Cruiser', 3, NULL, NULL, NULL, NULL),
	(9, 2, 'Submarine', 3, NULL, NULL, NULL, NULL),
	(10, 2, 'Destroyer', 2, NULL, NULL, NULL, NULL);

-- Dumping structure for table battleships.targets
DROP TABLE IF EXISTS `targets`;
CREATE TABLE IF NOT EXISTS `targets` (
  `target_id` tinyint(1) NOT NULL,
  `player_id` tinyint(1) DEFAULT NULL,
  `target_status` enum('not_specified','hit','miss') DEFAULT 'not_specified',
  `x_t` tinyint(1) NOT NULL,
  `y_t` tinyint(1) NOT NULL,
  PRIMARY KEY (`target_id`,`x_t`,`y_t`),
  KEY `fk_type4` (`player_id`),
  CONSTRAINT `fk_type4` FOREIGN KEY (`player_id`) REFERENCES `players` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table battleships.targets: ~200 rows (approximately)
INSERT INTO `targets` (`target_id`, `player_id`, `target_status`, `x_t`, `y_t`) VALUES
	(1, 1, 'not_specified', 1, 1),
	(1, 1, 'not_specified', 1, 2),
	(1, 1, 'not_specified', 1, 3),
	(1, 1, 'not_specified', 1, 4),
	(1, 1, 'not_specified', 1, 5),
	(1, 1, 'not_specified', 1, 6),
	(1, 1, 'not_specified', 1, 7),
	(1, 1, 'not_specified', 1, 8),
	(1, 1, 'not_specified', 1, 9),
	(1, 1, 'not_specified', 1, 10),
	(1, 1, 'not_specified', 2, 1),
	(1, 1, 'not_specified', 2, 2),
	(1, 1, 'not_specified', 2, 3),
	(1, 1, 'not_specified', 2, 4),
	(1, 1, 'not_specified', 2, 5),
	(1, 1, 'not_specified', 2, 6),
	(1, 1, 'not_specified', 2, 7),
	(1, 1, 'not_specified', 2, 8),
	(1, 1, 'not_specified', 2, 9),
	(1, 1, 'not_specified', 2, 10),
	(1, 1, 'not_specified', 3, 1),
	(1, 1, 'not_specified', 3, 2),
	(1, 1, 'not_specified', 3, 3),
	(1, 1, 'not_specified', 3, 4),
	(1, 1, 'not_specified', 3, 5),
	(1, 1, 'not_specified', 3, 6),
	(1, 1, 'not_specified', 3, 7),
	(1, 1, 'not_specified', 3, 8),
	(1, 1, 'not_specified', 3, 9),
	(1, 1, 'not_specified', 3, 10),
	(1, 1, 'not_specified', 4, 1),
	(1, 1, 'not_specified', 4, 2),
	(1, 1, 'not_specified', 4, 3),
	(1, 1, 'not_specified', 4, 4),
	(1, 1, 'not_specified', 4, 5),
	(1, 1, 'not_specified', 4, 6),
	(1, 1, 'not_specified', 4, 7),
	(1, 1, 'not_specified', 4, 8),
	(1, 1, 'not_specified', 4, 9),
	(1, 1, 'not_specified', 4, 10),
	(1, 1, 'not_specified', 5, 1),
	(1, 1, 'not_specified', 5, 2),
	(1, 1, 'not_specified', 5, 3),
	(1, 1, 'not_specified', 5, 4),
	(1, 1, 'not_specified', 5, 5),
	(1, 1, 'not_specified', 5, 6),
	(1, 1, 'not_specified', 5, 7),
	(1, 1, 'not_specified', 5, 8),
	(1, 1, 'not_specified', 5, 9),
	(1, 1, 'not_specified', 5, 10),
	(1, 1, 'not_specified', 6, 1),
	(1, 1, 'not_specified', 6, 2),
	(1, 1, 'not_specified', 6, 3),
	(1, 1, 'not_specified', 6, 4),
	(1, 1, 'not_specified', 6, 5),
	(1, 1, 'not_specified', 6, 6),
	(1, 1, 'not_specified', 6, 7),
	(1, 1, 'not_specified', 6, 8),
	(1, 1, 'not_specified', 6, 9),
	(1, 1, 'not_specified', 6, 10),
	(1, 1, 'not_specified', 7, 1),
	(1, 1, 'not_specified', 7, 2),
	(1, 1, 'not_specified', 7, 3),
	(1, 1, 'not_specified', 7, 4),
	(1, 1, 'not_specified', 7, 5),
	(1, 1, 'not_specified', 7, 6),
	(1, 1, 'not_specified', 7, 7),
	(1, 1, 'not_specified', 7, 8),
	(1, 1, 'not_specified', 7, 9),
	(1, 1, 'not_specified', 7, 10),
	(1, 1, 'not_specified', 8, 1),
	(1, 1, 'not_specified', 8, 2),
	(1, 1, 'not_specified', 8, 3),
	(1, 1, 'not_specified', 8, 4),
	(1, 1, 'not_specified', 8, 5),
	(1, 1, 'not_specified', 8, 6),
	(1, 1, 'not_specified', 8, 7),
	(1, 1, 'not_specified', 8, 8),
	(1, 1, 'not_specified', 8, 9),
	(1, 1, 'not_specified', 8, 10),
	(1, 1, 'not_specified', 9, 1),
	(1, 1, 'not_specified', 9, 2),
	(1, 1, 'not_specified', 9, 3),
	(1, 1, 'not_specified', 9, 4),
	(1, 1, 'not_specified', 9, 5),
	(1, 1, 'not_specified', 9, 6),
	(1, 1, 'not_specified', 9, 7),
	(1, 1, 'not_specified', 9, 8),
	(1, 1, 'not_specified', 9, 9),
	(1, 1, 'not_specified', 9, 10),
	(1, 1, 'not_specified', 10, 1),
	(1, 1, 'not_specified', 10, 2),
	(1, 1, 'not_specified', 10, 3),
	(1, 1, 'not_specified', 10, 4),
	(1, 1, 'not_specified', 10, 5),
	(1, 1, 'not_specified', 10, 6),
	(1, 1, 'not_specified', 10, 7),
	(1, 1, 'not_specified', 10, 8),
	(1, 1, 'not_specified', 10, 9),
	(1, 1, 'not_specified', 10, 10),
	(2, 2, 'not_specified', 1, 1),
	(2, 2, 'not_specified', 1, 2),
	(2, 2, 'not_specified', 1, 3),
	(2, 2, 'not_specified', 1, 4),
	(2, 2, 'not_specified', 1, 5),
	(2, 2, 'not_specified', 1, 6),
	(2, 2, 'not_specified', 1, 7),
	(2, 2, 'not_specified', 1, 8),
	(2, 2, 'not_specified', 1, 9),
	(2, 2, 'not_specified', 1, 10),
	(2, 2, 'not_specified', 2, 1),
	(2, 2, 'not_specified', 2, 2),
	(2, 2, 'not_specified', 2, 3),
	(2, 2, 'not_specified', 2, 4),
	(2, 2, 'not_specified', 2, 5),
	(2, 2, 'not_specified', 2, 6),
	(2, 2, 'not_specified', 2, 7),
	(2, 2, 'not_specified', 2, 8),
	(2, 2, 'not_specified', 2, 9),
	(2, 2, 'not_specified', 2, 10),
	(2, 2, 'not_specified', 3, 1),
	(2, 2, 'not_specified', 3, 2),
	(2, 2, 'not_specified', 3, 3),
	(2, 2, 'not_specified', 3, 4),
	(2, 2, 'not_specified', 3, 5),
	(2, 2, 'not_specified', 3, 6),
	(2, 2, 'not_specified', 3, 7),
	(2, 2, 'not_specified', 3, 8),
	(2, 2, 'not_specified', 3, 9),
	(2, 2, 'not_specified', 3, 10),
	(2, 2, 'not_specified', 4, 1),
	(2, 2, 'not_specified', 4, 2),
	(2, 2, 'not_specified', 4, 3),
	(2, 2, 'not_specified', 4, 4),
	(2, 2, 'not_specified', 4, 5),
	(2, 2, 'not_specified', 4, 6),
	(2, 2, 'not_specified', 4, 7),
	(2, 2, 'not_specified', 4, 8),
	(2, 2, 'not_specified', 4, 9),
	(2, 2, 'not_specified', 4, 10),
	(2, 2, 'not_specified', 5, 1),
	(2, 2, 'not_specified', 5, 2),
	(2, 2, 'not_specified', 5, 3),
	(2, 2, 'not_specified', 5, 4),
	(2, 2, 'not_specified', 5, 5),
	(2, 2, 'not_specified', 5, 6),
	(2, 2, 'not_specified', 5, 7),
	(2, 2, 'not_specified', 5, 8),
	(2, 2, 'not_specified', 5, 9),
	(2, 2, 'not_specified', 5, 10),
	(2, 2, 'not_specified', 6, 1),
	(2, 2, 'not_specified', 6, 2),
	(2, 2, 'not_specified', 6, 3),
	(2, 2, 'not_specified', 6, 4),
	(2, 2, 'not_specified', 6, 5),
	(2, 2, 'not_specified', 6, 6),
	(2, 2, 'not_specified', 6, 7),
	(2, 2, 'not_specified', 6, 8),
	(2, 2, 'not_specified', 6, 9),
	(2, 2, 'not_specified', 6, 10),
	(2, 2, 'not_specified', 7, 1),
	(2, 2, 'not_specified', 7, 2),
	(2, 2, 'not_specified', 7, 3),
	(2, 2, 'not_specified', 7, 4),
	(2, 2, 'not_specified', 7, 5),
	(2, 2, 'not_specified', 7, 6),
	(2, 2, 'not_specified', 7, 7),
	(2, 2, 'not_specified', 7, 8),
	(2, 2, 'not_specified', 7, 9),
	(2, 2, 'not_specified', 7, 10),
	(2, 2, 'not_specified', 8, 1),
	(2, 2, 'not_specified', 8, 2),
	(2, 2, 'not_specified', 8, 3),
	(2, 2, 'not_specified', 8, 4),
	(2, 2, 'not_specified', 8, 5),
	(2, 2, 'not_specified', 8, 6),
	(2, 2, 'not_specified', 8, 7),
	(2, 2, 'not_specified', 8, 8),
	(2, 2, 'not_specified', 8, 9),
	(2, 2, 'not_specified', 8, 10),
	(2, 2, 'not_specified', 9, 1),
	(2, 2, 'not_specified', 9, 2),
	(2, 2, 'not_specified', 9, 3),
	(2, 2, 'not_specified', 9, 4),
	(2, 2, 'not_specified', 9, 5),
	(2, 2, 'not_specified', 9, 6),
	(2, 2, 'not_specified', 9, 7),
	(2, 2, 'not_specified', 9, 8),
	(2, 2, 'not_specified', 9, 9),
	(2, 2, 'not_specified', 9, 10),
	(2, 2, 'not_specified', 10, 1),
	(2, 2, 'not_specified', 10, 2),
	(2, 2, 'not_specified', 10, 3),
	(2, 2, 'not_specified', 10, 4),
	(2, 2, 'not_specified', 10, 5),
	(2, 2, 'not_specified', 10, 6),
	(2, 2, 'not_specified', 10, 7),
	(2, 2, 'not_specified', 10, 8),
	(2, 2, 'not_specified', 10, 9),
	(2, 2, 'not_specified', 10, 10);


   DELIMITER //
      CREATE PROCEDURE clean_all()                    /* procedure gia na epilegei o xristis poy xtipaei ton antipalo*/
        BEGIN 


        DROP TABLE IF EXISTS targets_clean;
DROP TABLE IF EXISTS ships_clean;
DROP TABLE IF EXISTS game_status_clean;
DROP TABLE IF EXISTS projection_clean;
DROP TABLE IF EXISTS players_clean;

CREATE TABLE players_clean (                          /* pinakas paikton*/
    player_id tinyint(1)  NOT NULL,
    username VARCHAR(20) DEFAULT NULL,
    token VARCHAR(255) DEFAULT NULL,
    last_action TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY(player_id)

);


CREATE TABLE projection_clean (                                       /*pinakas toy board kathe paikti*/
        projection_id tinyint(1) NOT NULL,
        player_id tinyint(1) DEFAULT NULL, 
        x_p tinyint(1) NOT NULL,
        y_p tinyint(1) NOT NULL,
        
        cell_status tinyint(1) DEFAULT NULL, 
        ship_name VARCHAR(255) DEFAULT NULL,

        PRIMARY KEY(projection_id,x_p,y_p),

        CONSTRAINT fk_type3clean 
        FOREIGN KEY(player_id) 
        REFERENCES players_clean(player_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE 
    
);


CREATE TABLE game_status_clean (                                                                                      /*pinakas katastasis paixnidiou*/
       game_id tinyint(1) NOT NULL AUTO_INCREMENT,
        game_stat ENUM('not active','initialized','started','ships_placed','ended','aborded') NOT NULL DEFAULT 'not active',
        p_turn ENUM('1','2') DEFAULT NULL,
        result ENUM('1st Player Wins!','2nd Player Wins!') DEFAULT NULL,
        last_change TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),

        PRIMARY KEY(game_id)
);

INSERT INTO game_status_clean(game_stat,p_turn,result,last_change)  VALUE                     /*arxikopoiisi status paixnidiou*/
('not active',NULL, NULL, NULL); 

INSERT INTO players_clean(player_id,username,token,last_action) VALUES                        /*eisagogi paikton ston pinaka, to paixnidi paizetai apo 2 paiktes*/
                (1,NULL,NULL,NULL), 
                (2, NULL,NULL,NULL);


CREATE TABLE ships_clean (                                                                    /*pinakas karavion, ton onomaton kai ton xaraktiristikon tous*/
        ship_id tinyint(1) NOT NULL AUTO_INCREMENT,
        player_id tinyint(1) DEFAULT NULL,
        ship_name VARCHAR(255) DEFAULT NULL,
        ship_size tinyint(1) DEFAULT NULL,
        start_row tinyint(1) DEFAULT NULL,
        end_row tinyint(1) DEFAULT NULL,
        start_col tinyint(1) DEFAULT NULL,
        end_col tinyint(1) DEFAULT NULL,
        PRIMARY KEY(ship_id),

        CONSTRAINT fk_type2clean 
        FOREIGN KEY(player_id)
        REFERENCES players_clean(player_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE 
);

INSERT INTO ships_clean(ship_id, player_id,ship_name,ship_size,start_row,end_row,start_col,end_col) VALUES             /*arxikopoisi pinaka ploion*/
         	(1, 1, 'Carrier', 5, NULL, NULL, NULL, NULL),
	(2, 1, 'Battleship', 4, NULL, NULL, NULL, NULL),
	(3, 1, 'Cruiser', 3, NULL, NULL, NULL, NULL),
	(4, 1, 'Submarine', 3, NULL, NULL, NULL, NULL),
	(5, 1, 'Destroyer', 2, NULL, NULL, NULL, NULL),

	(6, 2, 'Carrier', 5, NULL, NULL, NULL, NULL),
	(7, 2, 'Battleship', 4, NULL, NULL, NULL, NULL),
	(8, 2, 'Cruiser', 3, NULL, NULL, NULL, NULL),
	(9, 2, 'Submarine', 3, NULL, NULL, NULL, NULL),
	(10, 2, 'Destroyer', 2, NULL, NULL, NULL, NULL);

                
                                                                                         /*pinakas stoxon*/
CREATE TABLE targets_clean(
        target_id tinyint(1) NOT NULL,
        player_id tinyint(1) DEFAULT NULL,
        target_status enum('not_specified', 'hit', 'miss') DEFAULT 'not_specified',

        x_t tinyint(1) NOT NULL,
        y_t tinyint(1) NOT NULL,

        PRIMARY KEY(target_id, x_t, y_t),

        CONSTRAINT fk_type1clean 
        FOREIGN KEY(player_id)
        REFERENCES players_clean(player_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE 
);


INSERT INTO targets_clean(target_id, player_id, x_t, y_t) VALUES
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
                            (2, 2, 10, 10) ;


INSERT INTO projection_clean(projection_id, player_id, x_p, y_p, cell_status) VALUES                                                  /*dimiourgia ton board ton 2 paikton*/
               (1, 1, 1, 1, NULL),
	(1, 1, 1, 2, NULL),
	(1, 1, 1, 3, NULL),
	(1, 1, 1, 4, NULL),
	(1, 1, 1, 5, NULL),
	(1, 1, 1, 6, NULL),
	(1, 1, 1, 7, NULL),
	(1, 1, 1, 8, NULL),
	(1, 1, 1, 9, NULL),
	(1, 1, 1, 10, NULL),
	(1, 1, 2, 1, NULL),
	(1, 1, 2, 2, NULL),
	(1, 1, 2, 3, NULL),
	(1, 1, 2, 4, NULL),
	(1, 1, 2, 5, NULL),
	(1, 1, 2, 6, NULL),
	(1, 1, 2, 7, NULL),
	(1, 1, 2, 8, NULL),
	(1, 1, 2, 9, NULL),
	(1, 1, 2, 10, NULL),
	(1, 1, 3, 1, NULL),
	(1, 1, 3, 2, NULL),
	(1, 1, 3, 3, NULL),
	(1, 1, 3, 4, NULL),
	(1, 1, 3, 5, NULL),
	(1, 1, 3, 6, NULL),
	(1, 1, 3, 7, NULL),
	(1, 1, 3, 8, NULL),
	(1, 1, 3, 9, NULL),
	(1, 1, 3, 10, NULL),
	(1, 1, 4, 1, NULL),
	(1, 1, 4, 2, NULL),
	(1, 1, 4, 3, NULL),
	(1, 1, 4, 4, NULL),
	(1, 1, 4, 5, NULL),
	(1, 1, 4, 6, NULL),
	(1, 1, 4, 7, NULL),
	(1, 1, 4, 8, NULL),
	(1, 1, 4, 9, NULL),
	(1, 1, 4, 10, NULL),
	(1, 1, 5, 1, NULL),
	(1, 1, 5, 2, NULL),
	(1, 1, 5, 3, NULL),
	(1, 1, 5, 4, NULL),
	(1, 1, 5, 5, NULL),
	(1, 1, 5, 6, NULL),
	(1, 1, 5, 7, NULL),
	(1, 1, 5, 8, NULL),
	(1, 1, 5, 9, NULL),
	(1, 1, 5, 10, NULL),
	(1, 1, 6, 1, NULL),
	(1, 1, 6, 2, NULL),
	(1, 1, 6, 3, NULL),
	(1, 1, 6, 4, NULL),
	(1, 1, 6, 5, NULL),
	(1, 1, 6, 6, NULL),
	(1, 1, 6, 7, NULL),
	(1, 1, 6, 8, NULL),
	(1, 1, 6, 9, NULL),
	(1, 1, 6, 10, NULL),
	(1, 1, 7, 1, NULL),
	(1, 1, 7, 2, NULL),
	(1, 1, 7, 3, NULL),
	(1, 1, 7, 4, NULL),
	(1, 1, 7, 5, NULL),
	(1, 1, 7, 6, NULL),
	(1, 1, 7, 7, NULL),
	(1, 1, 7, 8, NULL),
	(1, 1, 7, 9, NULL),
	(1, 1, 7, 10, NULL),
	(1, 1, 8, 1, NULL),
	(1, 1, 8, 2, NULL),
	(1, 1, 8, 3, NULL),
	(1, 1, 8, 4, NULL),
	(1, 1, 8, 5, NULL),
	(1, 1, 8, 6, NULL),
	(1, 1, 8, 7, NULL),
	(1, 1, 8, 8, NULL),
	(1, 1, 8, 9, NULL),
	(1, 1, 8, 10, NULL),
	(1, 1, 9, 1, NULL),
	(1, 1, 9, 2, NULL),
	(1, 1, 9, 3, NULL),
	(1, 1, 9, 4, NULL),
	(1, 1, 9, 5, NULL),
	(1, 1, 9, 6, NULL),
	(1, 1, 9, 7, NULL),
	(1, 1, 9, 8, NULL),
	(1, 1, 9, 9, NULL),
	(1, 1, 9, 10, NULL),
	(1, 1, 10, 1, NULL),
	(1, 1, 10, 2, NULL),
	(1, 1, 10, 3, NULL),
	(1, 1, 10, 4, NULL),
	(1, 1, 10, 5, NULL),
	(1, 1, 10, 6, NULL),
	(1, 1, 10, 7, NULL),
	(1, 1, 10, 8, NULL),
	(1, 1, 10, 9, NULL),
	(1, 1, 10, 10, NULL),
	(2, 2, 1, 1, NULL),
	(2, 2, 1, 2, NULL),
	(2, 2, 1, 3, NULL),
	(2, 2, 1, 4, NULL),
	(2, 2, 1, 5, NULL),
	(2, 2, 1, 6, NULL),
	(2, 2, 1, 7, NULL),
	(2, 2, 1, 8, NULL),
	(2, 2, 1, 9, NULL),
	(2, 2, 1, 10, NULL),
	(2, 2, 2, 1, NULL),
	(2, 2, 2, 2, NULL),
	(2, 2, 2, 3, NULL),
	(2, 2, 2, 4, NULL),
	(2, 2, 2, 5, NULL),
	(2, 2, 2, 6, NULL),
	(2, 2, 2, 7, NULL),
	(2, 2, 2, 8, NULL),
	(2, 2, 2, 9, NULL),
	(2, 2, 2, 10, NULL),
	(2, 2, 3, 1, NULL),
	(2, 2, 3, 2, NULL),
	(2, 2, 3, 3, NULL),
	(2, 2, 3, 4, NULL),
	(2, 2, 3, 5, NULL),
	(2, 2, 3, 6, NULL),
	(2, 2, 3, 7, NULL),
	(2, 2, 3, 8, NULL),
	(2, 2, 3, 9, NULL),
	(2, 2, 3, 10, NULL),
	(2, 2, 4, 1, NULL),
	(2, 2, 4, 2, NULL),
	(2, 2, 4, 3, NULL),
	(2, 2, 4, 4, NULL),
	(2, 2, 4, 5, NULL),
	(2, 2, 4, 6, NULL),
	(2, 2, 4, 7, NULL),
	(2, 2, 4, 8, NULL),
	(2, 2, 4, 9, NULL),
	(2, 2, 4, 10, NULL),
	(2, 2, 5, 1, NULL),
	(2, 2, 5, 2, NULL),
	(2, 2, 5, 3, NULL),
	(2, 2, 5, 4, NULL),
	(2, 2, 5, 5, NULL),
	(2, 2, 5, 6, NULL),
	(2, 2, 5, 7, NULL),
	(2, 2, 5, 8, NULL),
	(2, 2, 5, 9, NULL),
	(2, 2, 5, 10, NULL),
	(2, 2, 6, 1, NULL),
	(2, 2, 6, 2, NULL),
	(2, 2, 6, 3, NULL),
	(2, 2, 6, 4, NULL),
	(2, 2, 6, 5, NULL),
	(2, 2, 6, 6, NULL),
	(2, 2, 6, 7, NULL),
	(2, 2, 6, 8, NULL),
	(2, 2, 6, 9, NULL),
	(2, 2, 6, 10, NULL),
	(2, 2, 7, 1, NULL),
	(2, 2, 7, 2, NULL),
	(2, 2, 7, 3, NULL),
	(2, 2, 7, 4, NULL),
	(2, 2, 7, 5, NULL),
	(2, 2, 7, 6, NULL),
	(2, 2, 7, 7, NULL),
	(2, 2, 7, 8, NULL),
	(2, 2, 7, 9, NULL),
	(2, 2, 7, 10, NULL),
	(2, 2, 8, 1, NULL),
	(2, 2, 8, 2, NULL),
	(2, 2, 8, 3, NULL),
	(2, 2, 8, 4, NULL),
	(2, 2, 8, 5, NULL),
	(2, 2, 8, 6, NULL),
	(2, 2, 8, 7, NULL),
	(2, 2, 8, 8, NULL),
	(2, 2, 8, 9, NULL),
	(2, 2, 8, 10, NULL),
	(2, 2, 9, 1, NULL),
	(2, 2, 9, 2, NULL),
	(2, 2, 9, 3, NULL),
	(2, 2, 9, 4, NULL),
	(2, 2, 9, 5, NULL),
	(2, 2, 9, 6, NULL),
	(2, 2, 9, 7, NULL),
	(2, 2, 9, 8, NULL),
	(2, 2, 9, 9, NULL),
	(2, 2, 9, 10, NULL),
	(2, 2, 10, 1, NULL),
	(2, 2, 10, 2, NULL),
	(2, 2, 10, 3, NULL),
	(2, 2, 10, 4, NULL),
	(2, 2, 10, 5, NULL),
	(2, 2, 10, 6, NULL),
	(2, 2, 10, 7, NULL),
	(2, 2, 10, 8, NULL),
	(2, 2, 10, 9, NULL),
	(2, 2, 10, 10, NULL);

REPLACE INTO players SELECT * FROM players_clean; 
REPLACE INTO projection SELECT * FROM projection_clean;
REPLACE INTO game_status SELECT * FROM game_status_clean;
REPLACE INTO ships SELECT * FROM ships_clean; 
REPLACE INTO targets SELECT * FROM targets_clean; 






DROP TABLE IF EXISTS targets_clean;
DROP TABLE IF EXISTS ships_clean;
DROP TABLE IF EXISTS game_status_clean;
DROP TABLE IF EXISTS projection_clean;
DROP TABLE IF EXISTS players_clean;


        END//
DELIMITER ;




/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
