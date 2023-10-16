-- 1. Victorias por defecto 0
-- 2. Elo por defecto 1000 
	INSERT INTO jugadores (nombre, apellido, pais) VALUES ('Juan', 'Pérez', 'Argentina');
	SELECT * from jugadores order BY id DESC LIMIT 5;
	-- Al introducir un nuevo jugador sin indicarle los valores de victoria y elo observamos que por defecto pone 0 y 1000 

-- 3. Victorias no puede ser negativo
	INSERT INTO jugadores (victorias) values (-1);
	-- Da error por q las victorias ni las derrotas pueden ser negativas

-- 4. ELO no puede ser negativo
	INSERT INTO jugadores (elo) values (-1);
	-- Da error por que el Elo no puede ser negativo

-- 5. Un mismo jugador no puede inscribirse 2 veces
	INSERT INTO torneos (nombre, ciudad, fecha_inicio, fecha_fin, max_participantes, max_partidas, premio)
	VALUES ('Torneo de Ajedrez Aleatorio', 'Ciudad Aleatoria','2023-05-20', '2023-05-25', 20, 5, 'jamon');
	INSERT INTO jugadores (nombre, apellido, pais) VALUES ('Juan', 'Pérez', 'Argentina');
	INSERT INTO inscripciones (id_jugador, id_torneo, elo_actual) VALUES (1, 1, 1000);
	INSERT INTO inscripciones (id_jugador, id_torneo, elo_actual) VALUES (1, 1, 1000);
	-- Da error por que no puede haber el mismo jugador inscrito dos veces en un torneo

-- 6. No es posible un mismo torneo en misma ciudad y año
	INSERT INTO torneos (nombre, ciudad, fecha_inicio, fecha_fin, max_participantes, max_partidas, premio)
	VALUES ('Torneo de Ajedrez Aleatorio', 'Ciudad Aleatoria','2023-05-20', '2023-05-25', 20, 5, 'jamon');
	INSERT INTO torneos (nombre, ciudad, fecha_inicio, fecha_fin, max_participantes, max_partidas, premio)
	VALUES ('Torneo de Ajedrez Verano', 'Ciudad Aleatoria','2023-05-20', '2023-05-25', 20, 5, 'jamon');
	-- Da error por que no puede haber un torneo el mismo año en la misma ciudad

-- 8. Fecha de inicio no puede superior a fecha fin
	INSERT INTO torneos (nombre, ciudad, fecha_inicio, fecha_fin, max_participantes, max_partidas, premio)
	VALUES ('Torneo de Ajedrez Aleatorio', 'Ciudad Aleatoria','2024-06-20', '2023-05-25', 20, 5, 'jamon');
	-- Da error por que la fecha de inicio es mas tarde que la de final

-- 9. max_participantes >2
	INSERT INTO torneos (nombre, ciudad, fecha_inicio, fecha_fin, max_participantes, max_partidas, premio)
	VALUES ('Torneo de Ajedrez Verano', 'Ciudad Aleatoria','2023-05-20', '2023-05-25', 1, 5, 'jamon');
	-- Da error al intentar insertar como numero maximo de participantes 1

-- 10. max_partidas > 1
	INSERT INTO torneos (nombre, ciudad, fecha_inicio, fecha_fin, max_participantes, max_partidas, premio)
	VALUES ('Torneo de Ajedrez Verano', 'Ciudad Aleatoria','2023-05-20', '2023-05-25', 20, 0, 'jamon');
	-- Da error al intentar insertar como numero maximo de partidas 0

-- 12. Un jugador no puede jugar contra si mismo
	INSERT INTO partidas (id_jugador_blancas_1, id_jugador_negras_2, id_torneo, ganador, fecha, hora, elo1, elo2) 
	VALUES (1, 1, 1, 1, '2024-06-05', '17:30', 1000, 1000);
	-- Da error al intentar insertar la partida por que el jugador de negras y el de blancas son el mismo

-- 14. Calcular y guardar ELO tras la partida
    call alta_jugadores();
    call alta_torneos();
    call alta_inscripciones();
    call alta_partidas();
    select * from jugadores order by elo desc;

-- 15. Actualizar victorias/derrotas
    call alta_jugadores();
    call alta_torneos();
    call alta_inscripciones();
    call alta_partidas();
    select * from jugadores order by victorias desc;

-- 16. Asignar titulos inicialmente
	INSERT INTO jugadores (nombre, apellido, pais) VALUES ('Juan', 'Pérez', 'Argentina');
	SELECT * from jugadores order BY id DESC LIMIT 5;
    -- Al introducir un nuevo jugador sin indicarle el valor de titulo y elo observamos que por defecto pone newbie 

-- 17. Asignar titulos cuando sube ELO

-- 18. Auditoria ELO
    call alta_jugadores();
    call insertar_titulos();
    UPDATE jugadores SET elo = 2000 WHERE id=[id jugador];
    SELECT * FROM log_titulo_changed;

-- 19. Vaciado de tablas
    call vaciar_tablas();
    SELECT * from jugadores;
    SELECT * from torneos;
    SELECT * from inscripciones;
    SELECT * from partidas;
    SELECT * from titulos;
    SELECT * from clasificacion_torneo;
    SELECT * from log_titulo_changed;

-- 20. Rellene la tabla maestra con los títulos
    call insertar_titulos();
    select * from titulos;

-- 21. Procedure que de da alta 20 jugadores
    call alta_jugadores();
    select * from jugadores;

-- 22. Procedure que de da alta 3 torneos
    call alta_torneos();
    select * from torneos;

-- 23. Procedure que inscriba a 20 jugadores en un torneo
    call alta_inscripciones();
    select * from inscripciones;

-- 24. Procedure que genere 10 partidas de un torneo
    call alta_partidas();
    select * from partidas;

-- 25. Generar Tabla Clasificacion
    call sacar_clasificacion([id torneo queremos clasificacion]);
    select * from clasificacion_torneo;

-- 26. Funcionalidad Extra Rehacer Partida