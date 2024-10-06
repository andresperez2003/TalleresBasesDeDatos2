package taller10;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;

public class Taller10 {

    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");

            // Conexión a la base de datos
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "andres2003");

            // Llamada al procedimiento generar_auditoria
            CallableStatement ejecucion1 = conexion.prepareCall("call taller5.generar_auditoria(?, ?)");
            ejecucion1.setDate(1, java.sql.Date.valueOf("2000-11-12"));
            ejecucion1.setDate(2, java.sql.Date.valueOf("2004-11-12"));
            ejecucion1.execute();
            ejecucion1.close();

            // Llamada al procedimiento simular_ventas_mes
            CallableStatement ejecucion2 = conexion.prepareCall("call taller5.simular_ventas_mes()");
            ejecucion2.execute();
            ejecucion2.close();

            // Llamada al procedimiento transacciones_total_mes
            CallableStatement ejecucion3 = conexion.prepareCall("SELECT taller6.transacciones_total_mes(?, ?)");
            ejecucion3.setDate(1, java.sql.Date.valueOf("2024-10-01"));
            ejecucion3.setInt(2, 11);
            ResultSet resultado = ejecucion3.executeQuery();

            // Obtener el resultado
            if (resultado.next()) {
                BigDecimal totalTransacciones = resultado.getBigDecimal(1);
                System.out.println("Total de las transacciones del mes es : " + totalTransacciones);
            }

            // Cerrar la conexión
            resultado.close();
            ejecucion3.close();
            conexion.close();

        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }
}
