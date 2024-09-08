create type "estados" as enum('PAGO', 'NO PAGO', 'PENDIENTE_PAGO');




create table clientes(
identificacion varchar primary key,
nombre varchar,
email varchar,
direccion varchar,
telefono varchar
);

create table servicios(
id varchar primary key,
codigo varchar,
tipo varchar,
monto float,
cuota float,
intereses float,
valor_total float,
cliente_id varchar,
estado estados,
foreign key(cliente_id) references clientes(identificacion)
);

create table pagos(
id varchar primary key,
codigo_transaccion varchar,
fecha_pago date,
total numeric,
servicio_id varchar,
foreign key (servicio_id) references servicios(id)
);



CREATE OR REPLACE PROCEDURE poblar_clientes()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    nombre_aleatorio VARCHAR;
    email_aleatorio VARCHAR;
    direccion_aleatoria VARCHAR;
    telefono_aleatorio VARCHAR;
BEGIN
    FOR i IN 1..50 LOOP
nombre_aleatorio := 
    (ARRAY['Ja', 'Ma', 'Pe', 'Lu', 'An', 'Fe', 'So', 'Ro'])[floor(random() * 8 + 1)::int] ||
    (ARRAY['na', 'ri', 'dro', 'ra', 'sa', 'to', 'ro'])[floor(random() * 7 + 1)::int];

        
        -- Genera un email aleatorio basado en el nombre
        email_aleatorio := lower(nombre_aleatorio) || i || '@example.com';
        
        -- Genera una dirección aleatoria
        direccion_aleatoria := 'Direccion ' || i;
        
        -- Genera un número de teléfono aleatorio
        telefono_aleatorio := '300' || (1000000 + floor(random() * 8999999)::int)::varchar;
        
        -- Inserta el cliente en la tabla
        INSERT INTO clientes(identificacion, nombre, email, direccion, telefono) 
        VALUES (i::varchar, nombre_aleatorio, email_aleatorio, direccion_aleatoria, telefono_aleatorio);
    END LOOP;
END;
$$;


call poblar_clientes(); 

CREATE OR REPLACE PROCEDURE poblar_servicios()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
	J INT;
    nombre_aleatorio VARCHAR;
    email_aleatorio VARCHAR;
    direccion_aleatoria VARCHAR;
    telefono_aleatorio VARCHAR;
BEGIN
    FOR i IN 1..50 LOOP
nombre_aleatorio := 
    (ARRAY['Ja', 'Ma', 'Pe', 'Lu', 'An', 'Fe', 'So', 'Ro'])[floor(random() * 8 + 1)::int] ||
    (ARRAY['na', 'ri', 'dro', 'ra', 'sa', 'to', 'ro'])[floor(random() * 7 + 1)::int];

        
        FOR j IN 1..3 LOOP
			INSERT INTO servicios(id,codigo_transaccion,fecha_pago,total, estado ,cliente_id) 
	        VALUES (.. , .. , .. , .. , .. , i::varchar );
    	END LOOP;
END;
$$;


select* from clientes;

