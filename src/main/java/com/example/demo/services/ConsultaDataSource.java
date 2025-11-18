package com.example.demo.services;

import com.example.demo.models.Boleta;
import com.example.demo.models.Categoria;
import com.example.demo.models.DetalleBoleta;
import com.example.demo.models.Producto;
import com.example.demo.models.UsuarioAdmin;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class ConsultaDataSource {

    private final DataSource dataSource;

    public ConsultaDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<UsuarioAdmin> listarUsuariosAdmin() {
        String sql = "SELECT id_usuario, correo, clave, rol FROM UsuarioAdmin ORDER BY id_usuario";
        List<UsuarioAdmin> lista = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UsuarioAdmin u = new UsuarioAdmin();
                u.setId_usuario(rs.getInt("id_usuario"));
                u.setCorreo(rs.getString("correo"));
                u.setClave(rs.getString("clave"));
                u.setRol(rs.getString("rol"));
                lista.add(u);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return lista;
    }

    public List<Categoria> listarCategorias() {
        String sql = "SELECT id_categoria, nombre_categoria FROM Categorias ORDER BY id_categoria";
        List<Categoria> lista = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setId_categoria(rs.getInt("id_categoria"));
                c.setNombre_categoria(rs.getString("nombre_categoria"));
                lista.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return lista;
    }

    public List<Producto> listarProductos() {
        String sql = "SELECT id_producto, sku, nombre, id_categoria, precio, stock FROM Productos ORDER BY id_producto";
        List<Producto> lista = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Producto p = new Producto();
                p.setId_producto(rs.getInt("id_producto"));
                p.setSku(rs.getString("sku"));
                p.setNombre(rs.getString("nombre"));
                p.setId_categoria(rs.getInt("id_categoria"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                lista.add(p);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return lista;
    }

    public List<Boleta> listarBoletas() {
        String sql = "SELECT id_boleta, id_usuario, fecha_emision, total FROM Boletas ORDER BY id_boleta";
        List<Boleta> lista = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Boleta b = new Boleta();
                b.setId_boleta(rs.getInt("id_boleta"));
                b.setId_usuario(rs.getInt("id_usuario"));
                b.setFecha_emision(rs.getTimestamp("fecha_emision").toLocalDateTime());
                b.setTotal(rs.getDouble("total"));
                lista.add(b);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return lista;
    }

    public List<DetalleBoleta> listarDetallesPorBoleta(int idBoleta) {
        String sql = "SELECT id_detalle_boleta, id_boleta, id_producto, cantidad, precio_unitario FROM Detalle_Boleta WHERE id_boleta = ? ORDER BY id_detalle_boleta";
        List<DetalleBoleta> lista = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idBoleta);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DetalleBoleta d = new DetalleBoleta();
                    d.setId_detalle_boleta(rs.getInt("id_detalle_boleta"));
                    d.setId_boleta(rs.getInt("id_boleta"));
                    d.setId_producto(rs.getInt("id_producto"));
                    d.setCantidad(rs.getInt("cantidad"));
                    d.setPrecio_unitario(rs.getDouble("precio_unitario"));
                    lista.add(d);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return lista;
    }
}
