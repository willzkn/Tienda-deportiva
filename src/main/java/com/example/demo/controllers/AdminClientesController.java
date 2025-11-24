package com.example.demo.controllers;

import com.example.demo.models.UsuarioAdmin;
import com.example.demo.services.UsuarioAdminService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
/**
 * Administra usuarios/clientes desde la consola de administración.
 */
@Controller
@RequestMapping("/admin/clientes")
public class AdminClientesController {

    private final UsuarioAdminService usuarioAdminService;

    public AdminClientesController(UsuarioAdminService usuarioAdminService) {
        this.usuarioAdminService = usuarioAdminService;
    }

    /**
     * Lista todos los usuarios administradores registrados.
     */
    @GetMapping
    public String listarClientes(Model model) {
        model.addAttribute("clientes", usuarioAdminService.listarTodos());
        return "adminclientes";
    }

    @GetMapping("/nuevo")
    public String nuevo(Model model) {
        model.addAttribute("usuario", new UsuarioAdmin());
        return "admincliente-editar";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable("id") int id, Model model) {
        UsuarioAdmin usuario = usuarioAdminService.obtenerPorId(id).orElse(null);
        if (usuario == null) {
            return "redirect:/admin/clientes";
        }
        model.addAttribute("usuario", usuario);
        return "admincliente-editar";
    }

    /**
     * Crea o actualiza un usuario según si ya tiene identificador.
     */
    @PostMapping("/guardar")
    public String guardarCliente(@ModelAttribute UsuarioAdmin usuario) {
        if (usuario.getId_usuario() == 0) {
            usuarioAdminService.guardar(usuario);
        } else {
            usuarioAdminService.actualizar(usuario);
        }
        return "redirect:/admin/clientes";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminarCliente(@PathVariable("id") int id, Model model) {
        try {
            usuarioAdminService.eliminar(id);
        } catch (Exception e) {
            // Si hay error, mostrar mensaje
            model.addAttribute("error", "No se puede eliminar el usuario. Verifique que no tenga boletas asociadas.");
            model.addAttribute("clientes", usuarioAdminService.listarTodos());
            return "adminclientes";
        }
        return "redirect:/admin/clientes";
    }
}
