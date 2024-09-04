
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
raise notice 'el nombre del producto es: %', v_nombre_producto;
raise notice 'el stock actual del producto es de: %', v_stock_actual;
v_total_stock := v_total_stock + v_stock_actual;
    end loop;
raise notice 'El estock total es de: %', v_total_stock;
END;
$$;

call obtener_total_stock();

--PARTE 2

create or replace procedure generar_auditoria(
P_fecha_inicio date,
p_fecha_final date
)
language plpgsql
as $$
declare 
    v_id_factura integer;
    v_estado_factura estado;
v_fecha date;
begin
    for v_fecha, v_id_factura, v_estado_factura in select fecha, id, pedido_estado from facturas
    loop
if v_fecha between P_fecha_inicio and p_fecha_final then
insert into auditoria(fecha_inicio, fecha_final, factura_id, pedido_estado)values(P_fecha_inicio, p_fecha_final, v_id_factura, v_estado_factura);
    raise notice 'Se ha creado la auditoria';
end if;
end loop;
END;

$$;

call generar_auditoria('2000-11-12', '2004-11-12');

--PARTE 3
create or replace procedure simular_ventas_mes()
language plpgsql
as $$
declare 
    v_dia integer :=1 ;
    v_identificacion varchar;
v_cantidad_random integer;
begin
    while v_dia <= 30 loop
forv_identificacion in select identificacion from clientes
loop
v_cantidad_random:= floor(1+random()*2);
insert into facturas( fecha, cantidad, valor_total, pedido_estado, producto_id, cliente_id)values('2024-09-02', v_cantidad_random, 30000,'ENTREGADO','1', v_identificacion);
raise notice 'se creo una factura';
end loop;
v_dia:= v_dia+1; 
end loop;
END;

$$;

call simular_ventas_mes();