create type estadoUsuario as enum('activo', 'inactivo');
create type tipoTarjeta  as enum('visa', 'mastercard');
create type categoriaProducto as enum('celular', 'pc', 'televisor');
create type estadoPago  as enum('exitoso','faliido');


create table examen.usuarios(
	id serial primary key,
	nombre varchar(30),
	direccion varchar(60),
	email varchar(30),
	fecha_registro date,
	estado estadoUsuario
);

create table examen.tarjetas(
	id serial primary key,
	numero_tarjeta  varchar(30),
	fecha_expiracion date,
	cvv varchar(4),
	tipo_tarjeta tipoTarjeta
);

create table examen.productos(
	id serial primary key,
	codigo_producto varchar(30),
	fecha date,
	categoria categoriaProducto,
	porcentaje_impuesto numeric,
	precio numeric
	);
	

create table examen.pagos(
	id serial primary key,
	codigo_pago varchar(10),
	estado estadoPago ,
	monto numeric,
	producto_id int references productos(id),
	tarjeta_id int references tarjetas(id),
	usuario_id int references usuarios(id)
);


create table examen.comprobantesXML(
	id serial primary key,
	detalle_xml xml
);


create table examen.comprobantesJSON(
	id serial primary key,
	detalle_sjon jsonb
);


insert into usuarios(nombre,direccion, email,fecha_registro, estado) values 
('Andres', 'Calle 49', 'andresap2017@gmail.com', '2024-05-12', 'activo'),
('Juan', 'Calle 49','juan@gmail.com', '2023-12-02', 'inactivo');


insert into tarjetas(numero_tarjeta, fecha_expiracion, cvv, tipo_tarjeta) values
('001', '2023-05-15', '0001', 'visa'),
('002','2023-04-12', '0002', 'mastercard'),
('003','2024-06-09', '0003', 'visa'),
('004', '2024-05-07', '0004', 'mastercard');


insert into productos(codigo_producto, fecha, categoria, porcentaje_impuesto, precio) values
('001','2024-12-05', 'celular', 10, 10000),
('002', '2024-12-04', 'pc',20, 20000),
('002', '2024-12-07', 'televisor',15, 2000);




--Punto 1

--Parte 1

CREATE OR REPLACE FUNCTION obtener_pagos_usuario(usuario_id int, fecha date)
RETURNS TABLE(codigo_pago varchar, nombre_producto varchar, monto numeric, estado estadoPago) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.codigo_pago,
        pr.codigo_producto AS nombre_producto,
        p.monto,
        p.estado
    FROM 
        examen.pagos p
    JOIN 
        examen.productos pr ON p.producto_id = pr.id
    WHERE 
        p.usuario_id = usuario_id
        AND p.fecha = fecha;
END;
$$ LANGUAGE plpgsql;


--Parte 2
CREATE OR REPLACE FUNCTION obtener_tarjetas_usuario(usuario_id INT)
RETURNS TABLE(nombre_usuario VARCHAR, email VARCHAR, numero_tarjeta VARCHAR, cvv VARCHAR, tipo_tarjeta tipoTarjeta) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.nombre,
        u.email,
        t.numero_tarjeta,
        t.cvv,
        t.tipo_tarjeta
    FROM 
        examen.usuarios u
    JOIN 
        examen.tarjetas t ON u.id = t.usuario_id
    JOIN 
        examen.pagos p ON t.id = p.tarjeta_id
    WHERE 
        u.id = usuario_id;
END;
$$ LANGUAGE plpgsql;




--Pregunta 2

--Parte 1

CREATE OR REPLACE FUNCTION obtener_tarjetas_con_detalle(usuario_id INT)
RETURNS TEXT AS $$
DECLARE
    tarjeta_cursor CURSOR FOR
    SELECT 
        t.numero_tarjeta,
        t.fecha_expiracion,
        u.nombre,
        u.email
    FROM 
        tarjetas t
    JOIN 
        usuarios u ON t.usuario_id = u.id
    WHERE 
        t.usuario_id = usuario_id;

    tarjeta_record RECORD;
    resultado TEXT := '';

BEGIN
    OPEN tarjeta_cursor;

    LOOP
        FETCH tarjeta_cursor INTO tarjeta_record;
        EXIT WHEN NOT FOUND;
        
        resultado := resultado || 
            'Número de tarjeta: ' || tarjeta_record.numero_tarjeta || ', ' ||
            'Fecha de expiración: ' || tarjeta_record.fecha_expiracion || ', ' ||
            'Nombre: ' || tarjeta_record.nombre || ', ' ||
            'Email: ' || tarjeta_record.email || '; ';
    END LOOP;

    CLOSE tarjeta_cursor;
    
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;


-- Parte 2
CREATE OR REPLACE FUNCTION obtener_pagos_menores_a(fecha DATE)
RETURNS TEXT AS $$
DECLARE
    pagos_cursor CURSOR FOR
    SELECT 
        p.monto,
        p.estado,
        p.nombre_producto,
        p.porcentaje_impuesto,
        u.direccion AS usuario_direccion,
        u.email
    FROM 
        pagos p
    JOIN 
        usuarios u ON p.usuario_id = u.id
    WHERE 
        p.monto < 1000 AND
        p.fecha = fecha;

    pagos_record RECORD;
    resultado TEXT := '';

BEGIN
    OPEN pagos_cursor;

    LOOP
        FETCH pagos_cursor INTO pagos_record;
        EXIT WHEN NOT FOUND;
        
        resultado := resultado || 
            'Monto: ' || pagos_record.monto || ', ' ||
            'Estado: ' || pagos_record.estado || ', ' ||
            'Nombre del producto: ' || pagos_record.nombre_producto || ', ' ||
            'Porcentaje de impuesto: ' || pagos_record.porcentaje_impuesto || ', ' ||
            'Dirección: ' || pagos_record.usuario_direccion || ', ' ||
            'Email: ' || pagos_record.email || '; ';
    END LOOP;

    CLOSE pagos_cursor;
    
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;


--Parte 3
CREATE OR REPLACE FUNCTION guardar_xml(
    codigo_pago VARCHAR,
    nombre_usuario VARCHAR,
    numero_tarjeta VARCHAR,
    nombre_producto VARCHAR,
    monto_pago NUMERIC
)
RETURNS VOID AS $$
DECLARE
    xml_data XML;
BEGIN
    xml_data := 
        '<pago>' ||
        '<codigoPago>' || codigo_pago || '</codigoPago>' ||
        '<nombreUsuario>' || nombre_usuario || '</nombreUsuario>' ||
        '<numeroTarjeta>' || numero_tarjeta || '</numeroTarjeta>' ||
        '<nombreProducto>' || nombre_producto || '</nombreProducto>' ||
        '<montoPago>' || monto_pago || '</montoPago>' ||
        '</pago>';

    INSERT INTO comprobantesXML(detalle_xml) VALUES (xml_data);
END;
$$ LANGUAGE plpgsql;


--Parte 4
CREATE OR REPLACE procedure guardar_json(
    email_usuario VARCHAR,
    numero_tarjeta VARCHAR,
    tipo_tarjeta tipoTarjeta,
    codigo_producto VARCHAR,
    codigo_pago VARCHAR,
    monto_pago NUMERIC
)
AS $$
DECLARE
    json_data JSONB;
BEGIN
    json_data := jsonb_build_object(
        'emailUsuario', email_usuario,
        'numeroTarjeta', numero_tarjeta,
        'tipoTarjeta', tipo_tarjeta,
        'codigoProducto', codigo_producto,
        'codigoPago', codigo_pago,
        'montoPago', monto_pago
    );

    INSERT INTO comprobantesJSON(detalle_json) VALUES (json_data);
END;
$$ LANGUAGE plpgsql;



--Pregunta 3

-- Parte 1
CREATE OR REPLACE FUNCTION validacion_producto()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que el precio esté entre 0 y 20000
    IF NEW.precio <= 0 OR NEW.precio >= 20000 THEN
        RAISE EXCEPTION 'El precio debe ser mayor a 0 y menor a 20,000';
    END IF;
    
    -- Validar que el porcentaje de impuesto esté entre 1% y 20%
    IF NEW.porcentaje_impuesto < 1 OR NEW.porcentaje_impuesto > 20 THEN
        RAISE EXCEPTION 'El porcentaje de impuesto debe ser mayor a 1% y menor o igual a 20%';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validacione_producto
BEFORE INSERT OR UPDATE ON examen.productos
FOR EACH ROW
EXECUTE FUNCTION validacion_producto();


-- Parte 2
CREATE OR REPLACE FUNCTION almacenar_comprobantes()
RETURNS TRIGGER AS $$
DECLARE
    xml_data XML;
    json_data JSONB;
BEGIN

    xml_data := 
        XMLFORMAT(
            '<comprobante><usuario_id>%s</usuario_id><producto_id>%s</producto_id><monto>%s</monto></comprobante>',
            NEW.usuario_id, NEW.producto_id, NEW.monto
        );
        
    json_data := jsonb_build_object(
        'usuario_id', NEW.usuario_id,
        'producto_id', NEW.producto_id,
        'monto', NEW.monto
    );

 
    INSERT INTO examen.comprobantesXML (detalle_xml) VALUES (xml_data);

  
    INSERT INTO examen.comprobantesJSON (detalle_json) VALUES (json_data);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cml
AFTER INSERT ON examen.pagos
FOR EACH ROW
EXECUTE FUNCTION almacenar_comprobantes();



--Pregunta 4

-- Parte 1

CREATE SEQUENCE seq_codigo_producto
START WITH 5
INCREMENT BY 5;


--Parte 2

CREATE SEQUENCE seq_codigo_unico_pagos
START WITH 1
INCREMENT BY 100;


--Parte 3
CREATE OR REPLACE FUNCTION obtener_info_xml()
RETURNS TABLE (nombre_usuario VARCHAR, nombre_producto VARCHAR, monto_pago NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT
        xpath('//nombre_usuario/text()', detalle_xml)::TEXT AS nombre_usuario,
        xpath('//nombre_producto/text()', detalle_xml)::TEXT AS nombre_producto,
        xpath('//monto/text()', detalle_xml)::NUMERIC AS monto_pago
    FROM
        comprobantesXML;
END;
$$ LANGUAGE plpgsql;

--Parte 4
CREATE OR REPLACE FUNCTION obtener_info_json()
RETURNS TABLE (email_usuario VARCHAR, codigo_producto VARCHAR, monto_pago NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT
        detalle_json->>'email_usuario' AS email_usuario,
        detalle_json->>'codigo_producto' AS codigo_producto,
        (detalle_json->>'monto_pago')::NUMERIC AS monto_pago
    FROM
        exmen.comprobantesJSON;
END;
$$ LANGUAGE plpgsql;











































