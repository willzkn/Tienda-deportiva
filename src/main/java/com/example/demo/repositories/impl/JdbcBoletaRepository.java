package com.example.demo.repositories.impl;

import com.example.demo.models.Boleta;
import com.example.demo.repositories.BoletaDAO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

/**
 * Implementación JDBC de BoletaDAO utilizando JdbcTemplate y mapeo manual.
 */
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
        b.setActivo(rs.getBoolean("activo"));
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
        String sql = "SELECT b.id_boleta, b.id_usuario, b.fecha_emision, b.total, b.activo, u.correo as usuario_correo "
                +
                "FROM Boletas b LEFT JOIN UsuarioAdmin u ON b.id_usuario = u.id_usuario " +
                "ORDER BY b.id_boleta";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Optional<Boleta> findById(int id) {
        String sql = "SELECT b.id_boleta, b.id_usuario, b.fecha_emision, b.total, b.activo, u.correo as usuario_correo "
                +
                "FROM Boletas b LEFT JOIN UsuarioAdmin u ON b.id_usuario = u.id_usuario " +
                "WHERE b.id_boleta = ?";
        return jdbcTemplate.query(sql, rowMapper, id).stream().findFirst();
    }

    @Override
    public void save(Boleta boleta) {
        String sql = "INSERT INTO Boletas (id_usuario, total, activo) VALUES (?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, boleta.getId_usuario());
            ps.setDouble(2, boleta.getTotal());
            ps.setBoolean(3, boleta.isActivo());
            return ps;
        }, keyHolder);

        // Manejar múltiples claves generadas (ID_BOLETA y FECHA_EMISION)
        if (keyHolder.getKeys() != null && keyHolder.getKeys().containsKey("ID_BOLETA")) {
            boleta.setId_boleta(((Number) keyHolder.getKeys().get("ID_BOLETA")).intValue());
        }
    }

    @Override
    public void update(Boleta boleta) {
        String sql = "UPDATE Boletas SET id_usuario = ?, total = ?, activo = ? WHERE id_boleta = ?";
        jdbcTemplate.update(sql, boleta.getId_usuario(), boleta.getTotal(), boleta.isActivo(), boleta.getId_boleta());
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

    @Override
    public void cambiarEstado(int id, boolean activo) {
        String sql = "UPDATE Boletas SET activo = ? WHERE id_boleta = ?";
        jdbcTemplate.update(sql, activo, id);
    }
}