
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
    id serial primary key,
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
factura_id serial,
pedido_estado estado,
foreign key(factura_id) references facturas(id)
);


insert into productos(codigo, nombre, stock, valor_unitario) values('001', 'Paleta', 20, 2000);
insert into clientes(identificacion, nombre, edad, correo) values ('1004367716', 'Andres', 21, 'andresap@gmail.com');
insert into facturas(fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) values ('2024-08-30', 5, 6000, 'ENTREGADO', '1004367716', '001');
insert into facturas(fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) values ('2024-09-30', 6, 7000, 'PENDIENTE', '1004367716', '001');
INSERT INTO facturas(fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) VALUES ('2001-05-15', 3, 5000, 'ENTREGADO', '1004367716', '001');
INSERT INTO facturas(fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) values ('2002-07-20', 4, 8000, 'PENDIENTE', '1004367716', '001');
INSERT INTO facturas(fecha, cantidad, valor_total, pedido_estado, cliente_id, producto_id) values ('2003-03-10', 2, 4000, 'BLOQUEADO', '1004367716', '001');


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
    v_id_factura varchar;  -- Cambiado a varchar
    v_estado_factura taller5.estado;
    v_fecha date;
begin
    for v_fecha, v_id_factura, v_estado_factura in
        select fecha, id, pedido_estado
        from taller5.facturas
        where fecha between P_fecha_inicio and p_fecha_final  -- Filtrar directamente en la consulta
    loop
        insert into taller5.auditoria(fecha_inicio, fecha_final, factura_id, pedido_estado)
        values (P_fecha_inicio, p_fecha_final, v_id_factura, v_estado_factura);
        
        raise notice 'Se ha creado la auditoría para la factura: %', v_id_factura;
    end loop;
END;
$$;


call generar_auditoria('2000-11-12', '2004-11-12');
call generar_auditoria('2003-11-11', '2005-08-05');


--PARTE 3
create or replace procedure simular_ventas_mes()
language plpgsql
as $$
declare 
    v_dia integer := 1;
    v_identificacion varchar;
    v_cantidad_random integer;
begin
    while v_dia <= 30 loop
        for v_identificacion in
            select identificacion from taller5.clientes
        loop
            v_cantidad_random := floor(1 + random() * 2);  -- Generar cantidad aleatoria entre 1 y 2
            
            insert into taller5.facturas( fecha, cantidad, valor_total, pedido_estado, producto_id, cliente_id)
            values ('2024-09-02', v_cantidad_random, 30000, 'ENTREGADO', '001', v_identificacion);  -- Producto corregido a '001'
            
            raise notice 'Se creó una factura para el cliente: %', v_identificacion;
        end loop;
        v_dia := v_dia + 1;
    end loop;
END;
$$;


call simular_ventas_mes();