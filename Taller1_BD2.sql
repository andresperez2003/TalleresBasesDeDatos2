BEGIN;

--Creacion de clientes
insert into "Taller1".clientes(identificacion, nombre,edad,correo) values ('1004367716', 'Andres Perez', 21, 'prueba@gmail.com');
insert into "Taller1".clientes(identificacion, nombre,edad,correo) values ('1857472920', 'Juan Llanos', 18, 'llanos@gmail.com');
insert into "Taller1".clientes(identificacion, nombre,edad,correo) values ('1485939204', 'Lisandro martienz', 22, 'lisandro@gmail.com');


--Creacion de productos
insert into "Taller1".productos(codigo, nombre, stock, valor_unitario) values ('ABC123', 'Gaseosa', 12, 15000);
insert into "Taller1".productos(codigo, nombre, stock, valor_unitario) values ('ABD165', 'Perro caliente', 5, 12000);
insert into "Taller1".productos(codigo, nombre, stock, valor_unitario) values ('ABE431', 'Galletas', 7, 6000);

insert into "Taller1".pedidos(producto_id, cliente_id, valor_total, cantidad, fecha) values('ABC123', '1004367716', 30000,2, '2024-12-05');
insert into "Taller1".pedidos(producto_id, cliente_id, valor_total, cantidad, fecha) values('ABD165', '1857472920', 24000,2, '2024-11-04');
insert into "Taller1".pedidos(producto_id, cliente_id, valor_total, cantidad, fecha) values('ABE431', '1485939204', 12000,2, '2024-10-02');

--Actualizar clientes
update "Taller1".clientes  set nombre = 'Alexandro', edad=20, correo ='alex@gmail.com' where identificacion  = '1004367716';
update "Taller1".clientes  set nombre = 'Luisa', edad=17, correo ='luisa@gmail.com' where identificacion  = '1857472920';

--Actualizar productos 
update "Taller1".productos  set  nombre='Paleta', stock=2, valor_unitario=2000 where codigo = 'ABC123';
update "Taller1".productos  set  nombre='Papas', stock=10, valor_unitario=2500 where codigo = 'ABD165';

--Actualizar pedidos
update "Taller1".pedidos  set  producto_id ='ABD165', cliente_id ='1857472920', cantidad = 2, fecha='2024-12-07' where id = 1;
update "Taller1".pedidos  set  producto_id ='ABE431', cliente_id ='1004367716', cantidad = 5, fecha='2024-9-07' where id = 2;


--Eliminar pedidos
delete from "Taller1".pedidos where id = 1;

--Eliminar clientes
delete from "Taller1".clientes where identificacion ='1857472920';

--Eliminar productos
delete from "Taller1".productos where codigo ='ABD165';


COMMIT;
 