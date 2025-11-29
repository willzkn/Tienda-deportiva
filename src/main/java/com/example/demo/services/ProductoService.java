package com.example.demo.services;

import com.example.demo.models.Categoria;
import com.example.demo.models.Producto;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Optional;

public interface ProductoService {
    List<Producto> listarTodos();

    List<Producto> listarActivos();

    Optional<Producto> obtenerPorId(int id);

    void guardarProducto(Producto producto, MultipartFile imagen);

    void actualizarProducto(Producto producto, MultipartFile imagen);

    void eliminarProducto(int id);

    void deleteById(int id);

    void cambiarEstado(int id, boolean activo);

    List<Categoria> listarCategorias();

    List<Categoria> findAllCategorias();
}