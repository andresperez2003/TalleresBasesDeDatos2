/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package punto5;
import java.sql.*;
/**
 *
 * @author ASUS
 */
public class Punto5 {

    /**
     * @param args the command line arguments
     */


public class Main {
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "andres2003");

            // Llamada a obtener_pagos_usuario
            PreparedStatement stmtPagos = conexion.prepareStatement("SELECT * FROM obtener_pagos_usuario(?, ?)");
            stmtPagos.setInt(1, 1);  // Reemplaza 1 con el usuario_id que desees
            stmtPagos.setDate(2, java.sql.Date.valueOf("2024-10-30"));  // Fecha en formato yyyy-MM-dd

            ResultSet rsPagos = stmtPagos.executeQuery();
            System.out.println("Pagos del usuario:");
            while (rsPagos.next()) {
                String codigoPago = rsPagos.getString("codigo_pago");
                String nombreProducto = rsPagos.getString("nombre_producto");
                double monto = rsPagos.getDouble("monto");
                String estado = rsPagos.getString("estado");

                System.out.println("Código Pago: " + codigoPago + ", Producto: " + nombreProducto + ", Monto: " + monto + ", Estado: " + estado);
            }
            rsPagos.close();
            stmtPagos.close();

            // Llamada a obtener_tarjetas_usuario
            PreparedStatement stmtTarjetas = conexion.prepareStatement("SELECT * FROM obtener_tarjetas_usuario(?)");
            stmtTarjetas.setInt(1, 1);  // Reemplaza 1 con el usuario_id que desees

            ResultSet rsTarjetas = stmtTarjetas.executeQuery();
            System.out.println("\nTarjetas del usuario:");
            while (rsTarjetas.next()) {
                String nombreUsuario = rsTarjetas.getString("nombre_usuario");
                String email = rsTarjetas.getString("email");
                String numeroTarjeta = rsTarjetas.getString("numero_tarjeta");
                String cvv = rsTarjetas.getString("cvv");
                String tipoTarjeta = rsTarjetas.getString("tipo_tarjeta");

                System.out.println("Nombre Usuario: " + nombreUsuario + ", Email: " + email + 
                                   ", Número de Tarjeta: " + numeroTarjeta + ", CVV: " + cvv + 
                                   ", Tipo de Tarjeta: " + tipoTarjeta);
            }
            rsTarjetas.close();
            stmtTarjetas.close();

            // Cerrar la conexión
            conexion.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

    
}
