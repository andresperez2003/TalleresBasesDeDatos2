create table facturas(
	id serial primary key,
	codigo_punto_venta bigint,
	descripcion jsonb
);

create or replace procedure taller16.agregar_factura( p_codigo_punto_venta bigint, p_descripcion jsonb)
as $$
declare
	v_monto_total numeric;
	v_aplicado_descuento numeric;
begin
	v_monto_total := (p_descripcion->>'monto_total')::numeric;
	v_aplicado_descuento := (p_descripcion ->>'descuento')::numeric;
	if(v_monto_total > 10000) then
		raise exception 'El monto total de la factura excede el límite permitido de 10000 dólares';
	end if;
	v_aplicado_descuento := (v_aplicado_descuento / 100) * v_monto_total;
	if(v_aplicado_descuento > 50) then
		raise exception 'El descuento aplicado no puede superar los 50 dólares';
	end if;
	
	insert into taller16.facturas(codigo_punto_venta, descripcion) values(p_codigo_punto_venta, p_descripcion);
end;
$$ language plpgsql;

create or replace procedure taller16.actualizar_factura(
    p_id bigint, 
    p_descripcion jsonb
)
as $$
begin

    if not exists (select 1 from taller16.facturas where id = p_id) then
        raise exception 'La factura con id % no existe', p_id;
    end if;

    update taller16.facturas
    set descripcion = p_descripcion
    where id = p_id;

end;
$$ language plpgsql;

create or replace function taller16.obtener_nombre_cliente(p_identificacion varchar)
returns varchar
as $$
declare
    v_cliente_nombre varchar;
begin
    select cast(descripcion->>'cliente' as varchar) 
    into v_cliente_nombre
    from taller16.facturas
    where cast(descripcion->>'identificacion' as varchar) = p_identificacion;

    if v_cliente_nombre is null then
        raise notice 'No se encontró un cliente con la identificación %', p_identificacion;
    end if;

    return v_cliente_nombre;
end;
$$ language plpgsql;

create or replace function taller16.obtener_facturas()
returns table(
    p_codigo_factura int, 
    p_cliente varchar, 
    p_identificacion varchar, 
    p_descuento_aplicado int, 
    p_monto_total numeric
)
as $$
begin
    return query
    select 
        id as p_codigo_factura, 
        cast(descripcion->>'cliente' as varchar) as p_cliente, 
        cast(descripcion->>'identificacion' as varchar) as p_identificacion, 
        (descripcion->>'descuento')::int as p_descuento_aplicado, 
        (descripcion->>'monto_total')::numeric as p_monto_total
    from taller16.facturas;
end;
$$ language plpgsql;

create or replace function taller16.obtener_productos_por_factura(p_id_factura bigint)
returns table(
    p_cantidad int, 
    p_precio_unitario numeric, 
    p_nombre_producto varchar, 
    p_detalle varchar, 
    p_precio_total numeric
)
as $$
begin
    return query
    select 
        (producto->>'cantidad')::int as p_cantidad,
        (producto->>'valor')::numeric as p_precio_unitario,
        cast (producto->>'nombre' as varchar) as p_nombre_producto,
        cast (producto->>'descripcion' as varchar) as p_detalle,
        (producto->>'precio')::numeric as p_precio_total
    from 
        taller16.facturas,
        jsonb_array_elements(descripcion->'productos') as producto
    where 
        id = p_id_factura;  
end;
$$ language plpgsql;

call taller16.agregar_factura(
    1, 
    '{
        "cliente": "Mariana", 
        "identificacion": "1234567890", 
        "direccion": "Calle 123", 
        "codigo": "A01", 
        "descuento": 0, 
        "monto_total": 8500, 
        "productos": [
            {
                "cantidad": 8, 
                "valor": 1100, 
                "producto": {
                    "nombre": "Manzana", 
                    "descripcion": "Fresca", 
                    "precio": 1000, 
                    "categorias": ["Frutas", "Rojas"]
                }
            }
        ]
    }'
);

call taller16.actualizar_factura(
    1, 
    '{
        "cliente": "Mariana", 
        "identificacion": "1234567890", 
        "direccion": "Avenida Siempre Viva", 
        "codigo": "A01", 
        "descuento": 5, 
        "monto_total": 9000, 
        "productos": [
            {
                "cantidad": 5, 
                "valor": 1500, 
                "producto": {
                    "nombre": "Pera", 
                    "descripcion": "Jugosa", 
                    "precio": 1200, 
                    "categorias": ["Frutas", "Verdes"]
                }
            }
        ]
    }'
);

select taller16.obtener_nombre_cliente('1234567890');

select * from taller16.obtener_facturas();

select * from taller16.obtener_productos_por_factura(1);
