package com.example.demo.models;

import java.util.Base64;

public class Producto {
    private int id_producto;
    private String sku;
    private String nombre;
    private int id_categoria;
    private double precio;
    private int stock;
    private byte[] imagen;

    public int getId_producto() { return id_producto; }
    public void setId_producto(int id_producto) { this.id_producto = id_producto; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public int getId_categoria() { return id_categoria; }
    public void setId_categoria(int id_categoria) { this.id_categoria = id_categoria; }
    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public byte[] getImagen() { return imagen; }
    public void setImagen(byte[] imagen) { this.imagen = imagen; }

    public String getImagenBase64() {
        if (imagen == null || imagen.length == 0) {
            return null;
        }
        return Base64.getEncoder().encodeToString(imagen);
    }
}