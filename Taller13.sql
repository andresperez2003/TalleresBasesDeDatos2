/* 
TALLER 13 TRIGGERS
Se tienen las siguientes tablas:
empleado: nombre, identificación (pk), edad, correo, salario.
Nomina: fecha, total ingresos, total deducciones, total neto, usuario_id.
Detalle de nomina: concepto, tipo, valor, nomina_id.
1. Realizar un trigger before insert, para que antes de insertar una nomina validar que en el mes en que se está haciendo la nomina de un empleado no supere el presupuesto de nomina de 12.000.000.
2. Realizar un trigger after insert para que después de insertar una nueva nomina, se agrege un registro a una tabla auditoria_nomina (fecha, nombre, identificación, total neto).
3. Realizar un trigger before update para que antes de actualizar a un empleado en su salario no supere el presupuesto de nomina de 12.000.000.
4. Realizar un trigger after update para que después de actualizar el salario de un empleado guardar un registro en la tabla auditoria_empleado (fecha, nombre, identificación, concepto, valor), donde concepto es si es un "AUMENTO" O "DISMINUCION" al salario y el dato es edl valor aumentado o disminuido. 
*/

CREATE TABLE empleado (
    nombre VARCHAR(100),
    identificacion INT PRIMARY KEY,
    edad INT,
    correo VARCHAR(100),
    salario NUMERIC
);

CREATE TABLE nomina (
    id SERIAL PRIMARY KEY,
    fecha DATE,
    total_ingresos NUMERIC,
    total_deducciones NUMERIC,
    total_neto NUMERIC,
    usuario_id INT,
    FOREIGN KEY (usuario_id) REFERENCES empleado(identificacion)
);

CREATE TABLE detalle_de_nomina (
    id SERIAL PRIMARY KEY,
    concepto VARCHAR(100),
    tipo VARCHAR(50),
    valor NUMERIC,
    nomina_id INT,
    FOREIGN KEY (nomina_id) REFERENCES nomina(id)
);

CREATE TABLE auditoria_nomina (
    id serial PRIMARY KEY,
    fecha DATE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    identificacion INTEGER NOT NULL,
    total_neto NUMERIC(12, 2) NOT NULL
);

CREATE TABLE auditoria_empleado (
    id serial PRIMARY KEY,
    fecha DATE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    identificacion INTEGER NOT NULL,
    concepto VARCHAR(20) NOT NULL,  
    valor NUMERIC(12, 2) NOT NULL
);

INSERT INTO empleado (nombre, identificacion, edad, correo, salario)
VALUES 
('Laura Ramírez', 101112, 27, 'laura.ramirez@email.com', 3200000),
('Pedro Sánchez', 131415, 29, 'pedro.sanchez@email.com', 3700000),
('Elena Castro', 161718, 32, 'elena.castro@email.com', 2900000);


INSERT INTO nomina (fecha, total_ingresos, total_deducciones, total_neto, usuario_id)
VALUES 
('2024-01-15', 3200000, 600000, 2600000, 101112), 
('2024-01-20', 3600000, 700000, 2900000, 131415),  
('2024-01-25', 3000000, 500000, 2500000, 161718);  


INSERT INTO nomina (fecha, total_ingresos, total_deducciones, total_neto, usuario_id)
VALUES ('2024-02-10', 12000000, 1500000, 10500000, 101112);


UPDATE empleado
SET salario = 7000000
WHERE identificacion = 654321; 


CREATE OR REPLACE FUNCTION validar_presupuesto_nomina()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    total_nomina_mes NUMERIC;
BEGIN

    SELECT SUM(total_neto) INTO total_nomina_mes
    FROM nomina
    WHERE EXTRACT(MONTH FROM fecha) = EXTRACT(MONTH FROM NEW.fecha)
    AND EXTRACT(YEAR FROM fecha) = EXTRACT(YEAR FROM NEW.fecha)
    AND usuario_id = NEW.usuario_id;

    -- Verificar si la suma supera el presupuesto permitido
    IF (total_nomina_mes + NEW.total_neto) > 12000000 THEN
        RAISE EXCEPTION 'El presupuesto de nómina para este mes ha sido superado.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_validar_presupuesto_nomina
BEFORE INSERT ON nomina
FOR EACH ROW
EXECUTE FUNCTION validar_presupuesto_nomina();


CREATE OR REPLACE FUNCTION auditar_nomina()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO auditoria_nomina(fecha, nombre, identificacion, total_neto)
    SELECT NOW(), e.nombre, e.identificacion, NEW.total_neto
    FROM empleado e
    WHERE e.identificacion = NEW.usuario_id;

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_auditar_nomina
AFTER INSERT ON nomina
FOR EACH ROW
EXECUTE FUNCTION auditar_nomina();


CREATE OR REPLACE FUNCTION validar_actualizacion_salario()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    total_salario NUMERIC;
BEGIN
    
    SELECT SUM(salario) INTO total_salario
    FROM empleado
    WHERE identificacion != OLD.identificacion;

    IF (total_salario + NEW.salario) > 12000000 THEN
        RAISE EXCEPTION 'El presupuesto de salarios ha sido superado.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_validar_actualizacion_salario
BEFORE UPDATE OF salario ON empleado
FOR EACH ROW
EXECUTE FUNCTION validar_actualizacion_salario();


CREATE OR REPLACE FUNCTION auditar_actualizacion_empleado()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    concepto VARCHAR(20);
    diferencia NUMERIC;
BEGIN

    IF NEW.salario > OLD.salario THEN
        concepto := 'AUMENTO';
        diferencia := NEW.salario - OLD.salario;
    ELSE
        concepto := 'DISMINUCION';
        diferencia := OLD.salario - NEW.salario;
    END IF;

    INSERT INTO auditoria_empleado(fecha, nombre, identificacion, concepto, valor)
    VALUES(NOW(), NEW.nombre, NEW.identificacion, concepto, diferencia);

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_auditar_actualizacion_empleado
AFTER UPDATE OF salario ON empleado
FOR EACH ROW
EXECUTE FUNCTION auditar_actualizacion_empleado();


