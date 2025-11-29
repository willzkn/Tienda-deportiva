package com.example.demo.services.impl;

import com.example.demo.models.Boleta;
import com.example.demo.repositories.BoletaDAO;
import com.example.demo.services.BoletaService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Implementación del servicio de boletas: delega las operaciones CRUD al
 * repositorio JDBC.
 */
@Service
public class BoletaServiceImpl implements BoletaService {

    private final BoletaDAO boletaDao;

    public BoletaServiceImpl(BoletaDAO boletaDao) {
        this.boletaDao = boletaDao;
    }

    @Override
    public List<Boleta> listarTodas() {
        return boletaDao.findAll();
    }

    @Override
    public Optional<Boleta> obtenerPorId(int id) {
        return boletaDao.findById(id);
    }

    @Override
    public void guardar(Boleta boleta) {
        boletaDao.save(boleta);
    }

    @Override
    public void actualizar(Boleta boleta) {
        boletaDao.update(boleta);
    }

    @Override
    public void deleteById(int id) {
        boletaDao.deleteById(id);
    }

    @Override
    public void cambiarEstado(int id, boolean activo) {
        boletaDao.cambiarEstado(id, activo);
    }

    @Override
    public void recalcTotal(int idBoleta) {
        boletaDao.recalcTotal(idBoleta);
    }
}
