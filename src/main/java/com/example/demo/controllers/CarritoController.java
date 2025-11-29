package com.example.demo.controllers;

import com.example.demo.models.Boleta;
import com.example.demo.models.DetalleBoleta;
import com.example.demo.models.UsuarioAdmin;
import com.example.demo.services.BoletaService;
import com.example.demo.services.DetalleBoletaService;
import com.example.demo.services.UsuarioAdminService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Controlador para el carrito de compras y proceso de checkout.
 */
@Controller
public class CarritoController {

    private final BoletaService boletaService;
    private final DetalleBoletaService detalleBoletaService;
    private final UsuarioAdminService usuarioAdminService;

    public CarritoController(BoletaService boletaService, DetalleBoletaService detalleBoletaService,
            UsuarioAdminService usuarioAdminService) {
        this.boletaService = boletaService;
        this.detalleBoletaService = detalleBoletaService;
        this.usuarioAdminService = usuarioAdminService;
    }

    /**
     * Devuelve la página principal del carrito.
     */
    @GetMapping("/carrito")
    public String verCarrito() {
        return "carrito";
    }

    /**
     * Procesa el checkout: crea una boleta y sus detalles.
     */
    @PostMapping("/carrito/checkout")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> procesarCheckout(
            @RequestBody CheckoutRequest request,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            System.out.println("Iniciando procesarCheckout...");

            // Validar que hay items en el carrito
            if (request.getItems() == null || request.getItems().isEmpty()) {
                System.out.println("Carrito vacío");
                response.put("success", false);
                response.put("message", "El carrito está vacío");
                return ResponseEntity.badRequest().body(response);
            }

            // Calcular total
            double total = 0;
            for (ItemCarrito item : request.getItems()) {
                total += item.getPrecio() * item.getCantidad();
            }
            System.out.println("Total calculado: " + total);

            // Crear la boleta
            Boleta boleta = new Boleta();

            // Obtener ID de usuario si está logueado, sino usar/crear invitado
            UsuarioAdmin usuarioLogueado = (UsuarioAdmin) session.getAttribute("usuarioLogueado");
            if (usuarioLogueado != null) {
                System.out.println("Usuario logueado ID: " + usuarioLogueado.getId_usuario());
                boleta.setId_usuario(usuarioLogueado.getId_usuario());
            } else {
                System.out.println("Usuario NO logueado. Buscando/Creando usuario invitado...");
                String correoInvitado = "invitado@ventadepor.com";
                Optional<UsuarioAdmin> invitadoOpt = usuarioAdminService.obtenerPorCorreo(correoInvitado);
                UsuarioAdmin invitado;

                if (invitadoOpt.isPresent()) {
                    invitado = invitadoOpt.get();
                    System.out.println("Usuario invitado encontrado ID: " + invitado.getId_usuario());
                } else {
                    System.out.println("Creando nuevo usuario invitado...");
                    invitado = new UsuarioAdmin();
                    invitado.setCorreo(correoInvitado);
                    invitado.setClave("guest123"); // Contraseña dummy
                    invitado.setRol("Cliente");
                    invitado.setActivo(true);
                    usuarioAdminService.guardar(invitado);

                    // Recuperar para obtener ID (ya que save no devuelve ID en
                    // UsuarioAdminRepository actual)
                    invitado = usuarioAdminService.obtenerPorCorreo(correoInvitado)
                            .orElseThrow(
                                    () -> new RuntimeException("Error al recuperar usuario invitado recién creado"));
                    System.out.println("Usuario invitado creado con ID: " + invitado.getId_usuario());
                }
                boleta.setId_usuario(invitado.getId_usuario());
            }

            boleta.setFecha_emision(LocalDateTime.now());
            boleta.setTotal(total);
            boleta.setActivo(true);

            // Guardar boleta
            System.out.println("Guardando boleta...");
            boletaService.guardar(boleta);

            int idBoleta = boleta.getId_boleta();
            System.out.println("Boleta guardada con ID: " + idBoleta);

            // Guardar detalles de la boleta
            for (ItemCarrito item : request.getItems()) {
                DetalleBoleta detalle = new DetalleBoleta();
                detalle.setId_boleta(idBoleta);
                detalle.setId_producto(item.getId());
                detalle.setCantidad(item.getCantidad());
                detalle.setPrecio_unitario(item.getPrecio());

                detalleBoletaService.guardar(detalle);
            }
            System.out.println("Detalles guardados.");

            // Respuesta exitosa
            response.put("success", true);
            response.put("message", "Compra procesada exitosamente");
            response.put("boletaId", idBoleta);
            response.put("total", total);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("ERROR en procesarCheckout: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error al procesar la compra: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }

    /**
     * DTO para recibir la petición de checkout.
     */
    public static class CheckoutRequest {
        private String nombre;
        private String email;
        private String direccion;
        private String ciudad;
        private String codigoPostal;
        private List<ItemCarrito> items;

        // Getters y setters
        public String getNombre() {
            return nombre;
        }

        public void setNombre(String nombre) {
            this.nombre = nombre;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getDireccion() {
            return direccion;
        }

        public void setDireccion(String direccion) {
            this.direccion = direccion;
        }

        public String getCiudad() {
            return ciudad;
        }

        public void setCiudad(String ciudad) {
            this.ciudad = ciudad;
        }

        public String getCodigoPostal() {
            return codigoPostal;
        }

        public void setCodigoPostal(String codigoPostal) {
            this.codigoPostal = codigoPostal;
        }

        public List<ItemCarrito> getItems() {
            return items;
        }

        public void setItems(List<ItemCarrito> items) {
            this.items = items;
        }
    }

    /**
     * DTO para items del carrito.
     */
    public static class ItemCarrito {
        private int id;
        private String nombre;
        private double precio;
        private int cantidad;

        // Getters y setters
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getNombre() {
            return nombre;
        }

        public void setNombre(String nombre) {
            this.nombre = nombre;
        }

        public double getPrecio() {
            return precio;
        }

        public void setPrecio(double precio) {
            this.precio = precio;
        }

        public int getCantidad() {
            return cantidad;
        }

        public void setCantidad(int cantidad) {
            this.cantidad = cantidad;
        }
    }
}