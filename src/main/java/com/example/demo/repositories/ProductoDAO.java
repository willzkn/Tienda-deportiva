package com.example.demo.repositories;

import com.example.demo.models.Producto;
import com.example.demo.models.Categoria;
import java.util.List;
import java.util.Optional;

/**
 * Contrato de acceso a datos para productos y sus categorías asociadas.
 */
public interface ProductoDAO {
    List<Producto> findAll();

    List<Producto> findAllActive();

    Optional<Producto> findById(int id);

    void save(Producto producto);

    void update(Producto producto);

    void deleteById(int id);

    void cambiarEstado(int id, boolean activo);

    List<Categoria> findAllCategorias();
}