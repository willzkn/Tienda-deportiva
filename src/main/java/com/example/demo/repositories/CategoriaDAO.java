package com.example.demo.repositories;

import com.example.demo.models.Categoria;
import java.util.List;
import java.util.Optional;

public interface CategoriaDAO {
    List<Categoria> findAll();
    Optional<Categoria> findById(int id);
    void save(Categoria categoria);
    void update(Categoria categoria);
    void deleteById(int id);
}
