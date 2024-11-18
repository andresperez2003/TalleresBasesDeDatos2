/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.tallermongo;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.gt;

import org.bson.Document;
import java.util.*;



/**
 *
 * @author ASUS
 */
public class TallerMongo {
    
    private static final String uri = "mongodb://localhost:27017";
    private static final MongoClient mongoClient = MongoClients.create(uri);
    private static final MongoDatabase database = mongoClient.getDatabase("taller19");
    private static final MongoCollection<org.bson.Document> collection = database.getCollection("productos");
    
    
    public static void main(String[] args) {

        System.out.println("Conexion exitosa");

        //Agregar productos
        
        // Producto 1
        List<Document> comentarios = new ArrayList<>();
        Document categoria = crearCategoria(1, "Ropa");
        comentarios.add(crearComentario(1, "Muy cómoda", "Juan"));
        comentarios.add(crearComentario(2, "Buena calidad", "María"));
        insertarProducto(1, "Camiseta", "Camiseta de algodón", 20, categoria, comentarios);

        // Producto 2
        comentarios.clear();
        categoria = crearCategoria(2, "Electrónica");
        comentarios.add(crearComentario(3, "Muy útil", "Pedro"));
        comentarios.add(crearComentario(4, "Excelente calidad", "Sofía"));
        insertarProducto(2, "Audífonos", "Audífonos inalámbricos", 50, categoria, comentarios);

        // Producto 3
        comentarios.clear();
        categoria = crearCategoria(3, "Hogar");
        comentarios.add(crearComentario(5, "Práctico", "Carlos"));
        comentarios.add(crearComentario(6, "Buen diseño", "Ana"));
        insertarProducto(3, "Lámpara", "Lámpara de escritorio", 30, categoria, comentarios);

        // Producto 4
        comentarios.clear();
        categoria = crearCategoria(4, "Deportes");
        comentarios.add(crearComentario(7, "Excelente rendimiento", "Luis"));
        comentarios.add(crearComentario(8, "Muy cómodo para correr", "Laura"));
        insertarProducto(4, "Zapatillas deportivas", "Zapatillas para correr", 60, categoria, comentarios);

        // Producto 5
        comentarios.clear();
        categoria = crearCategoria(5, "Alimentos");
        comentarios.add(crearComentario(9, "Sabor delicioso", "Roberto"));
        comentarios.add(crearComentario(10, "Frescas y ricas", "Sandra"));
        insertarProducto(5, "Manzanas", "Manzanas orgánicas", 5, categoria, comentarios);

        // Producto 6
        comentarios.clear();
        categoria = crearCategoria(6, "Juguetes");
        comentarios.add(crearComentario(11, "Divertido", "Jorge"));
        comentarios.add(crearComentario(12, "A los niños les encanta", "Claudia"));
        insertarProducto(6, "Pelota", "Pelota de fútbol", 15, categoria, comentarios);

        // Producto 7
        comentarios.clear();
        categoria = crearCategoria(7, "Ropa");
        comentarios.add(crearComentario(13, "Muy elegante", "Gabriel"));
        comentarios.add(crearComentario(14, "Excelente calidad", "Paula"));
        insertarProducto(7, "Camisa", "Camisa de algodón", 25, categoria, comentarios);

        // Producto 8
        comentarios.clear();
        categoria = crearCategoria(8, "Tecnología");
        comentarios.add(crearComentario(15, "Muy rápido", "Esteban"));
        comentarios.add(crearComentario(16, "Buena conexión", "Mariana"));
        insertarProducto(8, "Router Wi-Fi", "Router de alta velocidad", 100, categoria, comentarios);

        // Producto 9
        comentarios.clear();
        categoria = crearCategoria(9, "Hogar");
        comentarios.add(crearComentario(17, "Práctico", "José"));
        comentarios.add(crearComentario(18, "Fácil de usar", "Marta"));
        insertarProducto(9, "Aspiradora", "Aspiradora sin cables", 80, categoria, comentarios);

        // Producto 10
        comentarios.clear();
        categoria = crearCategoria(10, "Alimentos");
        comentarios.add(crearComentario(19, "Muy sabroso", "Raúl"));
        comentarios.add(crearComentario(20, "De excelente calidad", "Vera"));
        insertarProducto(10, "Pan", "Pan de trigo", 3, categoria, comentarios);


        // Actualizar productos
        
        // Producto 1
        collection.updateOne(eq("ProductoID", 1), new Document("$set", new Document("Precio", 5000)));
        collection.updateOne(eq("ProductoID", 1), new Document("$set", new Document("Descripcion", "Camiseta de algodón actualizada")));

        // Producto 2
        collection.updateOne(eq("ProductoID", 2), new Document("$set", new Document("Precio", 1500)));
        collection.updateOne(eq("ProductoID", 2), new Document("$set", new Document("Descripcion", "Audífonos inalámbricos con cancelación de ruido")));

        // Producto 3
        collection.updateOne(eq("ProductoID", 3), new Document("$set", new Document("Precio", 3500)));
        collection.updateOne(eq("ProductoID", 3), new Document("$set", new Document("Descripcion", "Lámpara de escritorio moderna")));

        // Producto 4
        collection.updateOne(eq("ProductoID", 4), new Document("$set", new Document("Precio", 7000)));
        collection.updateOne(eq("ProductoID", 4), new Document("$set", new Document("Descripcion", "Zapatillas deportivas de alta gama")));

        // Producto 5
        collection.updateOne(eq("ProductoID", 5), new Document("$set", new Document("Precio", 800)));
        collection.updateOne(eq("ProductoID", 5), new Document("$set", new Document("Descripcion", "Manzanas orgánicas frescas")));

        // Eliminar productos
        collection.deleteOne(eq("ProductoID", 6)); // Eliminamos el producto con ProductoID = 6
        collection.deleteOne(eq("ProductoID", 7)); // Eliminamos el producto con ProductoID = 7

        
        // Consultar productos con precio mayor a 10
        consultarProductosMayorA10();
        
        // Consultar productos con precio mayor a 50 y categoría igual a "Ropa"
        consultarProductosMayorA50YCategoriaRopa();
        
    }
    

    public static void consultarProductosMayorA10() {
        System.out.println("\nProductos mayores a $10 \n");
        for (Document producto : collection.find(gt("Precio", 10))) {
            System.out.println("ProductoID: " + producto.get("ProductoID"));
            System.out.println("Nombre: " + producto.get("Nombre"));
            System.out.println("Descripción: " + producto.get("Descripcion"));
            System.out.println("Precio: " + producto.get("Precio"));
            System.out.println("Categoría: " + producto.get("Categoria"));
            System.out.println("Comentarios: " + producto.get("Comentarios"));
            System.out.println("------------------------------");
        }
        System.out.println("\n");
    }

    
public static void consultarProductosMayorA50YCategoriaRopa() {
    System.out.println("Productos mayores a $50 y con categoria Ropa \n");
    for (Document producto : collection.find(and(gt("Precio", 50), eq("Categoria.NombreCategoria", "Ropa")))) {
        System.out.println("ProductoID: " + producto.get("ProductoID"));
        System.out.println("Nombre: " + producto.get("Nombre"));
        System.out.println("Descripción: " + producto.get("Descripcion"));
        System.out.println("Precio: " + producto.get("Precio"));
        System.out.println("Categoría: " + producto.get("Categoria"));
        System.out.println("Comentarios: " + producto.get("Comentarios"));
        System.out.println("------------------------------");
    }
}
    
    public static void insertarProducto(int id, String nombre, String descripcion, double precio, Document categoria, List<Document> comentarios){
        Document producto = new Document( "ProductoID",id)
        .append("Nombre", nombre)
        .append("Descripcion", descripcion)
        .append("Precio",precio)
        .append("Categoria", categoria)
        .append("Comentarios", comentarios);
        collection.insertOne(producto);
    }
    
    public static Document crearCategoria(int id, String nombre){
        Document categoria = new Document("CategeoriaID",id)
        .append("NombreCategoria", nombre);
        return categoria;
    }
    
    public static Document crearComentario(int id, String texto, String cliente){
        Document comentario = new Document("ComentarioID",id)
        .append("Texto", texto)
        .append("Cliente", cliente);
        return comentario;
    };

}
