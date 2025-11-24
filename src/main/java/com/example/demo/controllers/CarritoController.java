package com.example.demo.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Expone la vista del carrito de compras.
 */
@Controller
public class CarritoController {

    /**
     * Devuelve la página principal del carrito.
     */
    @GetMapping("/carrito")
    public String verCarrito() {
        return "carrito";
    }
}