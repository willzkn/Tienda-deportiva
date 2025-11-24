package com.example.demo.repositories.impl;

import com.example.demo.models.Categoria;
import com.example.demo.repositories.CategoriaDAO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Implementación JDBC de CategoriaDAO con JdbcTemplate.
 */
@Repository
public class JdbcCategoriaRepository implements CategoriaDAO {

    private final JdbcTemplate jdbcTemplate;

    public JdbcCategoriaRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Categoria> rowMapper = (rs, rowNum) -> {
        Categoria c = new Categoria();
        c.setId_categoria(rs.getInt("id_categoria"));
        c.setNombre_categoria(rs.getString("nombre_categoria"));
        return c;
    };

    @Override
    public List<Categoria> findAll() {
        String sql = "SELECT id_categoria, nombre_categoria FROM Categorias ORDER BY id_categoria";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Optional<Categoria> findById(int id) {
        String sql = "SELECT id_categoria, nombre_categoria FROM Categorias WHERE id_categoria = ?";
        List<Categoria> resultados = jdbcTemplate.query(sql, rowMapper, id);
        if (resultados.isEmpty()) {
            return Optional.empty();
        }
        return Optional.of(resultados.get(0));
    }

    @Override
    public void save(Categoria categoria) {
        String sql = "INSERT INTO Categorias (nombre_categoria) VALUES (?)";
        jdbcTemplate.update(sql, categoria.getNombre_categoria());
    }

    @Override
    public void update(Categoria categoria) {
        String sql = "UPDATE Categorias SET nombre_categoria = ? WHERE id_categoria = ?";
        jdbcTemplate.update(sql, categoria.getNombre_categoria(), categoria.getId_categoria());
    }

    @Override
    public void deleteById(int id) {
        String sql = "DELETE FROM Categorias WHERE id_categoria = ?";
        jdbcTemplate.update(sql, id);
    }
}
