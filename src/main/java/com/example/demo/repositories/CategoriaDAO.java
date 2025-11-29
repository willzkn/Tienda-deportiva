package com.example.demo.repositories;

import com.example.demo.models.Categoria;
import java.util.List;
import java.util.Optional;

/**
 * Contrato de acceso a datos para categorías.
 */
public interface CategoriaDAO {
    List<Categoria> findAll();

    List<Categoria> findAllActivos();

    Optional<Categoria> findById(int id);

    void save(Categoria categoria);

    void update(Categoria categoria);

    void deleteById(int id);

    void cambiarEstado(int id, boolean activo);
}
