package com.example.demo.repositories.impl;

import com.example.demo.models.DetalleBoleta;
import com.example.demo.repositories.DetalleBoletaDAO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class JdbcDetalleBoletaRepository implements DetalleBoletaDAO {

    private final JdbcTemplate jdbcTemplate;

    public JdbcDetalleBoletaRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<DetalleBoleta> rowMapper = (rs, rowNum) -> {
        DetalleBoleta d = new DetalleBoleta();
        d.setId_detalle_boleta(rs.getInt("id_detalle_boleta"));
        d.setId_boleta(rs.getInt("id_boleta"));
        d.setId_producto(rs.getInt("id_producto"));
        d.setCantidad(rs.getInt("cantidad"));
        d.setPrecio_unitario(rs.getDouble("precio_unitario"));
        try { d.setProducto_nombre(rs.getString("producto_nombre")); } catch (Exception ignored) {}
        return d;
    };

    @Override
    public List<DetalleBoleta> findByBoletaId(int idBoleta) {
        String sql = "SELECT d.id_detalle_boleta, d.id_boleta, d.id_producto, d.cantidad, d.precio_unitario, p.nombre AS producto_nombre " +
                     "FROM Detalle_Boleta d JOIN Productos p ON d.id_producto = p.id_producto WHERE d.id_boleta = ? ORDER BY d.id_detalle_boleta";
        return jdbcTemplate.query(sql, rowMapper, idBoleta);
    }

    @Override
    public Optional<DetalleBoleta> findById(int id) {
        String sql = "SELECT d.id_detalle_boleta, d.id_boleta, d.id_producto, d.cantidad, d.precio_unitario, p.nombre AS producto_nombre " +
                     "FROM Detalle_Boleta d JOIN Productos p ON d.id_producto = p.id_producto WHERE d.id_detalle_boleta = ?";
        return jdbcTemplate.query(sql, rowMapper, id).stream().findFirst();
    }

    @Override
    public void save(DetalleBoleta detalle) {
        String sql = "INSERT INTO Detalle_Boleta (id_boleta, id_producto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, detalle.getId_boleta(), detalle.getId_producto(), detalle.getCantidad(), detalle.getPrecio_unitario());
    }

    @Override
    public void update(DetalleBoleta detalle) {
        String sql = "UPDATE Detalle_Boleta SET id_producto = ?, cantidad = ?, precio_unitario = ? WHERE id_detalle_boleta = ?";
        jdbcTemplate.update(sql, detalle.getId_producto(), detalle.getCantidad(), detalle.getPrecio_unitario(), detalle.getId_detalle_boleta());
    }

    @Override
    public void deleteById(int id) {
        String sql = "DELETE FROM Detalle_Boleta WHERE id_detalle_boleta = ?";
        jdbcTemplate.update(sql, id);
    }

    @Override
    public void deleteByBoletaId(int idBoleta) {
        String sql = "DELETE FROM Detalle_Boleta WHERE id_boleta = ?";
        jdbcTemplate.update(sql, idBoleta);
    }
}
