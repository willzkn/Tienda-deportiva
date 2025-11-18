package com.example.demo.controllers;

import com.example.demo.models.Producto;
import com.example.demo.services.ProductoService;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.Optional;

@Controller
public class ImageController {

    private final ProductoService productoService;

    public ImageController(ProductoService productoService) {
        this.productoService = productoService;
    }

    @GetMapping("/productos/imagen/{id}")
    public ResponseEntity<byte[]> mostrarImagen(@PathVariable("id") int id) {
        Optional<Producto> productoOpt = productoService.obtenerPorId(id);
        if (productoOpt.isPresent() && productoOpt.get().getImagen() != null) {
            Producto producto = productoOpt.get();
            return ResponseEntity.ok().contentType(MediaType.IMAGE_JPEG).body(producto.getImagen());
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}