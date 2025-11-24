package com.example.demo.repositories;

import com.example.demo.models.Boleta;
import java.util.List;
import java.util.Optional;

/**
 * Contrato de acceso a datos para boletas.
 */
public interface BoletaDAO {
    List<Boleta> findAll();
    Optional<Boleta> findById(int id);
    void save(Boleta boleta);
    void update(Boleta boleta);
    void deleteById(int id);
    void recalcTotal(int idBoleta);
}
