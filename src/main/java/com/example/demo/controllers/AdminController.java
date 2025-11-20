package com.example.demo.controllers;

import com.example.demo.models.Categoria;
import com.example.demo.models.Producto;
import com.example.demo.models.Boleta;
import com.example.demo.models.DetalleBoleta;
import com.example.demo.services.BoletaService;
import com.example.demo.services.DetalleBoletaService;
import com.example.demo.services.ProductoService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @GetMapping({"", "/"})
    public String adminRoot() {
        return "redirect:/admin/panel";
    }

    @GetMapping("/panel")
    public String verPanel() {
        return "adminpanel";
    }

    @PostMapping("/login")
    public String login(@RequestParam String usuario, @RequestParam String clave) {
        if ("admin".equals(usuario) && "1234admin".equals(clave)) {
            return "redirect:/admin/panel";
        }
        return "redirect:/login";
    }

    @GetMapping("/reportes")
    public String verReportes(Model model, @RequestParam(value = "mes", required = false) String mesParam) throws com.fasterxml.jackson.core.JsonProcessingException {
        // Cargar todas las boletas UNA SOLA VEZ
        java.util.List<Boleta> todasLasBoletas = boletaService.listarTodas();
        
        // Cargar productos y categorías en memoria UNA SOLA VEZ
        java.util.Map<Integer, Producto> prodById = new java.util.HashMap<>();
        for (Producto producto : productoService.listarTodos()) {
            prodById.put(producto.getId_producto(), producto);
        }
        
        java.util.Map<Integer, String> catNombreById = new java.util.HashMap<>();
        for (Categoria categoria : productoService.listarCategorias()) {
            catNombreById.put(categoria.getId_categoria(), categoria.getNombre_categoria());
        }

        // Acumuladores (usar TreeMap para mantener orden cronológico)
        double ingresos = 0;
        java.util.Map<String, Double> ventasPorMes = new java.util.TreeMap<>();
        java.util.Map<String, Integer> pedidosPorMes = new java.util.TreeMap<>();
        java.util.Map<String, Integer> unidadesPorCategoria = new java.util.HashMap<>();
        java.util.Map<String, Integer> unidadesPorProducto = new java.util.HashMap<>();

        // Procesar todas las boletas en UNA SOLA ITERACIÓN
        for (Boleta b : todasLasBoletas) {
            ingresos += b.getTotal();
            
            if (b.getFecha_emision() != null) {
                java.time.YearMonth ym = java.time.YearMonth.from(b.getFecha_emision());
                String clave = ym.toString();
                ventasPorMes.merge(clave, b.getTotal(), Double::sum);
                pedidosPorMes.merge(clave, 1, Integer::sum);
            }

            // Procesar detalles
            java.util.List<DetalleBoleta> detalles = detalleBoletaService.listarPorBoleta(b.getId_boleta());
            for (DetalleBoleta d : detalles) {
                Producto p = prodById.get(d.getId_producto());
                if (p == null) continue;
                
                String catNombre = catNombreById.getOrDefault(p.getId_categoria(), "Desconocida");
                unidadesPorCategoria.merge(catNombre, d.getCantidad(), Integer::sum);
                unidadesPorProducto.merge(p.getNombre(), d.getCantidad(), Integer::sum);
            }
        }

        // Ingresos totales
        model.addAttribute("ingresosGenerados", String.format("%.2f", ingresos));

        // Mayor mes de ventas
        String mayorMesVentas = null;
        double mayorMonto = Double.NEGATIVE_INFINITY;
        for (java.util.Map.Entry<String, Double> entry : ventasPorMes.entrySet()) {
            if (entry.getValue() > mayorMonto) {
                mayorMonto = entry.getValue();
                mayorMesVentas = entry.getKey();
            }
        }
        if (mayorMesVentas != null) {
            model.addAttribute("mayorMesVentas", mayorMesVentas);
        }

        // Meses disponibles
        java.util.List<String> mesesDisponibles = new java.util.ArrayList<>(ventasPorMes.keySet());
        java.util.Collections.sort(mesesDisponibles);
        model.addAttribute("mesesDisponibles", mesesDisponibles);

        // Mes seleccionado
        java.time.YearMonth selectedMes = null;
        if (mesParam != null && !mesParam.isBlank()) {
            try { selectedMes = java.time.YearMonth.parse(mesParam); } catch (Exception ignored) {}
        }
        if (selectedMes == null && !ventasPorMes.isEmpty()) {
            selectedMes = java.time.YearMonth.parse(mesesDisponibles.get(mesesDisponibles.size() - 1));
        }

        // Calcular promedio de pedidos mensuales
        double promedioPedidos = 0;
        if (!pedidosPorMes.isEmpty()) {
            int totalPedidos = 0;
            for (Integer pedidos : pedidosPorMes.values()) {
                totalPedidos += pedidos;
            }
            promedioPedidos = (double) totalPedidos / pedidosPorMes.size();
        }
        model.addAttribute("promedioPedidosMensuales", String.format("%.1f", promedioPedidos));

        // Datos del mes seleccionado
        if (selectedMes != null) {
            final String mesKey = selectedMes.toString();
            model.addAttribute("selectedMes", mesKey);
            model.addAttribute("ingresosMes", String.format("%.2f", ventasPorMes.getOrDefault(mesKey, 0.0)));
            model.addAttribute("pedidosMes", pedidosPorMes.getOrDefault(mesKey, 0));

            // Mejor producto del mes
            final java.time.YearMonth finalSelectedMes = selectedMes;
            java.util.Map<String, Integer> unidadesPorProductoMes = new java.util.HashMap<>();
            
            for (Boleta boleta : todasLasBoletas) {
                if (boleta.getFecha_emision() != null && java.time.YearMonth.from(boleta.getFecha_emision()).equals(finalSelectedMes)) {
                    java.util.List<DetalleBoleta> detalles = detalleBoletaService.listarPorBoleta(boleta.getId_boleta());
                    for (DetalleBoleta detalle : detalles) {
                        Producto p = prodById.get(detalle.getId_producto());
                        if (p != null) {
                            unidadesPorProductoMes.merge(p.getNombre(), detalle.getCantidad(), Integer::sum);
                        }
                    }
                }
            }

            java.util.Map.Entry<String, Integer> mejorProductoEntry = null;
            for (java.util.Map.Entry<String, Integer> entry : unidadesPorProductoMes.entrySet()) {
                if (mejorProductoEntry == null || entry.getValue() > mejorProductoEntry.getValue()) {
                    mejorProductoEntry = entry;
                }
            }
            if (mejorProductoEntry != null) {
                model.addAttribute("mejorProductoMes", mejorProductoEntry.getKey());
                model.addAttribute("cantidadMejorProductoMes", mejorProductoEntry.getValue());
            }
        }

        // Mayor categoría vendida
        java.util.Map.Entry<String, Integer> mayorCategoriaEntry = null;
        for (java.util.Map.Entry<String, Integer> entry : unidadesPorCategoria.entrySet()) {
            if (mayorCategoriaEntry == null || entry.getValue() > mayorCategoriaEntry.getValue()) {
                mayorCategoriaEntry = entry;
            }
        }
        if (mayorCategoriaEntry != null) {
            model.addAttribute("mayorCategoriaVendida", mayorCategoriaEntry.getKey());
            model.addAttribute("cantidadMayorCategoria", mayorCategoriaEntry.getValue());
        }

        // Datos para gráficos (solo los necesarios)
        com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
        model.addAttribute("ventasPorMesJson", mapper.writeValueAsString(ventasPorMes));
        model.addAttribute("pedidosPorMesJson", mapper.writeValueAsString(pedidosPorMes));
        model.addAttribute("unidadesPorCategoriaJson", mapper.writeValueAsString(unidadesPorCategoria));

        return "adminreporte";
    }

    private final ProductoService productoService;
    private final BoletaService boletaService;
    private final DetalleBoletaService detalleBoletaService;

    public AdminController(ProductoService productoService, BoletaService boletaService, DetalleBoletaService detalleBoletaService) {
        this.productoService = productoService;
        this.boletaService = boletaService;
        this.detalleBoletaService = detalleBoletaService;
    }

    @GetMapping("/productos")
    public String gestionarProductos(Model model) {
        model.addAttribute("productos", productoService.listarTodos());
        model.addAttribute("categorias", productoService.listarCategorias());
        return "adminproductos";
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
    public String actualizarProducto(@ModelAttribute Producto producto, @RequestParam("imagenFile") MultipartFile imagenFile) {
        productoService.actualizarProducto(producto, imagenFile);
        return "redirect:/admin/productos";
    }


    @PostMapping("/productos/guardar")
    public String guardarProducto(@ModelAttribute Producto producto, @RequestParam("imagenFile") MultipartFile imagenFile) {
        productoService.guardarProducto(producto, imagenFile);
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
}