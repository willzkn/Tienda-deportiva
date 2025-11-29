package com.example.demo.services;

import com.example.demo.models.UsuarioAdmin;
import java.util.List;
import java.util.Optional;

public interface UsuarioAdminService {
    List<UsuarioAdmin> listarTodos();

    Optional<UsuarioAdmin> obtenerPorId(int id);

    Optional<UsuarioAdmin> autenticar(String correo, String clave);

    Optional<UsuarioAdmin> obtenerPorCorreo(String correo);

    void guardar(UsuarioAdmin usuario);

    void actualizar(UsuarioAdmin usuario);

    void eliminar(int id);

    void cambiarEstado(int id, boolean activo);
}
