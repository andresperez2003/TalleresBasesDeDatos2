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
pedido_estado  varchar check (pedido_estado in ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO')),
cliente_id varchar,
producto_id varchar,
foreign key(cliente_id) references clientes(identificacion),
foreign key(producto_id) references productos(codigo)
);


create or replace procedure verificar_stock(
p_producto_id varchar,
p_cantidad_compra INTEGER
)
language plpgsql
as $$
declare 
	cantidad_disponible integer;
begin 
	select stock into cantidad_disponible from productos where codigo = p_producto_id;

	if p_cantidad_compra > cantidad_disponible then
		raise notice 'No hay productos suficientes, cantidad pedida: %, cantidad disponible: %', p_cantidad_compra, cantidad_disponible ;
	else
		raise notice 'Si se puede realizar el pedido';
	end if;
end;
$$;

create or replace procedure actualizar_estado_pedido(
p_factura_id varchar,
p_nuevo_estado varchar
)
language plpgsql
as $$
declare
estado varchar;
begin 
	select pedido_estado into estado from facturas where id = p_factura_id;
	if estado = 'ENTREGADO' then
		raise notice 'El pedido ya fue entregado' ;
	else
		update facturas set pedido_estado = 'ENTREGADO' where id = p_factura_id;
		raise notice 'El pedido se acaba de entregar';
	end if;
end;
$$;


insert into productos(codigo, nombre, stock, valor_unitario) values('001', 'Paleta', 20, 2000);
insert into clientes(identificacion, nombre, edad, correo) values ('1004367716', 'Andres', 21, 'andresap@gmail.com');


call verificar_stock('001',22);


insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) values ('1', '2024-08-30', 5, 6000, 'ENTREGADO', '1004367716', '001');
insert into facturas(id, fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) values ('2', '2024-09-30', 6, 7000, 'PENDIENTE', '1004367716', '001');


call actualizar_estado_pedido('2','ENTREGADO');

