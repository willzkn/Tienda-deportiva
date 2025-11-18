package com.example.demo.services.impl;

import com.example.demo.models.DetalleBoleta;
import com.example.demo.repositories.DetalleBoletaDAO;
import com.example.demo.services.DetalleBoletaService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DetalleBoletaServiceImpl implements DetalleBoletaService {

    private final DetalleBoletaDAO detalleBoletaDAO;

    public DetalleBoletaServiceImpl(DetalleBoletaDAO detalleBoletaDAO) {
        this.detalleBoletaDAO = detalleBoletaDAO;
    }

    @Override
    public List<DetalleBoleta> listarPorBoleta(int idBoleta) { return detalleBoletaDAO.findByBoletaId(idBoleta); }

    @Override
    public Optional<DetalleBoleta> obtenerPorId(int id) { return detalleBoletaDAO.findById(id); }

    @Override
    public void guardar(DetalleBoleta detalle) { detalleBoletaDAO.save(detalle); }

    @Override
    public void actualizar(DetalleBoleta detalle) { detalleBoletaDAO.update(detalle); }

    @Override
    public void eliminar(int id) { detalleBoletaDAO.deleteById(id); }

    @Override
    public void eliminarPorBoleta(int idBoleta) { detalleBoletaDAO.deleteByBoletaId(idBoleta); }
}
