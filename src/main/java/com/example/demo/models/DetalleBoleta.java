package com.example.demo.models;

public class DetalleBoleta {
    private int id_detalle_boleta;
    private int id_boleta;
    private int id_producto;
    private int cantidad;
    private double precio_unitario;

    // Display fields
    private String producto_nombre;

    public int getId_detalle_boleta() { return id_detalle_boleta; }
    public void setId_detalle_boleta(int id_detalle_boleta) { this.id_detalle_boleta = id_detalle_boleta; }

    public int getId_boleta() { return id_boleta; }
    public void setId_boleta(int id_boleta) { this.id_boleta = id_boleta; }

    public int getId_producto() { return id_producto; }
    public void setId_producto(int id_producto) { this.id_producto = id_producto; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public double getPrecio_unitario() { return precio_unitario; }
    public void setPrecio_unitario(double precio_unitario) { this.precio_unitario = precio_unitario; }

    public String getProducto_nombre() { return producto_nombre; }
    public void setProducto_nombre(String producto_nombre) { this.producto_nombre = producto_nombre; }
}
