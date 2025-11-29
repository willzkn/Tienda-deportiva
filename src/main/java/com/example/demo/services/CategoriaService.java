package com.example.demo.services;

import com.example.demo.models.Categoria;
import java.util.List;
import java.util.Optional;

public interface CategoriaService {
    List<Categoria> listarTodas();

    Optional<Categoria> obtenerPorId(int id);

    void guardar(Categoria categoria);

    void actualizar(Categoria categoria);

    void deleteById(int id);

    void cambiarEstado(int id, boolean activo);
}
