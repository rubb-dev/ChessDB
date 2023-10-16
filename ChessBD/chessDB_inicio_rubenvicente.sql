-- En este fichero deben estar toda la secuencia de inicio de procedures
-- Vaciado de tablas
call vaciar_tablas();
-- Tabla maestra titulos
call insertar_titulos();
-- Alta jugadores
call alta_jugadores();
-- ALta torneos
call alta_torneos();
-- Alta iscripciones
call alta_inscripciones();
-- Alta partidas
call alta_partidas();