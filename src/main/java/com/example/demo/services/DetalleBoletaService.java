package com.example.demo.services;

import com.example.demo.models.DetalleBoleta;
import java.util.List;
import java.util.Optional;

public interface DetalleBoletaService {
    List<DetalleBoleta> listarPorBoleta(int idBoleta);
    Optional<DetalleBoleta> obtenerPorId(int id);
    void guardar(DetalleBoleta detalle);
    void actualizar(DetalleBoleta detalle);
    void eliminar(int id);
    void eliminarPorBoleta(int idBoleta);
}
