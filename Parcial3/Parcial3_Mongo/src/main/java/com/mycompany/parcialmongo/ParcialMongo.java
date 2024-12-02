/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.parcialmongo;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.gt;
import com.mongodb.client.model.Updates;
import java.util.Arrays;
import org.bson.Document;

/**
 *
 * @author ASUS
 */
public class ParcialMongo {
    private static final String uri = "mongodb://localhost:27017";
    private static final MongoClient mongoClient = MongoClients.create(uri);
    private static final MongoDatabase database = mongoClient.getDatabase("prueba");
    private static final MongoCollection<org.bson.Document> collectionProductos = database.getCollection("productos");
    private static final MongoCollection<org.bson.Document> collectionPedidos = database.getCollection("pedido");
    private static final MongoCollection<org.bson.Document> collectionDetalles = database.getCollection("detalle_pedido");
    private static final MongoCollection<org.bson.Document> collectionReservas = database.getCollection("reservas");
    
    
    public static void main(String[] args) {
        
        
        //Punto 1 
        
        //insertarProducto("Producto01","Camisa de algodon", "Camiseta 1000% algodon", 35.99, 200);
        //insertarPedido("Pedido01", "Cliente01", "2024-12-02T14:00:00Z", "Enviado",200.98);
        //insertarDetallePedido("Detalle01","Detalle01", "Producto01", 2, 10);
        
        
        //actualizarProducto("Producto01", "precio", 40.00);
        //actualizarPedido("Pedido01", "estado", "Enviado y Pagado");
        //actualizarDetallePedido("Detalle01", "cantidad", 3);
        
        //eliminarProducto("Producto01");
        //eliminarPedido("Pedido01");
        //eliminarDetallePedido("Detalle01");
        
        
        leerTodosLosDetallesPedidos();
        leerTodosLosPedidos();
        leerTodosLosProductos();
        
        
        
        //Punto 2
        obtenerProductosMayorA20();
        obtenerPedidosMayorA100();
        obtenerPedidosConDetalleProducto("producto01");
        
        
        //Punto 3 
        
        //Crear reservas
        //crearReserva("reserva001", "Ana Gómez", "ana.gomez@example.com", "+54111223344", 
             //        "Calle Ficticia 123, Buenos Aires, Argentina", "Suite", 101, 200.00, 2, 
             //        "Suite con vista al mar, cama king size, baño privado y balcón.", 
             //        "2024-12-15T14:00:00Z", "2024-12-18T12:00:00Z", 740.00, "Pagado", 
             //        "Tarjeta de Crédito", "2024-11-30T10:00:00Z");


        leerReservas();
        
        // Actualizar una reserva
        //actualizarReserva("12345", 200.0, "Pendiente", "2024-12-01T10:00:00Z");

        // Eliminar una reserva
        //eliminarReserva("12345");

        
        //Punto 4
        
        // Consultar habitaciones tipo "Sencilla"
        obtenerHabitacionesSencillas();

        // Consultar la sumatoria de reservas pagadas
        obtenerSumatoriaReservasPagadas();

        // Consultar reservas con precio_noche mayor a 100 dólares
        obtenerReservasPorPrecioNoche();
    }
    
    
    public static void leerTodosLosProductos() {
        FindIterable<Document> productos = collectionProductos.find();
        System.out.println("Productos:");
        for (Document producto : productos) {
            System.out.println(producto.toJson());
        }
    }
    
    public static void insertarProducto(String id, String nombre, String descripcion, double precio, int stock){
        Document producto = new Document( "_id",id)
        .append("Nombre", nombre)
        .append("Descripcion", descripcion)
        .append("Precio",precio)
        .append("Stock", stock);
        collectionProductos.insertOne(producto);
    }
    
    public static void actualizarProducto(String id, String campo, Object valor) {
        collectionProductos.updateOne(Filters.eq("_id", id), new Document("$set", new Document(campo, valor)));
    }
    
    
    public static void eliminarProducto(String id) {
        collectionProductos.deleteOne(Filters.eq("_id", id));
    }
    
    
    
    public static void leerTodosLosPedidos() {
        FindIterable<Document> pedidos = collectionPedidos.find();
        System.out.println("Pedidos:");
        for (Document pedido : pedidos) {
            System.out.println(pedido.toJson());
        }
    }
    
    public static void insertarPedido(String id, String cliente, String fecha_pedido, String estado, double total){
        Document producto = new Document( "_id",id)
        .append("cliente", cliente)
        .append("fecha_pedido", fecha_pedido)
        .append("estado", estado)
        .append("total", total);
        collectionPedidos.insertOne(producto);
    }
    
    public static void actualizarPedido(String id, String campo, Object valor) {
        collectionPedidos.updateOne(Filters.eq("_id", id), new Document("$set", new Document(campo, valor)));
    }
    
    public static void eliminarPedido(String id) {
        collectionPedidos.deleteOne(Filters.eq("_id", id));
    }
    
    
    public static void leerTodosLosDetallesPedidos() {
        FindIterable<Document> detalles = collectionDetalles.find();
        System.out.println("Detalles de Pedidos:");
        for (Document detalle : detalles) {
            System.out.println(detalle.toJson());
        }
    }
    
    public static void insertarDetallePedido(String id, String pedido_id, String producto_id, int cantidad, double precio_unitario){
        Document producto = new Document( "_id",id)
        .append("pedido_id", pedido_id)
        .append("producto_id", producto_id)
        .append("cantidad", cantidad)
        .append("precio_unitario", precio_unitario);
        collectionDetalles.insertOne(producto);
    }
    
    public static void actualizarDetallePedido(String id, String campo, Object valor) {
        collectionDetalles.updateOne(Filters.eq("_id", id), new Document("$set", new Document(campo, valor)));
    }
    
    public static void eliminarDetallePedido(String id) {
        collectionDetalles.deleteOne(Filters.eq("_id", id));
    }
    
    
    // Pregunta 2
    
    //Obtener los productos con un precio mayor a $20
    public static void obtenerProductosMayorA20() {
        System.out.println("Productos con precio mayor a $20:");
        collectionProductos.find(gt("precio", 20))
                .forEach(producto -> {
                    System.out.println("ID: " + producto.getString("_id"));
                    System.out.println("Nombre: " + producto.getString("nombre"));
                    System.out.println("Descripción: " + producto.getString("descripcion"));
                    System.out.println("Precio: " + producto.getDouble("precio"));
                    System.out.println("Stock: " + producto.getInteger("stock"));
                    System.out.println("------------------------------");
                });
    }

    //Obtener los pedidos con un total mayor a $100
    public static void obtenerPedidosMayorA100() {
        System.out.println("Pedidos con total mayor a $100:");
        collectionPedidos.find(gt("total", 100))
                .forEach(pedido -> {
                    System.out.println("ID: " + pedido.getString("_id"));
                    System.out.println("Cliente: " + pedido.getString("cliente"));
                    System.out.println("Fecha del pedido: " + pedido.getString("fecha_pedido"));
                    System.out.println("Estado: " + pedido.getString("estado"));
                    System.out.println("Total: " + pedido.getDouble("total"));
                    System.out.println("------------------------------");
                });
    }

    //Obtener los pedidos que contengan un detalle con un producto específico
    public static void obtenerPedidosConDetalleProducto(String productoId) {
        System.out.println("Pedidos con detalles que contienen el producto: " + productoId);
        collectionDetalles.find(eq("producto_id", productoId))
                .forEach(detalle -> {
                    String pedidoId = detalle.getString("pedido_id");
                    Document pedido = collectionPedidos.find(Filters.eq("_id", pedidoId)).first();
                    if (pedido != null) {
                        System.out.println("ID del pedido: " + pedido.getString("_id"));
                        System.out.println("Cliente: " + pedido.getString("cliente"));
                        System.out.println("Fecha del pedido: " + pedido.getString("fecha_pedido"));
                        System.out.println("Estado: " + pedido.getString("estado"));
                        System.out.println("Total: " + pedido.getDouble("total"));
                        System.out.println("------------------------------");
                    }
                });
    }
    
    

    // Pregunta 3
    
    
    
    public static void crearReserva(String id, String nombreCliente, String correoCliente, String telefonoCliente, 
                                    String direccionCliente, String tipoHabitacion, int numeroHabitacion, 
                                    double precioNoche, int capacidad, String descripcionHabitacion, 
                                    String fechaEntrada, String fechaSalida, double total, 
                                    String estadoPago, String metodoPago, String fechaReserva) {

        Document cliente = crearCliente(nombreCliente, correoCliente, telefonoCliente, direccionCliente);
        Document habitacion = crearHabitacion(tipoHabitacion, numeroHabitacion, precioNoche, capacidad, descripcionHabitacion);

        // Crear el documento de reserva
        Document reserva = new Document("_id", id)
                .append("cliente", cliente)
                .append("habitacion", habitacion)
                .append("fecha_entrada", fechaEntrada)
                .append("fecha_salida", fechaSalida)
                .append("total", total)
                .append("estado_pago", estadoPago)
                .append("metodo_pago", metodoPago)
                .append("fecha_reserva", fechaReserva);

        collectionReservas.insertOne(reserva);

        System.out.println("Reserva creada exitosamente.");
    }

    // Método para crear el documento de cliente
    public static Document crearCliente(String nombreCliente, String correoCliente, String telefonoCliente, String direccionCliente) {
        return new Document("nombre", nombreCliente)
                .append("correo", correoCliente)
                .append("telefono", telefonoCliente)
                .append("direccion", direccionCliente);
    }

    // Método para crear el documento de habitación
    public static Document crearHabitacion(String tipoHabitacion, int numeroHabitacion, double precioNoche, 
                                            int capacidad, String descripcionHabitacion) {
        return new Document("tipo", tipoHabitacion)
                .append("numero", numeroHabitacion)
                .append("precio_noche", precioNoche)
                .append("capacidad", capacidad)
                .append("descripcion", descripcionHabitacion);
    }

    // Método para leer todas las reservas
    public static void leerReservas() {
        System.out.println("\nReservas en la base de datos:");
        for (Document reserva : collectionReservas.find()) {
            System.out.println("ID Reserva: " + reserva.get("_id"));
            System.out.println("Cliente: " + reserva.get("cliente"));
            System.out.println("Habitación: " + reserva.get("habitacion"));
            System.out.println("Fecha Entrada: " + reserva.get("fecha_entrada"));
            System.out.println("Fecha Salida: " + reserva.get("fecha_salida"));
            System.out.println("Total: " + reserva.get("total"));
            System.out.println("Estado de Pago: " + reserva.get("estado_pago"));
            System.out.println("------------------------------");
        }
    }
    
    
    // Método para actualizar una reserva
    public static void actualizarReserva(String id, double nuevoTotal, String nuevoEstadoPago, String nuevaFechaReserva) {
        collectionReservas.updateOne(Filters.eq("_id", id), 
            Updates.combine(
                Updates.set("total", nuevoTotal),
                Updates.set("estado_pago", nuevoEstadoPago),
                Updates.set("fecha_reserva", nuevaFechaReserva)
            )
        );
        System.out.println("Reserva actualizada exitosamente.");
    }
    
    // Método para eliminar una reserva
    public static void eliminarReserva(String id) {
        collectionReservas.deleteOne(Filters.eq("_id", id));
        System.out.println("Reserva eliminada exitosamente.");
    }
    
    
    // Pregunta 4
    
    //Obtener las habitaciones de tipo "Sencilla"
    public static void obtenerHabitacionesSencillas() {
        System.out.println("\nHabitaciones reservadas de tipo 'Sencilla':");
        for (Document reserva : collectionReservas.find(Filters.eq("habitacion.tipo", "Sencilla"))) {
            System.out.println("ID Reserva: " + reserva.get("_id"));
            System.out.println("Cliente: " + reserva.get("cliente"));
            System.out.println("Habitación: " + reserva.get("habitacion"));
            System.out.println("Fecha Entrada: " + reserva.get("fecha_entrada"));
            System.out.println("Fecha Salida: " + reserva.get("fecha_salida"));
            System.out.println("------------------------------");
        }
    }
    
    // Obtener la sumatoria total de las reservas pagadas
    public static void obtenerSumatoriaReservasPagadas() {
        AggregateIterable<Document> result = collectionReservas.aggregate(Arrays.asList(
            Aggregates.match(Filters.eq("estado_pago", "Pagado")), // Filtrar por estado de pago "Pagado"
            Aggregates.group(null, Accumulators.sum("total_pagado", "$total")) // Sumar el campo "total"
        ));

        for (Document doc : result) {
            System.out.println("Sumatoria total de las reservas pagadas: " + doc.get("total_pagado"));
        }
    }

    
    
    // Obtener las reservas de habitaciones con un precio_noche mayor a 100 dólares
    public static void obtenerReservasPorPrecioNoche() {
        System.out.println("\nReservas de habitaciones con precio_noche mayor a 100 dólares:");
        for (Document reserva : collectionReservas.find(Filters.gt("habitacion.precio_noche", 100))) {
            System.out.println("ID Reserva: " + reserva.get("_id"));
            System.out.println("Cliente: " + reserva.get("cliente"));
            System.out.println("Habitación: " + reserva.get("habitacion"));
            System.out.println("Fecha Entrada: " + reserva.get("fecha_entrada"));
            System.out.println("Fecha Salida: " + reserva.get("fecha_salida"));
            System.out.println("Total: " + reserva.get("total"));
            System.out.println("------------------------------");
        }
    }

    
    

    
    
    
}
