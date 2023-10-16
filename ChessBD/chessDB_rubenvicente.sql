-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.4.27-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.4.0.6659
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para recuperacion_chessdb_rubenvicente
CREATE DATABASE IF NOT EXISTS `recuperacion_chessdb_rubenvicente` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `recuperacion_chessdb_rubenvicente`;

-- Volcando estructura para procedimiento recuperacion_chessdb_rubenvicente.actualizar_jugadores_tras_partida
DELIMITER //
CREATE PROCEDURE `actualizar_jugadores_tras_partida`(
	IN `id_blancas` INT,
	IN `id_negras` INT,
	IN `ganador` INT
)
BEGIN
	IF ganador = 1 THEN
        UPDATE jugadores SET victorias = victorias + 1 WHERE id = id_blancas;
        UPDATE jugadores SET derrotas = derrotas + 1 WHERE id = id_negras;
   ELSEIF ganador = 2 THEN
        UPDATE jugadores SET victorias = victorias + 1 WHERE id = id_negras;
        UPDATE jugadores SET derrotas = derrotas + 1 WHERE id = id_blancas;
   END IF;

END//
DELIMITER ;

-- Volcando estructura para procedimiento recuperacion_chessdb_rubenvicente.alta_inscripciones
DELIMITER //
CREATE PROCEDURE `alta_inscripciones`()
BEGIN
	
	DECLARE i INT DEFAULT 0;
	DECLARE jugador INT;
	DECLARE torneo INT;
	DECLARE elo_actual INT;
	
	SELECT id INTO torneo FROM torneos ORDER BY RAND() LIMIT 1;
	
	
	WHILE i < 20 DO
		
		SET jugador = (SELECT id FROM jugadores where id NOT IN (SELECT id_jugador FROM inscripciones WHERE id_torneo = torneo) ORDER BY RAND() LIMIT 1);
		
		SELECT elo into elo_actual FROM jugadores WHERE id = jugador;  
		
		INSERT INTO inscripciones(id_jugador,id_torneo,elo_actual)
		VALUES(jugador,torneo,elo_actual);

		SET i = i + 1;

	END WHILE;
END//
DELIMITER ;

-- Volcando estructura para procedimiento recuperacion_chessdb_rubenvicente.alta_jugadores
DELIMITER //
CREATE PROCEDURE `alta_jugadores`()
BEGIN
	DECLARE i INT DEFAULT 0;
	DECLARE nombres VARCHAR(50);
	DECLARE apellidos VARCHAR(50);
   DECLARE paises VARCHAR(50);
   
   WHILE i < 20 DO
		SET nombres = CONCAT('Jugador', i+1);
		SET apellidos = CONCAT('Apellido', i+1);
		SET paises = CASE 
                        WHEN i % 5 = 1 THEN 'España'
                        WHEN i % 5 = 2 THEN 'Francia'
                        WHEN i % 5 = 3 THEN 'Alemania'
                        WHEN i % 5 = 4 THEN 'Italia'
                        ELSE 'Portugal'
                  END;
   	INSERT INTO jugadores (nombre,apellido,pais)
   	VALUES(nombres,apellidos,paises);
   	SET i = i+1;
   END WHILE;
END//
DELIMITER ;

-- Volcando estructura para procedimiento recuperacion_chessdb_rubenvicente.alta_partidas
DELIMITER //
CREATE PROCEDURE `alta_partidas`()
BEGIN
	
	DECLARE i INT DEFAULT 0;
	DECLARE jugador1 INT;
	DECLARE jugador2 INT;
	DECLARE torneo INT;
	DECLARE victoria INT;
	
	SELECT id INTO torneo FROM torneos ORDER BY RAND() LIMIT 1;
	
	
	WHILE i < 10 DO
		
		SELECT id INTO jugador1 FROM jugadores ORDER BY RAND() LIMIT 1;
		SELECT id INTO jugador2 FROM jugadores WHERE id != jugador1 LIMIT 1;

		SET victoria =CASE 
                        WHEN i % 3 = 1 THEN 2
                        WHEN i % 3 = 2 THEN 0
                        ELSE 1
                  END;
		
		
		INSERT INTO partidas (id_jugador_blancas_1, id_jugador_negras_2, id_torneo, ganador, fecha, hora) 
		VALUES (jugador1, jugador2, torneo, victoria, '2024-06-05', '17:30');

		SET i = i + 1;

	END WHILE;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento recuperacion_chessdb_rubenvicente.alta_torneos
DELIMITER //
CREATE PROCEDURE `alta_torneos`()
BEGIN
	INSERT INTO torneos (nombre, ciudad, fecha_inicio, fecha_fin, max_participantes, max_partidas, premio)
	VALUES ('Torneo de Ajedrez Verano', 'Barcelona','2023-07-20', '2023-07-25', 20, 5, 'jamon');
	
	INSERT INTO torneos (nombre, ciudad, fecha_inicio, fecha_fin, max_participantes, max_partidas, premio)
	VALUES ('Torneo de Ajedrez Primavera', 'Madrid','2023-05-20', '2023-05-25', 40, 10, '1000 euros');
	
	INSERT INTO torneos (nombre, ciudad, fecha_inicio, fecha_fin, max_participantes, max_partidas, premio)
	VALUES ('Torneo de Ajedrez Invierno', 'Pamplona','2023-01-20', '2023-01-25', 10, 3, '300 euros');
END//
DELIMITER ;

-- Volcando estructura para tabla recuperacion_chessdb_rubenvicente.clasificacion_torneo
CREATE TABLE IF NOT EXISTS `clasificacion_torneo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_torneo` int(11) NOT NULL,
  `id_jugador` int(11) NOT NULL,
  `puntos` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_clasificacion_torneo_torneos` (`id_torneo`),
  KEY `FK_clasificacion_torneo_jugadores` (`id_jugador`),
  CONSTRAINT `FK_clasificacion_torneo_jugadores` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_clasificacion_torneo_torneos` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=662 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para función recuperacion_chessdb_rubenvicente.func_probabilidad
DELIMITER //
CREATE FUNCTION `func_probabilidad`(`rat1` INT,
	`rat2` INT
) RETURNS float
BEGIN
	SET @c=(1*1.0
           / (1
              + 1.0
                    * pow(10,
                          1.0 * (rat1 - rat2) / 400)));

	RETURN (1*1.0
           / (1
              + 1.0
                    * pow(10,
                          1.0 * (rat1 - rat2) / 400)));
END//
DELIMITER ;

-- Volcando estructura para tabla recuperacion_chessdb_rubenvicente.inscripciones
CREATE TABLE IF NOT EXISTS `inscripciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_jugador` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `elo_actual` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `jugador_torneo` (`id_jugador`,`id_torneo`) USING BTREE,
  KEY `FK__torneos` (`id_torneo`),
  KEY `FK__jugador` (`id_jugador`) USING BTREE,
  CONSTRAINT `FK__jugadores` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK__torneos` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=923 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para procedimiento recuperacion_chessdb_rubenvicente.insertar_titulos
DELIMITER //
CREATE PROCEDURE `insertar_titulos`()
BEGIN

	truncate TABLE titulos;
	
	INSERT INTO titulos (elo, siglas, titulo)
	VALUES (2500, 'GM', 'Gran Maestro'),
	       (2400, 'MI', 'Maestro Internacional'),
	       (2300, 'MF', 'Maestro FIDE'),
	       (2200, 'CM', 'Candidato a Maestro'),
	       (1800, 'SP', 'SemiProfesional'),
	       (1500, 'AM', 'Amateur'),
	       (0, 'NO', 'newbie');
END//
DELIMITER ;

-- Volcando estructura para tabla recuperacion_chessdb_rubenvicente.jugadores
CREATE TABLE IF NOT EXISTS `jugadores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `pais` varchar(50) NOT NULL,
  `victorias` int(11) NOT NULL DEFAULT 0,
  `derrotas` int(11) NOT NULL DEFAULT 0,
  `elo` int(11) NOT NULL DEFAULT 1000,
  `titulo` varchar(20) NOT NULL DEFAULT 'newbie',
  PRIMARY KEY (`id`),
  CONSTRAINT `victorias_positivas` CHECK (`victorias` >= 0),
  CONSTRAINT `derrotas_positivas` CHECK (`derrotas` >= 0),
  CONSTRAINT `elo_positivo` CHECK (`elo` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=594 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla recuperacion_chessdb_rubenvicente.log_titulo_changed
CREATE TABLE IF NOT EXISTS `log_titulo_changed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_jugador` int(11) NOT NULL,
  `anterior_nivel` varchar(20) NOT NULL,
  `nuevo_nivel` varchar(20) NOT NULL,
  `fecha` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_log_titulo_changed_jugadores` (`id_jugador`),
  CONSTRAINT `FK_log_titulo_changed_jugadores` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla recuperacion_chessdb_rubenvicente.partidas
CREATE TABLE IF NOT EXISTS `partidas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_jugador_blancas_1` int(11) NOT NULL,
  `id_jugador_negras_2` int(11) NOT NULL,
  `id_torneo` int(11) NOT NULL,
  `ganador` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `elo1` int(11) DEFAULT NULL,
  `elo2` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_partidas_jugadores_2` (`id_jugador_negras_2`),
  KEY `FK_partidas_torneos` (`id_torneo`),
  KEY `FK_partidas_jugadores_1` (`id_jugador_blancas_1`),
  CONSTRAINT `FK_partidas_jugadores_1` FOREIGN KEY (`id_jugador_blancas_1`) REFERENCES `jugadores` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_partidas_jugadores_2` FOREIGN KEY (`id_jugador_negras_2`) REFERENCES `jugadores` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_partidas_torneos` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `diferentes_jugadores` CHECK (`id_jugador_blancas_1` <> `id_jugador_negras_2`)
) ENGINE=InnoDB AUTO_INCREMENT=604 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para procedimiento recuperacion_chessdb_rubenvicente.proc_calculateELO
DELIMITER //
CREATE PROCEDURE `proc_calculateELO`(
	INOUT `Elo1` INT,
	INOUT `Elo2` INT,
	IN `victoria1` INT
)
    DETERMINISTIC
BEGIN
	DECLARE var_prob1 FLOAT;
	DECLARE var_prob2 FLOAT;
	DECLARE const_K INT DEFAULT 28;

	-- Calculamos la probabilidad de victoria para cada caso
	--	probabilidad de victoria de jug1
	SET var_prob1=func_probabilidad(Elo2,Elo1);
	--	probabilidad de victoria de jug2
	SET var_prob2=func_probabilidad(Elo1,Elo2);
	
	SET @a=var_prob1;
	SET @b=var_prob2;
	
	-- No esta calculado para empate, por lo que lo quizas sea necesario modificar el proc o no llamarlo
	
	-- victoria1 significa que gana el jugador 1 y pierde jugador 2
	IF (victoria1=1) THEN
		SET elo1=ROUND(Elo1+const_k*(1-var_prob1));
		SET Elo2=ROUND(Elo2+const_k*(0-var_prob2));
	ELSE 
	-- este seria el caso en el jugador 2 gana y el jugador 1 pierde
		SET Elo1=Elo1+const_k*(0-var_prob1);
		SET Elo2=Elo2+const_k*(1-var_prob2);
	END if;
END//
DELIMITER ;

-- Volcando estructura para procedimiento recuperacion_chessdb_rubenvicente.sacar_clasificacion
DELIMITER //
CREATE PROCEDURE `sacar_clasificacion`(
	IN `torneo` INT
)
BEGIN
DELETE FROM clasificacion_torneo;

INSERT INTO clasificacion_torneo (id_torneo, id_jugador, puntos)
SELECT 
  inscripciones.id_torneo, inscripciones.id_jugador, (COUNT(partidas.id) * 1 + (COUNT(CASE WHEN partidas.ganador = 0 THEN 1 ELSE NULL END)) * 0.5) AS puntos FROM inscripciones
LEFT JOIN partidas ON (inscripciones.id_jugador = partidas.id_jugador_blancas_1 OR inscripciones.id_jugador = partidas.id_jugador_negras_2)
WHERE inscripciones.id_torneo = torneo
GROUP BY inscripciones.id_jugador;
END//
DELIMITER ;

-- Volcando estructura para tabla recuperacion_chessdb_rubenvicente.titulos
CREATE TABLE IF NOT EXISTS `titulos` (
  `elo` int(11) NOT NULL,
  `siglas` varchar(2) NOT NULL,
  `titulo` varchar(50) NOT NULL,
  PRIMARY KEY (`elo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla recuperacion_chessdb_rubenvicente.torneos
CREATE TABLE IF NOT EXISTS `torneos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `ciudad` varchar(50) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `max_participantes` int(11) NOT NULL,
  `max_partidas` int(11) NOT NULL,
  `premio` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ciudad_fecha` (`ciudad`,`fecha_inicio`) USING BTREE,
  CONSTRAINT `min_participantes` CHECK (`max_participantes` >= 2),
  CONSTRAINT `min_partidas` CHECK (`max_partidas` >= 2),
  CONSTRAINT `chk_fechas` CHECK (`fecha_inicio` <= `fecha_fin`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para procedimiento recuperacion_chessdb_rubenvicente.vaciar_tablas
DELIMITER //
CREATE PROCEDURE `vaciar_tablas`()
BEGIN
	DELETE FROM clasificacion_torneo;
	DELETE FROM inscripciones;
	DELETE FROM partidas;
	DELETE FROM torneos;
	DELETE FROM titulos;
	DELETE FROM log_titulo_changed;
	DELETE FROM jugadores;
END//
DELIMITER ;

-- Volcando estructura para disparador recuperacion_chessdb_rubenvicente.actualizar_jugadores
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `actualizar_jugadores` AFTER INSERT ON `partidas` FOR EACH ROW BEGIN
CALL actualizar_jugadores_tras_partida(NEW.id_jugador_blancas_1, NEW.id_jugador_negras_2, NEW.ganador);
UPDATE jugadores SET elo = NEW.elo1 WHERE id=new.id_jugador_blancas_1;
UPDATE jugadores SET elo = NEW.elo2 WHERE id=new.id_jugador_negras_2;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador recuperacion_chessdb_rubenvicente.before_insert_partidas
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_insert_partidas` BEFORE INSERT ON `partidas` FOR EACH ROW BEGIN
Set new.elo1 = (SELECT elo FROM jugadores WHERE id=new.id_jugador_blancas_1);
Set new.elo2 = (SELECT elo FROM jugadores WHERE id=new.id_jugador_negras_2);

if NEW.ganador = 1 then
	CALL proc_calculateELO(NEW.elo1,NEW.elo2,1);
ELSEIF NEW.ganador = 2 then
	CALL proc_calculateELO(NEW.elo1,NEW.elo2,2);
END if;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador recuperacion_chessdb_rubenvicente.inscripciones_before_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `inscripciones_before_insert` BEFORE INSERT ON `inscripciones` FOR EACH ROW BEGIN
  DECLARE inscritos INT;
  
  SELECT COUNT(*) INTO inscritos FROM inscripciones WHERE id_torneo = NEW.id_torneo;

  IF inscritos >= (SELECT max_participantes FROM torneos WHERE id = NEW.id_torneo) THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'El número máximo de participantes ha sido alcanzado';
  END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador recuperacion_chessdb_rubenvicente.jugadores_after_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `jugadores_after_update` BEFORE UPDATE ON `jugadores` FOR EACH ROW BEGIN
   DECLARE nuevo_titulo VARCHAR(255);
   SELECT titulo INTO nuevo_titulo FROM titulos WHERE elo <= NEW.elo ORDER BY elo DESC LIMIT 1;
	IF (nuevo_titulo <> OLD.titulo) THEN
        INSERT INTO log_titulo_changed (id_jugador,anterior_nivel,nuevo_nivel,fecha) VALUES (OLD.id,old.titulo,nuevo_titulo,NOW());
   END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
