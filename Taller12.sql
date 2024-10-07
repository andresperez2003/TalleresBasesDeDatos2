create table envios (
	id serial primary key,
	fecha_envio date,
	destino varchar,
	observacion varchar,
	estado varchar check (estado in ('pendiente','en ruta', 'entregado'))
)


CREATE OR REPLACE PROCEDURE poblar_envios()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    fecha DATE;
    destino TEXT;
    observacion TEXT;
    estado TEXT;
    estados TEXT[] := ARRAY['pendiente', 'en ruta', 'entregado'];
BEGIN
    FOR i IN 1..50 LOOP
        fecha := CURRENT_DATE - (TRUNC(RANDOM() * 90)::INT);
        destino := (ARRAY['manizales', 'pereira', 'bogota', 'cali', 'medellin', 'pasto'])[TRUNC(RANDOM() * 6 + 1)::INT];
        observacion := (ARRAY['ninguna', 'entregar en la tarde', 'urgente', 'frágil'])[TRUNC(RANDOM() * 4 + 1)::INT];
        estado := estados[TRUNC(RANDOM() * 3 + 1)::INT];
        INSERT INTO envios (fecha_envio, destino, observacion, estado) VALUES (fecha, destino, observacion, estado);
    END LOOP;
END $$;


call poblar_envios();




CREATE OR REPLACE PROCEDURE primera_fase_envio()
LANGUAGE plpgsql
AS $$
DECLARE
    envio_cursor CURSOR FOR
        SELECT id FROM envios WHERE estado = 'pendiente';
    envio_id INT;
BEGIN
    OPEN envio_cursor;
    LOOP
        FETCH envio_cursor INTO envio_id;
        EXIT WHEN NOT FOUND;
        UPDATE envios
        SET observacion = 'primera etapa del envio',
            estado = 'en ruta'
        WHERE id = envio_id;
    END LOOP;
    CLOSE envio_cursor;
END $$;

call primera_fase_envio();

CREATE OR REPLACE PROCEDURE ultima_fase_envio()
LANGUAGE plpgsql
AS $$
DECLARE
    envio_cursor CURSOR FOR
        SELECT id FROM envios 
        WHERE estado = 'en ruta' 
        AND fecha_envio <= CURRENT_DATE - INTERVAL '5 days';
    envio_id INT;
BEGIN
    OPEN envio_cursor;
    LOOP
        FETCH envio_cursor INTO envio_id;
        EXIT WHEN NOT FOUND;
        UPDATE envios
        SET observacion = 'envio realizado satistactoriamente',
            estado = 'entregado'
        WHERE id = envio_id;
    END LOOP;
    CLOSE envio_cursor;
END $$;

call ultima_fase_envio();


select * from envios;