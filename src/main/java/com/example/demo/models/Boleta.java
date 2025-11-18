package com.example.demo.models;

import java.time.LocalDateTime;

public class Boleta {
    private int id_boleta;
    private int id_usuario;
    private LocalDateTime fecha_emision;
    private double total;

    // Display fields (from joins)
    private String usuario_correo;

    public int getId_boleta() { return id_boleta; }
    public void setId_boleta(int id_boleta) { this.id_boleta = id_boleta; }

    public int getId_usuario() { return id_usuario; }
    public void setId_usuario(int id_usuario) { this.id_usuario = id_usuario; }

    public LocalDateTime getFecha_emision() { return fecha_emision; }
    public void setFecha_emision(LocalDateTime fecha_emision) { this.fecha_emision = fecha_emision; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getUsuario_correo() { return usuario_correo; }
    public void setUsuario_correo(String usuario_correo) { this.usuario_correo = usuario_correo; }
}