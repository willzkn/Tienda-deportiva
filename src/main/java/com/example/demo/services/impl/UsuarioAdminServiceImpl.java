package com.example.demo.services.impl;

import com.example.demo.models.UsuarioAdmin;
import com.example.demo.repositories.UsuarioAdminDAO;
import com.example.demo.services.UsuarioAdminService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

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
}
