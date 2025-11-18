package com.example.demo.services;

import com.example.demo.models.UsuarioAdmin;
import java.util.List;
import java.util.Optional;

public interface UsuarioAdminService {
    List<UsuarioAdmin> listarTodos();
    Optional<UsuarioAdmin> obtenerPorId(int id);
    void guardar(UsuarioAdmin usuario);
    void actualizar(UsuarioAdmin usuario);
    void eliminar(int id);
}
