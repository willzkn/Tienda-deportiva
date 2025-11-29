package com.example.demo.repositories.impl;

import com.example.demo.models.UsuarioAdmin;
import com.example.demo.repositories.UsuarioAdminDAO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class JdbcUsuarioAdminRepository implements UsuarioAdminDAO {

    private final JdbcTemplate jdbcTemplate;

    public JdbcUsuarioAdminRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<UsuarioAdmin> rowMapper = (rs, rowNum) -> {
        UsuarioAdmin u = new UsuarioAdmin();
        u.setId_usuario(rs.getInt("id_usuario"));
        u.setCorreo(rs.getString("correo"));
        u.setClave(rs.getString("clave"));
        u.setRol(rs.getString("rol"));
        u.setActivo(rs.getBoolean("activo"));
        return u;
    };

    @Override
    public List<UsuarioAdmin> findAll() {
        String sql = "SELECT id_usuario, correo, clave, rol, activo FROM UsuarioAdmin ORDER BY id_usuario";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Optional<UsuarioAdmin> findById(int id) {
        String sql = "SELECT id_usuario, correo, clave, rol, activo FROM UsuarioAdmin WHERE id_usuario = ?";
        List<UsuarioAdmin> resultados = jdbcTemplate.query(sql, rowMapper, id);
        if (resultados.isEmpty()) {
            return Optional.empty();
        }
        return Optional.of(resultados.get(0));
    }

    @Override
    public Optional<UsuarioAdmin> findByCorreo(String correo) {
        String sql = "SELECT id_usuario, correo, clave, rol, activo FROM UsuarioAdmin WHERE correo = ?";
        List<UsuarioAdmin> resultados = jdbcTemplate.query(sql, rowMapper, correo);
        if (resultados.isEmpty()) {
            return Optional.empty();
        }
        return Optional.of(resultados.get(0));
    }

    @Override
    public void save(UsuarioAdmin usuario) {
        String sql = "INSERT INTO UsuarioAdmin (correo, clave, rol, activo) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, usuario.getCorreo(), usuario.getClave(), usuario.getRol(), usuario.isActivo());
    }

    @Override
    public void update(UsuarioAdmin usuario) {
        String sql = "UPDATE UsuarioAdmin SET correo = ?, clave = ?, rol = ?, activo = ? WHERE id_usuario = ?";
        jdbcTemplate.update(sql, usuario.getCorreo(), usuario.getClave(), usuario.getRol(), usuario.isActivo(),
                usuario.getId_usuario());
    }

    @Override
    public void deleteById(int id) {
        String sql = "DELETE FROM UsuarioAdmin WHERE id_usuario = ?";
        jdbcTemplate.update(sql, id);
    }

    @Override
    public void cambiarEstado(int id, boolean activo) {
        String sql = "UPDATE UsuarioAdmin SET activo = ? WHERE id_usuario = ?";
        jdbcTemplate.update(sql, activo, id);
    }
}
