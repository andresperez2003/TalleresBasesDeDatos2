ALTER USER "TALLER5" QUOTA UNLIMITED ON USERS;

-- Crear tipo enumerado en Oracle
CREATE OR REPLACE TYPE estado AS OBJECT (
    estado_value VARCHAR2(20)
);

-- Crear tabla de clientes
CREATE TABLE clientes (
    identificacion VARCHAR2(20) PRIMARY KEY,
    nombre VARCHAR2(100),
    edad NUMBER,
    correo VARCHAR2(100)
);

-- Crear tabla de productos
CREATE TABLE productos (
    codigo VARCHAR2(20) PRIMARY KEY,
    nombre VARCHAR2(100),
    stock NUMBER,
    valor_unitario FLOAT
);

-- Crear tabla de facturas
CREATE TABLE facturas (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    cantidad NUMBER,
    valor_total FLOAT,
    fecha DATE,
    pedido_estado estado NOT NULL,
    cliente_id VARCHAR2(20),
    producto_id VARCHAR2(20),
    FOREIGN KEY (cliente_id) REFERENCES clientes(identificacion),
    FOREIGN KEY (producto_id) REFERENCES productos(codigo)
);

-- Crear tabla de auditoría
CREATE TABLE auditoria (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    fecha_inicio DATE NOT NULL,
    fecha_final DATE NOT NULL,
    factura_id NUMBER,
    pedido_estado estado,
    FOREIGN KEY (factura_id) REFERENCES facturas(id)
);

-- Insertar datos en productos
BEGIN
INSERT INTO productos (codigo, nombre, stock, valor_unitario) VALUES('001', 'Paleta', 20, 2000);



INSERT INTO clientes(identificacion, nombre, edad, correo) VALUES ('1004367716', 'Andres', 21, 'andresap@gmail.com');

-- Insertar datos en facturas
INSERT INTO facturas(fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) VALUES (TO_DATE('2024-08-30', 'YYYY-MM-DD'), 5, 6000, estado('ENTREGADO'), '1004367716', '001');
INSERT INTO facturas(fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) VALUES (TO_DATE('2024-09-30', 'YYYY-MM-DD'), 6, 7000, estado('PENDIENTE'), '1004367716', '001');
INSERT INTO facturas(fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) VALUES (TO_DATE('2001-05-15', 'YYYY-MM-DD'), 3, 5000, estado('ENTREGADO'), '1004367716', '001');
INSERT INTO facturas(fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) VALUES (TO_DATE('2002-07-20', 'YYYY-MM-DD'), 4, 8000, estado('PENDIENTE'), '1004367716', '001');
INSERT INTO facturas(fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) VALUES (TO_DATE('2003-03-10', 'YYYY-MM-DD'), 2, 4000, estado('BLOQUEADO'), '1004367716', '001');
END;


-- Parte 1: Crear procedimiento obtener_total_stock
CREATE OR REPLACE PROCEDURE obtener_total_stock AS
    v_total_stock NUMBER := 0;
    v_stock_actual NUMBER;
    v_nombre_producto VARCHAR2(100);
BEGIN
    FOR rec IN (SELECT nombre, stock FROM productos) LOOP
        v_nombre_producto := rec.nombre;
        v_stock_actual := rec.stock;
        DBMS_OUTPUT.PUT_LINE('El nombre del producto es: ' || v_nombre_producto);
        DBMS_OUTPUT.PUT_LINE('El stock actual del producto es de: ' || v_stock_actual);
        v_total_stock := v_total_stock + v_stock_actual;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('El stock total es de: ' || v_total_stock);
END;
/

-- Llamar al procedimiento obtener_total_stock
BEGIN	
	EXEC obtener_total_stock;
END

-- Parte 2: Crear procedimiento generar_auditoria
CREATE OR REPLACE PROCEDURE generar_auditoria(
    P_fecha_inicio DATE,
    p_fecha_final DATE
) AS
    v_id_factura NUMBER;
    v_estado_factura estado;
    v_fecha DATE;
BEGIN
    FOR rec IN (
        SELECT fecha, id, pedido_estado
        FROM facturas
        WHERE fecha BETWEEN P_fecha_inicio AND p_fecha_final
    ) LOOP
        v_id_factura := rec.id;
        v_estado_factura := rec.pedido_estado;
        INSERT INTO auditoria(fecha_inicio, fecha_final, factura_id, pedido_estado)
        VALUES (P_fecha_inicio, p_fecha_final, v_id_factura, v_estado_factura);
        
        DBMS_OUTPUT.PUT_LINE('Se ha creado la auditoría para la factura: ' || v_id_factura);
    END LOOP;
END;
/

BEGIN
	-- Llamar al procedimiento generar_auditoria
	EXEC generar_auditoria(TO_DATE('2000-11-12', 'YYYY-MM-DD'), TO_DATE('2004-11-12', 'YYYY-MM-DD'));
	EXEC generar_auditoria(TO_DATE('2003-11-11', 'YYYY-MM-DD'), TO_DATE('2005-08-05', 'YYYY-MM-DD'));
END	


-- Parte 3: Crear procedimiento simular_ventas_mes
CREATE OR REPLACE PROCEDURE simular_ventas_mes AS
    v_dia NUMBER := 1;
    v_identificacion VARCHAR2(20);
    v_cantidad_random NUMBER;
BEGIN
    WHILE v_dia <= 30 LOOP
        FOR rec IN (SELECT identificacion FROM clientes) LOOP
            v_identificacion := rec.identificacion;
            v_cantidad_random := TRUNC(DBMS_RANDOM.VALUE(1, 3));  -- Generar cantidad aleatoria entre 1 y 2
            
            INSERT INTO facturas(fecha, cantidad, valor_total, pedido_estado, producto_id, cliente_id)
            VALUES (TO_DATE('2024-09-02', 'YYYY-MM-DD'), v_cantidad_random, 30000, estado('ENTREGADO'), '001', v_identificacion);
            
            DBMS_OUTPUT.PUT_LINE('Se creó una factura para el cliente: ' || v_identificacion);
        END LOOP;
        v_dia := v_dia + 1;
    END LOOP;
END;
/

-- Llamar al procedimiento simular_ventas_mes
BEGIN
	EXEC simular_ventas_mes;
END
