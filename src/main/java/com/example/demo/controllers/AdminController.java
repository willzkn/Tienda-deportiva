package com.example.demo.controllers;

import com.example.demo.models.Producto;
import com.example.demo.models.Boleta;
import com.example.demo.models.UsuarioAdmin;
import com.example.demo.services.BoletaService;
import com.example.demo.services.ProductoService;
import com.example.demo.services.UsuarioAdminService;
import jakarta.servlet.http.HttpSession;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

/**
 * Gestiona el panel administrativo: autenticación simple, reportes y CRUD de
 * productos.
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    private final ProductoService productoService;
    private final BoletaService boletaService;
    private final UsuarioAdminService usuarioAdminService;

    public AdminController(ProductoService productoService, BoletaService boletaService,
            UsuarioAdminService usuarioAdminService) {
        this.productoService = productoService;
        this.boletaService = boletaService;
        this.usuarioAdminService = usuarioAdminService;
    }

    @GetMapping({ "", "/" })
    public String adminRoot() {
        return "redirect:/admin/panel";
    }

    @GetMapping("/panel")
    public String verPanel(HttpSession session, Model model) {
        UsuarioAdmin usuarioLogueado = (UsuarioAdmin) session.getAttribute("usuarioLogueado");
        if (usuarioLogueado == null) {
            return "redirect:/login";
        }

        if (!"Admin".equals(usuarioLogueado.getRol())) {
            return "redirect:/inicio";
        }

        model.addAttribute("usuario", usuarioLogueado);
        return "adminpanel";
    }

    @PostMapping("/login")
    public String login(@RequestParam String usuario, @RequestParam String clave,
            HttpSession session, RedirectAttributes redirectAttributes) {
        Optional<UsuarioAdmin> usuarioOpt = usuarioAdminService.autenticar(usuario, clave);

        if (usuarioOpt.isPresent()) {
            UsuarioAdmin usuarioLogueado = usuarioOpt.get();

            if (!usuarioLogueado.isActivo()) {
                redirectAttributes.addFlashAttribute("error",
                        "Tu cuenta ha sido desactivada. Contacta al administrador.");
                return "redirect:/login";
            }

            session.setAttribute("usuarioLogueado", usuarioLogueado);
            session.setAttribute("nombreUsuario", usuarioLogueado.getCorreo());
            session.setAttribute("rolUsuario", usuarioLogueado.getRol());

            if ("Admin".equals(usuarioLogueado.getRol())) {
                return "redirect:/admin/panel";
            } else {
                return "redirect:/inicio";
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "Correo o contraseña incorrectos");
            return "redirect:/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    /**
     * Construye las métricas del dashboard recorriendo boletas y sus detalles en
     * memoria para
     * calcular ingresos, pedidos y productos destacados por periodo seleccionado.
     */
    @GetMapping("/reportes")
    public String verReportes(Model model, @RequestParam(value = "mes", required = false) String mesParam)
            throws com.fasterxml.jackson.core.JsonProcessingException {
        java.util.List<Boleta> todasLasBoletas = boletaService.listarTodas();

        double ingresos = 0;
        java.util.Map<String, Double> ventasPorMes = new java.util.TreeMap<>();
        java.util.Map<String, Integer> pedidosPorMes = new java.util.TreeMap<>();

        for (Boleta b : todasLasBoletas) {
            ingresos += b.getTotal();

            if (b.getFecha_emision() != null) {
                java.time.YearMonth ym = java.time.YearMonth.from(b.getFecha_emision());
                String clave = ym.toString();
                ventasPorMes.merge(clave, b.getTotal(), Double::sum);
                pedidosPorMes.merge(clave, 1, Integer::sum);
            }
        }

        model.addAttribute("ingresosGenerados", String.format("%.2f", ingresos));

        java.util.List<String> mesesDisponibles = new java.util.ArrayList<>(ventasPorMes.keySet());
        java.util.Collections.sort(mesesDisponibles);
        model.addAttribute("mesesDisponibles", mesesDisponibles);

        java.time.YearMonth selectedMes = null;
        if (mesParam != null && !mesParam.isBlank()) {
            try {
                selectedMes = java.time.YearMonth.parse(mesParam);
            } catch (Exception ignored) {
            }
        }
        if (selectedMes == null && !mesesDisponibles.isEmpty()) {
            selectedMes = java.time.YearMonth.parse(mesesDisponibles.get(mesesDisponibles.size() - 1));
        }

        if (selectedMes != null) {
            final String mesKey = selectedMes.toString();
            model.addAttribute("selectedMes", mesKey);
            model.addAttribute("pedidosMes", pedidosPorMes.getOrDefault(mesKey, 0));
        } else {
            model.addAttribute("selectedMes", null);
            model.addAttribute("pedidosMes", 0);
        }

        double promedioPedidos = 0;
        if (!pedidosPorMes.isEmpty()) {
            int totalPedidos = 0;
            for (Integer pedidos : pedidosPorMes.values()) {
                totalPedidos += pedidos;
            }
            promedioPedidos = (double) totalPedidos / pedidosPorMes.size();
        }
        model.addAttribute("promedioPedidosMensuales", String.format("%.1f", promedioPedidos));

        com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
        model.addAttribute("ventasPorMesJson", mapper.writeValueAsString(ventasPorMes));
        model.addAttribute("pedidosPorMesJson", mapper.writeValueAsString(pedidosPorMes));

        java.util.Map<String, Integer> comprasPorCliente = new java.util.HashMap<>();
        for (Boleta b : todasLasBoletas) {
            if (b.getUsuario_correo() != null && !b.getUsuario_correo().isEmpty()) {
                comprasPorCliente.merge(b.getUsuario_correo(), 1, Integer::sum);
            }
        }

        java.util.Map<String, Integer> topClientes = comprasPorCliente.entrySet().stream()
                .sorted(java.util.Map.Entry.<String, Integer>comparingByValue().reversed())
                .limit(5)
                .collect(java.util.LinkedHashMap::new,
                        (m, e) -> m.put(e.getKey(), e.getValue()),
                        java.util.Map::putAll);

        model.addAttribute("topClientesJson", mapper.writeValueAsString(topClientes));
        return "adminreporte";
    }

    @GetMapping("/productos")
    public String gestionarProductos(Model model, HttpSession session) {
        UsuarioAdmin usuarioLogueado = (UsuarioAdmin) session.getAttribute("usuarioLogueado");
        if (usuarioLogueado == null) {
            return "redirect:/login";
        }

        if (!"Admin".equals(usuarioLogueado.getRol())) {
            return "redirect:/inicio";
        }

        model.addAttribute("usuarioLogueado", usuarioLogueado);
        model.addAttribute("productos", productoService.listarTodos());
        model.addAttribute("categorias", productoService.listarCategorias());
        return "adminproductos";
    }

    @GetMapping("/productos/nuevo")
    public String mostrarFormularioNuevo(Model model) {
        if (!model.containsAttribute("producto")) {
            Producto producto = new Producto();
            producto.setActivo(true);
            model.addAttribute("producto", producto);
        }
        model.addAttribute("categorias", productoService.listarCategorias());
        return "adminproducto-editar";
    }

    @GetMapping("/productos/editar/{id}")
    public String mostrarFormularioDeEdicion(@PathVariable("id") int id, Model model) {
        Optional<Producto> productoOpt = productoService.obtenerPorId(id);
        if (productoOpt.isPresent()) {
            model.addAttribute("producto", productoOpt.get());
            model.addAttribute("categorias", productoService.listarCategorias());
            return "adminproducto-editar";
        }
        return "redirect:/admin/productos";
    }

    @PostMapping("/productos/actualizar")
    public String actualizarProducto(@ModelAttribute Producto producto,
            @RequestParam("imagenFile") MultipartFile imagenFile,
            RedirectAttributes redirectAttributes) {
        productoService.actualizarProducto(producto, imagenFile);
        redirectAttributes.addFlashAttribute("success", "Producto actualizado correctamente");
        return "redirect:/admin/productos";
    }

    @PostMapping("/productos/guardar")
    public String guardarProducto(@ModelAttribute Producto producto,
            @RequestParam("imagenFile") MultipartFile imagenFile,
            RedirectAttributes redirectAttributes) {
        try {
            productoService.guardarProducto(producto, imagenFile);
            redirectAttributes.addFlashAttribute("success", "Producto registrado correctamente");
            return "redirect:/admin/productos";
        } catch (DataIntegrityViolationException ex) {
            redirectAttributes.addFlashAttribute("skuError", "Ya existe un producto con ese SKU");
            redirectAttributes.addFlashAttribute("producto", producto);
            return "redirect:/admin/productos/nuevo";
        }
    }

    @PostMapping("/productos/cambiar-estado")
    public String cambiarEstadoProducto(
            @RequestParam("id") int id,
            @RequestParam("activo") boolean activo,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        UsuarioAdmin usuarioLogueado = (UsuarioAdmin) session.getAttribute("usuarioLogueado");
        if (usuarioLogueado == null || !"Admin".equals(usuarioLogueado.getRol())) {
            return "redirect:/login";
        }

        try {
            productoService.cambiarEstado(id, activo);
            redirectAttributes.addFlashAttribute("success",
                    activo ? "Producto activado correctamente" : "Producto desactivado correctamente");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "No se pudo actualizar el estado del producto: " + e.getMessage());
        }

        return "redirect:/admin/productos";
    }

    @GetMapping("/productos/eliminar/{id}")
    public String eliminarProducto(@PathVariable("id") int id, Model model) {
        try {
            productoService.eliminarProducto(id);
        } catch (Exception e) {
            // Si hay error de integridad referencial, mostrar mensaje
            model.addAttribute("error", "No se puede eliminar el producto porque está asociado a boletas existentes");
            model.addAttribute("productos", productoService.listarTodos());
            model.addAttribute("categorias", productoService.listarCategorias());
            return "adminproductos";
        }
        return "redirect:/admin/productos";
    }

    @GetMapping("/usuarios")
    public String verUsuarios(Model model, HttpSession session) {
        UsuarioAdmin usuarioLogueado = (UsuarioAdmin) session.getAttribute("usuarioLogueado");
        if (usuarioLogueado == null) {
            return "redirect:/login";
        }

        if (!"Admin".equals(usuarioLogueado.getRol())) {
            return "redirect:/inicio";
        }

        model.addAttribute("usuarios", usuarioAdminService.listarTodos());
        model.addAttribute("usuarioLogueado", usuarioLogueado);

        return "adminusuarios";
    }

    @PostMapping("/usuarios/guardar")
    public String guardarUsuario(
            @RequestParam String correo,
            @RequestParam String clave,
            @RequestParam String rol,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (session.getAttribute("usuarioLogueado") == null) {
            return "redirect:/login";
        }

        try {
            UsuarioAdmin nuevoUsuario = new UsuarioAdmin();
            nuevoUsuario.setCorreo(correo);
            nuevoUsuario.setClave(clave);
            nuevoUsuario.setRol(rol);
            nuevoUsuario.setActivo(true);

            usuarioAdminService.guardar(nuevoUsuario);
            redirectAttributes.addFlashAttribute("success", "Usuario creado correctamente");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error al crear usuario: Posible correo duplicado.");
        }

        return "redirect:/admin/usuarios";
    }

    @PostMapping("/usuarios/cambiar-estado")
    public String cambiarEstadoUsuario(
            @RequestParam int id,
            @RequestParam boolean activo,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (session.getAttribute("usuarioLogueado") == null) {
            return "redirect:/login";
        }

        try {
            usuarioAdminService.cambiarEstado(id, activo);
            String mensaje = activo ? "Usuario activado correctamente" : "Usuario desactivado correctamente";
            redirectAttributes.addFlashAttribute("success", mensaje);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error al cambiar estado: " + e.getMessage());
        }

        return "redirect:/admin/usuarios";
    }
}