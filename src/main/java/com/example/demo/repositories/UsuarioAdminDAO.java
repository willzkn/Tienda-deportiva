package com.example.demo.repositories;

import com.example.demo.models.UsuarioAdmin;
import java.util.List;
import java.util.Optional;

/**
 * Contrato de acceso a datos para usuarios administradores.
 */
public interface UsuarioAdminDAO {
    List<UsuarioAdmin> findAll();

    Optional<UsuarioAdmin> findById(int id);

    Optional<UsuarioAdmin> findByCorreo(String correo);

    void save(UsuarioAdmin usuario);

    void update(UsuarioAdmin usuario);

    void deleteById(int id);

    void cambiarEstado(int id, boolean activo);
}
