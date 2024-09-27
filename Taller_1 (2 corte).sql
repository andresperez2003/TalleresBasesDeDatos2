create table empleados (
	identificacion serial primary key,
	nombre varchar not null,
	tipo_contrato int not null,
	
	foreign key (tipo_contrato) references tipo_contrato(id)
)

create table tipo_contrato (
	id serial primary key,
	descripcion varchar not null,
	cargo varchar null,
	salario_total numeric not null
)

create table conceptos(
	codigo serial primary key,
	nombre varchar check (nombre in ('salario','horas_extras','prestaciones','impuestos')),
	porcentaje numeric
)

create table nomina(
	id serial primary key,
	mes varchar check (mes in ('01','02','03','04','05','06','07','08','09','10','11','12')),
	año varchar,
	fecha_pago date,
	total_devengado numeric,
	total_deducciones numeric,
	total numeric,
	cliente_id int,
	foreign key (cliente_id) references empleados(identificacion)
)


create table detalles_nomina(
	id serial primary key,
	valor numeric,
	concepto_id int,
	nomina_id int,
	foreign key (concepto_id) references conceptos(codigo),
	foreign key (nomina_id) references nomina(id)
)

CREATE OR REPLACE PROCEDURE insertar_tipo_contratos()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) VALUES ('1', 'Indefinido', 'Gerente', 5000.00);
    INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) VALUES ('2', 'Temporal', 'Asistente', 1500.00);
    INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) VALUES ('3', 'Por obra', 'Supervisor', 2000.00);
    INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) VALUES ('4', 'Indefinido', 'Jefe de proyecto', 4500.00);
    INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) VALUES ('5', 'Temporal', 'Analista', 2200.00);
    INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) VALUES ('6', 'Por obra', 'Desarrollador', 3000.00);
    INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) VALUES ('7', 'Indefinido', 'Consultor', 3500.00);
    INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) VALUES ('8', 'Temporal', 'Soporte Técnico', 1800.00);
    INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) VALUES ('9', 'Indefinido', 'Administrador de Redes', 4000.00);
    INSERT INTO tipo_contrato (id, descripcion, cargo, salario_total) VALUES ('10', 'Por obra', 'Diseñador Gráfico', 2500.00);
END;
$$;


CREATE OR REPLACE PROCEDURE insertar_empleados()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO empleados (nombre, tipo_contrato) VALUES ('Juan Pérez', 1);
    INSERT INTO empleados (nombre, tipo_contrato) VALUES ('María López', 2);
    INSERT INTO empleados (nombre, tipo_contrato) VALUES ('Pedro García', 3);
    INSERT INTO empleados (nombre, tipo_contrato) VALUES ('Lucía Gómez', 4);
    INSERT INTO empleados (nombre, tipo_contrato) VALUES ('Carlos Fernández', 5);
    INSERT INTO empleados (nombre, tipo_contrato) VALUES ('Sofía Martínez', 6);
    INSERT INTO empleados (nombre, tipo_contrato) VALUES ('Luis Ramírez', 7);
    INSERT INTO empleados (nombre, tipo_contrato) VALUES ('Ana Sánchez', 8);
    INSERT INTO empleados (nombre, tipo_contrato) VALUES ('Ricardo Torres', 9);
    INSERT INTO empleados (nombre, tipo_contrato) VALUES ('Gabriela Morales', 10);
END;
$$;

CREATE OR REPLACE PROCEDURE insertar_nominas()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO nomina (mes, año, fecha_pago, total_devengado, total_deducciones, total, cliente_id) 
    VALUES ('01', '2024', '2024-01-31', 3000.00, 500.00, 2500.00, 1);
    
    INSERT INTO nomina (mes, año, fecha_pago, total_devengado, total_deducciones, total, cliente_id) 
    VALUES ('02', '2024', '2024-02-28', 3200.00, 600.00, 2600.00, 2);
    
    INSERT INTO nomina (mes, año, fecha_pago, total_devengado, total_deducciones, total, cliente_id) 
    VALUES ('03', '2024', '2024-03-31', 3500.00, 700.00, 2800.00, 3);
    
    INSERT INTO nomina (mes, año, fecha_pago, total_devengado, total_deducciones, total, cliente_id) 
    VALUES ('04', '2024', '2024-04-30', 4000.00, 800.00, 3200.00, 4);
    
    INSERT INTO nomina (mes, año, fecha_pago, total_devengado, total_deducciones, total, cliente_id) 
    VALUES ('05', '2024', '2024-05-31', 4500.00, 900.00, 3600.00, 5);
END;
$$;

CREATE OR REPLACE PROCEDURE insertar_detalles_nomina()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (500.00, 1, 1);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (2500.00, 2, 1);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (600.00, 3, 2);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (2600.00, 4, 2);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (700.00, 5, 3);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (2800.00, 6, 3);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (800.00, 7, 4);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (3200.00, 8, 4);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (900.00, 9, 5);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (3600.00, 10, 5);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (150.00, 11, 1);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (200.00, 12, 2);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (250.00, 13, 3);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (300.00, 14, 4);
    INSERT INTO detalles_nomina (valor, concepto_id, nomina_id) VALUES (350.00, 15, 5);
END;
$$;

CREATE OR REPLACE PROCEDURE insertar_conceptos()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('salario', 100.00);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('salario', 100.00);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('salario', 100.00);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('horas_extras', 10.00);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('horas_extras', 15.00);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('horas_extras', 12.50);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('prestaciones', 8.50);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('prestaciones', 7.75);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('prestaciones', 9.00);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('impuestos', 12.00);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('impuestos', 13.50);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('impuestos', 11.25);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('salario', 100.00);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('horas_extras', 14.00);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('prestaciones', 8.25);
    INSERT INTO conceptos (nombre, porcentaje) VALUES ('impuestos', 10.50);
END;
$$;

CREATE OR REPLACE FUNCTION obtener_nomina_empleado(emp_identificacion int, nomina_mes varchar, nomina_año varchar)
RETURNS TABLE (
    nombre_empleado varchar,
    total_devengado numeric,
    total_deducido numeric,
    total_nomina numeric
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT e.nombre, n.total_devengado, n.total_deducciones, n.total FROM empleados e JOIN nomina n ON e.identificacion = n.cliente_id
    WHERE e.identificacion = emp_identificacion AND n.mes = nomina_mes AND n.año = nomina_año;
END;
$$;

CREATE OR REPLACE FUNCTION total_por_contrato(
    tipo_contrato_param int
)
RETURNS TABLE (
    nombre_empleado varchar,
    fecha_pago date,
    año varchar,
    mes varchar,
    total_devengado numeric,
    total_deducido numeric,
    total_nomina numeric
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT e.nombre, n.fecha_pago, n.año, n.mes, n.total_devengado, n.total_deducciones, n.total FROM empleados e JOIN nomina n ON e.identificacion = n.cliente_id WHERE  e.tipo_contrato = tipo_contrato_param;
END;
$$;




call insertar_tipo_contratos();
call insertar_empleados();
call insertar_nominas();
call insertar_detalles_nomina();
call insertar_conceptos();

select * from obtener_nomina_empleado(1, '01', '2024');
select * from total_por_contrato(1);
