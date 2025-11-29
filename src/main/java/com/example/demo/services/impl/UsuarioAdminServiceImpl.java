package com.example.demo.services.impl;

import com.example.demo.models.UsuarioAdmin;
import com.example.demo.repositories.UsuarioAdminDAO;
import com.example.demo.services.UsuarioAdminService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Servicio para gestionar usuarios administradores mediante el DAO
 * correspondiente.
 */
@Service
public class UsuarioAdminServiceImpl implements UsuarioAdminService {

    private final UsuarioAdminDAO usuarioAdminDao;

    public UsuarioAdminServiceImpl(UsuarioAdminDAO usuarioAdminDao) {
        this.usuarioAdminDao = usuarioAdminDao;
    }

    @Override
    public List<UsuarioAdmin> listarTodos() {
        return usuarioAdminDao.findAll();
    }

    @Override
    public Optional<UsuarioAdmin> obtenerPorId(int id) {
        return usuarioAdminDao.findById(id);
    }

    @Override
    public Optional<UsuarioAdmin> autenticar(String correo, String clave) {
        Optional<UsuarioAdmin> usuarioOpt = usuarioAdminDao.findByCorreo(correo);
        if (usuarioOpt.isPresent()) {
            UsuarioAdmin usuario = usuarioOpt.get();
            // Verificar que la contraseña coincida
            if (usuario.getClave().equals(clave)) {
                return Optional.of(usuario);
            }
        }
        return Optional.empty();
    }

    @Override
    public Optional<UsuarioAdmin> obtenerPorCorreo(String correo) {
        return usuarioAdminDao.findByCorreo(correo);
    }

    @Override
    public void guardar(UsuarioAdmin usuario) {
        usuarioAdminDao.save(usuario);
    }

    @Override
    public void actualizar(UsuarioAdmin usuario) {
        usuarioAdminDao.update(usuario);
    }

    @Override
    public void eliminar(int id) {
        usuarioAdminDao.deleteById(id);
    }

    @Override
    public void cambiarEstado(int id, boolean activo) {
        usuarioAdminDao.cambiarEstado(id, activo);
    }
}
