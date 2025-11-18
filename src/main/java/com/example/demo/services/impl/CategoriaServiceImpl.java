package com.example.demo.services.impl;

import com.example.demo.models.Categoria;
import com.example.demo.repositories.CategoriaDAO;
import com.example.demo.services.CategoriaService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoriaServiceImpl implements CategoriaService {

    private final CategoriaDAO categoriaDao;

    public CategoriaServiceImpl(CategoriaDAO categoriaDao) {
        this.categoriaDao = categoriaDao;
    }

    @Override
    public List<Categoria> listarTodas() {
        return categoriaDao.findAll();
    }

    @Override
    public Optional<Categoria> obtenerPorId(int id) {
        return categoriaDao.findById(id);
    }

    @Override
    public void guardar(Categoria categoria) {
        categoriaDao.save(categoria);
    }

    @Override
    public void actualizar(Categoria categoria) {
        categoriaDao.update(categoria);
    }

    @Override
    public void eliminar(int id) {
        categoriaDao.deleteById(id);
    }
}
