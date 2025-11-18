package com.example.demo.repositories.impl;

import com.example.demo.models.Categoria;
import com.example.demo.models.Producto;
import com.example.demo.repositories.ProductoDAO;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Primary
@Repository
public class JdbcProductoRepository implements ProductoDAO {

    private final JdbcTemplate jdbcTemplate;

    public JdbcProductoRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Producto> productoRowMapper = (rs, rowNum) -> {
        Producto producto = new Producto();
        producto.setId_producto(rs.getInt("id_producto"));
        producto.setSku(rs.getString("sku"));
        producto.setNombre(rs.getString("nombre"));
        producto.setId_categoria(rs.getInt("id_categoria"));
        producto.setPrecio(rs.getDouble("precio"));
        producto.setStock(rs.getInt("stock"));
        producto.setImagen(rs.getBytes("imagen"));
        return producto;
    };
    
    private final RowMapper<Categoria> categoriaRowMapper = (rs, rowNum) -> {
        Categoria categoria = new Categoria();
        categoria.setId_categoria(rs.getInt("id_categoria"));
        categoria.setNombre_categoria(rs.getString("nombre_categoria"));
        return categoria;
    };

    @Override
    public List<Producto> findAll() {
        String sql = "SELECT * FROM Productos";
        return jdbcTemplate.query(sql, productoRowMapper);
    }

    @Override
    public Optional<Producto> findById(int id) {
        String sql = "SELECT * FROM Productos WHERE id_producto = ?";
        return jdbcTemplate.query(sql, productoRowMapper, id).stream().findFirst();
    }

    @Override
    public void save(Producto producto) {
        String sql = "INSERT INTO Productos (sku, nombre, id_categoria, precio, stock, imagen) VALUES (?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                producto.getSku(),
                producto.getNombre(),
                producto.getId_categoria(),
                producto.getPrecio(),
                producto.getStock(),
                producto.getImagen());
    }

    @Override
    public void update(Producto producto) {
        String sql = "UPDATE Productos SET sku = ?, nombre = ?, id_categoria = ?, precio = ?, stock = ?, imagen = ? WHERE id_producto = ?";
        jdbcTemplate.update(sql,
                producto.getSku(),
                producto.getNombre(),
                producto.getId_categoria(),
                producto.getPrecio(),
                producto.getStock(),
                producto.getImagen(),
                producto.getId_producto());
    }

    @Override
    public void deleteById(int id) {
        String sql = "DELETE FROM Productos WHERE id_producto = ?";
        jdbcTemplate.update(sql, id);
    }
    
    @Override
    public List<Categoria> findAllCategorias() {
        String sql = "SELECT * FROM Categorias";
        return jdbcTemplate.query(sql, categoriaRowMapper);
    }
}