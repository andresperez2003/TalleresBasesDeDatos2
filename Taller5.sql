create or replace procedure obtener_total_stock()
language plpgsql
as $$
declare 
v_total_stock integer:= 0;
v_stock_actual integer;
v_nombre_producto varchar;
begin
for v_nombre_producto, v_stock_actual in select nombre, stock from productos
loop
raise notice 'El nombre del producto es: %', v_nombre_producto;
raise notice 'El stock actual del producto es de: %', v_stock_actual;
v_total_stock := v_total_stock + v_stock_actual;
end loop;
raise notice 'El stock total es de: %', v_total_stock;
end;
$$;

call obtener_total_stock();

create type estado as enum ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO');

create table clientes(
identificacion varchar primary key,
nombre varchar,
edad int,
correo varchar
);

create table productos(
codigo varchar primary key,
nombre varchar,
stock int,
valor_unitario float
);

create table facturas(
id varchar primary key,
cantidad int,
valor_total float,
fecha date,
pedido_estado estado not null,
cliente_id varchar,
producto_id varchar,
foreign key(cliente_id) references clientes(identificacion),
foreign key(producto_id) references productos(codigo)
);

create table auditoria(
id serial primary key,
fecha_inicio date not null,
fecha_final date not null,
factura_id varchar,
pedido_estado estado,
foreign key(factura_id) references facturas(id)
);


insert into productos(codigo, nombre, stock, valor_unitario) values('001', 'Paleta', 20, 2000);
insert into clientes(identificacion, nombre, edad, correo) values ('1004367716', 'Andres', 21, 'andresap@gmail.com');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) values ('1', '2024-08-30', 5, 6000, 'ENTREGADO', '1004367716', '001');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) values ('2', '2024-09-30', 6, 7000, 'PENDIENTE', '1004367716', '001');


create or replace procedure generar_auditoria(
	fecha_inicio date,
	fecha_final date
)
language plpgsql
as $$
declare 
v_factura_id varchar;
v_estado_actual estado;
v_fecha_inicio date;
begin
for v_factura_id, v_estado_actual, v_fecha_inicio in select id, pedido_estado, fecha from facturas
loop
	if v_fecha_inicio between p_fecha_inicio and p_fecha_final then 
		insert into auditoria(fecha_inicio, fecha_final, factura_id, pedido_estado) values(p_fecha_inicio, p_fecha_final, v_factura_id,v_estado_actual);
		raise notice 'Se ha creado la auditoria';
	end if;
end loop;
end;
$$;

call obtener_total_stock('2024-10-10', '2024-11-05'); 

select * from auditoria;
create or replace procedure simular_ventas_mes()
ass $$
declare 
	v_dia integer :=1;
	v_identificacion varchar;
begin
	while dia <= 30 loop
		--For tabla Clientes
		--Dentro del for insert a facturas
	end loop;
		
	
end

