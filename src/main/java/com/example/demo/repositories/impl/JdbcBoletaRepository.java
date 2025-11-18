package com.example.demo.repositories.impl;

import com.example.demo.models.Boleta;
import com.example.demo.repositories.BoletaDAO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

@Repository
public class JdbcBoletaRepository implements BoletaDAO {

    private final JdbcTemplate jdbcTemplate;

    public JdbcBoletaRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Boleta> rowMapper = (rs, rowNum) -> {
        Boleta b = new Boleta();
        b.setId_boleta(rs.getInt("id_boleta"));
        b.setId_usuario(rs.getInt("id_usuario"));
        Timestamp ts = rs.getTimestamp("fecha_emision");
        if (ts != null) {
            b.setFecha_emision(ts.toLocalDateTime());
        }
        b.setTotal(rs.getDouble("total"));
        // Intentar obtener el correo del usuario si existe un JOIN
        try {
            b.setUsuario_correo(rs.getString("usuario_correo"));
        } catch (Exception e) {
            // Si no hay JOIN, dejar null
            b.setUsuario_correo(null);
        }
        return b;
    };

    @Override
    public List<Boleta> findAll() {
        String sql = "SELECT b.id_boleta, b.id_usuario, b.fecha_emision, b.total, u.correo as usuario_correo " +
                     "FROM Boletas b LEFT JOIN UsuarioAdmin u ON b.id_usuario = u.id_usuario " +
                     "ORDER BY b.id_boleta";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Optional<Boleta> findById(int id) {
        String sql = "SELECT b.id_boleta, b.id_usuario, b.fecha_emision, b.total, u.correo as usuario_correo " +
                     "FROM Boletas b LEFT JOIN UsuarioAdmin u ON b.id_usuario = u.id_usuario " +
                     "WHERE b.id_boleta = ?";
        return jdbcTemplate.query(sql, rowMapper, id).stream().findFirst();
    }

    @Override
    public void save(Boleta boleta) {
        String sql = "INSERT INTO Boletas (id_usuario, total) VALUES (?, ?)";
        jdbcTemplate.update(sql, boleta.getId_usuario(), boleta.getTotal());
    }

    @Override
    public void update(Boleta boleta) {
        String sql = "UPDATE Boletas SET id_usuario = ?, total = ? WHERE id_boleta = ?";
        jdbcTemplate.update(sql, boleta.getId_usuario(), boleta.getTotal(), boleta.getId_boleta());
    }

    @Override
    public void deleteById(int id) {
        String sql = "DELETE FROM Boletas WHERE id_boleta = ?";
        jdbcTemplate.update(sql, id);
    }

    @Override
    public void recalcTotal(int idBoleta) {
        String sql = "UPDATE Boletas SET total = (SELECT COALESCE(SUM(d.cantidad * d.precio_unitario), 0) FROM Detalle_Boleta d WHERE d.id_boleta = ?) WHERE id_boleta = ?";
        jdbcTemplate.update(sql, idBoleta, idBoleta);
    }
}