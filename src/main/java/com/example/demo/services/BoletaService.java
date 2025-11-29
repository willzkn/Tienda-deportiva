package com.example.demo.services;

import com.example.demo.models.Boleta;
import java.util.List;
import java.util.Optional;

public interface BoletaService {
    List<Boleta> listarTodas();

    Optional<Boleta> obtenerPorId(int id);

    void guardar(Boleta boleta);

    void actualizar(Boleta boleta);

    void deleteById(int id);

    void cambiarEstado(int id, boolean activo);

    void recalcTotal(int idBoleta);
}
