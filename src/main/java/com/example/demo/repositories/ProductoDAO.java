package com.example.demo.repositories;

import com.example.demo.models.Producto;
import com.example.demo.models.Categoria; 
import java.util.List;
import java.util.Optional;

public interface ProductoDAO {
    List<Producto> findAll();
    Optional<Producto> findById(int id);
    void save(Producto producto);
    void update(Producto producto);
    void deleteById(int id);
    List<Categoria> findAllCategorias();
}