package com.example.demo.repositories;

import com.example.demo.models.DetalleBoleta;
import java.util.List;
import java.util.Optional;

/**
 * Contrato de acceso a datos para los detalles de boleta.
 */
public interface DetalleBoletaDAO {
    List<DetalleBoleta> findByBoletaId(int idBoleta);
    Optional<DetalleBoleta> findById(int id);
    void save(DetalleBoleta detalle);
    void update(DetalleBoleta detalle);
    void deleteById(int id);
    void deleteByBoletaId(int idBoleta);
}
