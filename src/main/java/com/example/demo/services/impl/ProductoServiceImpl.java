package com.example.demo.services.impl;

import com.example.demo.models.Categoria;
import com.example.demo.models.Producto;
import com.example.demo.repositories.ProductoDAO;
import com.example.demo.services.ProductoService;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * Servicio intermedio para el CRUD de productos; delega en JDBC y se encarga de cargar/retener la imagen.
 */
@Service
public class ProductoServiceImpl implements ProductoService {

    private final ProductoDAO productoDao;

    public ProductoServiceImpl(ProductoDAO productoDao) {
        this.productoDao = productoDao;
    }

    @Override
    public List<Producto> listarTodos() {
        return productoDao.findAll();
    }

    @Override
    public Optional<Producto> obtenerPorId(int id) {
        return productoDao.findById(id);
    }

    @Override
    public void guardarProducto(Producto producto, MultipartFile imagenFile) {
        // Si llega un archivo, se transforma a bytes antes de persistir.
        if (imagenFile != null && !imagenFile.isEmpty()) {
            try {
                producto.setImagen(imagenFile.getBytes());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        productoDao.save(producto);
    }

    @Override
    public void actualizarProducto(Producto producto, MultipartFile imagenFile) {
        // Reemplaza la imagen sólo cuando se adjunta una nueva; caso contrario conserva la existente.
        if (imagenFile != null && !imagenFile.isEmpty()) {
            try {
                producto.setImagen(imagenFile.getBytes());
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            // Preservar la imagen existente si no se sube una nueva
            Optional<Producto> productoExistente = productoDao.findById(producto.getId_producto());
            if (productoExistente.isPresent()) {
                producto.setImagen(productoExistente.get().getImagen());
            }
        }
        productoDao.update(producto);
    }

    @Override
    public void eliminarProducto(int id) {
        productoDao.deleteById(id);
    }
    
    @Override
    public List<Categoria> listarCategorias() {
        return productoDao.findAllCategorias();
    }
}