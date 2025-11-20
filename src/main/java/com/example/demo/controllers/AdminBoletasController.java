package com.example.demo.controllers;

import com.example.demo.models.Boleta;
import com.example.demo.models.DetalleBoleta;
import com.example.demo.services.BoletaService;
import com.example.demo.services.DetalleBoletaService;
import com.example.demo.services.ProductoService;
import com.example.demo.services.UsuarioAdminService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/boletas")
public class AdminBoletasController {

    private final BoletaService boletaService;
    private final DetalleBoletaService detalleBoletaService;
    private final ProductoService productoService;
    private final UsuarioAdminService usuarioAdminService;

    public AdminBoletasController(BoletaService boletaService,
                                  DetalleBoletaService detalleBoletaService,
                                  ProductoService productoService,
                                  UsuarioAdminService usuarioAdminService) {
        this.boletaService = boletaService;
        this.detalleBoletaService = detalleBoletaService;
        this.productoService = productoService;
        this.usuarioAdminService = usuarioAdminService;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("boletas", boletaService.listarTodas());
        return "adminboletas";
    }

    @GetMapping("/nuevo")
    public String nuevo(Model model) {
        model.addAttribute("boleta", new Boleta());
        model.addAttribute("usuarios", usuarioAdminService.listarTodos());
        return "adminboleta-editar";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable("id") int id, Model model) {
        Boleta boleta = obtenerBoleta(id, model);
        if (boleta == null) {
            return redirigirABoletas();
        }
        cargarListasBoleta(id, model);
        return "adminboleta-editar";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Boleta boleta) {
        if (boleta.getId_boleta() == 0) {
            boletaService.guardar(boleta);
        } else {
            boletaService.actualizar(boleta);
        }
        return "redirect:/admin/boletas";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable("id") int id) {
        detalleBoletaService.eliminarPorBoleta(id);
        boletaService.eliminar(id);
        return "redirect:/admin/boletas";
    }

    @GetMapping("/{id}")
    public String detalle(@PathVariable("id") int id, Model model) {
        Boleta boleta = obtenerBoleta(id, model);
        if (boleta == null) {
            return redirigirABoletas();
        }
        model.addAttribute("detalles", detalleBoletaService.listarPorBoleta(id));
        model.addAttribute("productos", productoService.listarTodos());
        model.addAttribute("detalle", new DetalleBoleta());
        return "adminboleta-detalle";
    }

    @GetMapping("/{id}/detalle/editar/{detalleId}")
    public String editarDetalle(@PathVariable("id") int id,
                                @PathVariable("detalleId") int detalleId,
                                Model model) {
        Boleta boleta = obtenerBoleta(id, model);
        if (boleta == null) {
            return redirigirABoletas();
        }
        model.addAttribute("detalles", detalleBoletaService.listarPorBoleta(id));
        model.addAttribute("productos", productoService.listarTodos());
        DetalleBoleta detalle = detalleBoletaService.obtenerPorId(detalleId).orElse(new DetalleBoleta());
        model.addAttribute("detalle", detalle);
        return "adminboleta-detalle";
    }

    @PostMapping("/{id}/detalle/guardar")
    public String guardarDetalle(@PathVariable("id") int idBoleta, @ModelAttribute DetalleBoleta detalle) {
        detalle.setId_boleta(idBoleta);
        if (detalle.getId_detalle_boleta() == 0) {
            detalleBoletaService.guardar(detalle);
        } else {
            detalleBoletaService.actualizar(detalle);
        }
        // Recalcular total de la boleta luego de guardar/actualizar detalle
        boletaService.recalcTotal(idBoleta);
        return "redirect:/admin/boletas/" + idBoleta;
    }

    @GetMapping("/detalle/eliminar/{id}")
    public String eliminarDetalle(@PathVariable("id") int idDetalle) {
        DetalleBoleta detalle = detalleBoletaService.obtenerPorId(idDetalle).orElse(null);
        if (detalle == null) {
            return redirigirABoletas();
        }
        int idBoleta = detalle.getId_boleta();
        detalleBoletaService.eliminar(idDetalle);
        // Recalcular total de la boleta luego de eliminar detalle
        boletaService.recalcTotal(idBoleta);
        return "redirect:/admin/boletas/" + idBoleta;
    }

    private Boleta obtenerBoleta(int id, Model model) {
        Boleta boleta = boletaService.obtenerPorId(id).orElse(null);
        if (boleta != null) {
            model.addAttribute("boleta", boleta);
            model.addAttribute("usuarios", usuarioAdminService.listarTodos());
        }
        return boleta;
    }

    private String redirigirABoletas() {
        return "redirect:/admin/boletas";
    }

    private void cargarListasBoleta(int id, Model model) {
        model.addAttribute("detalles", detalleBoletaService.listarPorBoleta(id));
        model.addAttribute("productos", productoService.listarTodos());
    }
}
