/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.parcialneo;


import org.neo4j.driver.*;
/**
 *
 * @author ASUS
 */
public class ParcialNeo {
    private static final String URI = "bolt://localhost:7687";
    private static final String USERNAME = "neo4j"; 
    private static final String PASSWORD = "andres2003";

    public static void main(String[] args) {
        try (Driver driver = GraphDatabase.driver(URI, AuthTokens.basic(USERNAME, PASSWORD))) {
            System.out.println("Conexión exitosa");

            // Nodos de prueba
            createNode(driver, "Persona", "nombre", "Juan", "correo", "juan@correo.com", "edad", 30, "ciudad", "Madrid");
            createNode(driver, "Persona", "nombre", "Andres", "correo", "andres@correo.com", "edad", 21, "ciudad", "Manizales");

            // Comentario (Relacion)
            createCommentRelation(driver, "Juan", "Andres", "Este es un comentario de Juan hacia Andres.");

        } catch (Exception e) {
            System.err.println("Error de conexión: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Método para crear un nodo
    public static void createNode(Driver driver, String label, String key1, String value1, 
                                  String key2, String value2, String key3, int value3, String key4, String value4) {
        try (Session session = driver.session()) {
            String query = "CREATE (n:" + label + " {" +
                           key1 + ": $value1, " +
                           key2 + ": $value2, " +
                           key3 + ": $value3, " +
                           key4 + ": $value4}) RETURN n";
            session.run(query, 
                        Values.parameters("value1", value1, 
                                          "value2", value2, 
                                          "value3", value3, 
                                          "value4", value4));
            System.out.println("Nodo creado con éxito");
        } catch (Exception e) {
            System.err.println("Error al crear el nodo: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void createCommentRelation(Driver driver, String persona1, String persona2, String descripcion) {
        try (Session session = driver.session()) {
            String query = "MATCH (p1:Persona {nombre: $persona1}), (p2:Persona {nombre: $persona2}) " +
                           "CREATE (p1)-[:COMENTARIO {descripcion: $descripcion}]->(p2)";

            session.run(query, 
                        Values.parameters("persona1", persona1, 
                                          "persona2", persona2, 
                                          "descripcion", descripcion));

            System.out.println("Relación de comentario creada con éxito entre " + persona1 + " y " + persona2);
        } catch (Exception e) {
            System.err.println("Error al crear la relación de comentario: " + e.getMessage());
            e.printStackTrace();
        }
    }

}
