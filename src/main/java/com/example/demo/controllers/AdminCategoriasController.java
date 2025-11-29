package com.example.demo.controllers;

import com.example.demo.models.Categoria;
import com.example.demo.services.CategoriaService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * CRUD de categorías desde el módulo administrativo.
 */
@Controller
@RequestMapping("/admin/categorias")
public class AdminCategoriasController {

    private final CategoriaService categoriaService;

    public AdminCategoriasController(CategoriaService categoriaService) {
        this.categoriaService = categoriaService;
    }

    /**
     * Muestra todas las categorías registradas.
     */
    @GetMapping
    public String listar(Model model) {
        model.addAttribute("categorias", categoriaService.listarTodas());
        return "admincategorias";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable("id") int id, Model model) {
        Categoria categoria = categoriaService.obtenerPorId(id).orElse(null);
        if (categoria == null) {
            return "redirect:/admin/categorias";
        }
        model.addAttribute("categoria", categoria);
        return "admincategoria-editar";
    }

    @GetMapping("/nuevo")
    public String nuevo(Model model) {
        model.addAttribute("categoria", new Categoria());
        return "admincategoria-editar";
    }

    /**
     * Guarda o actualiza la categoría según posea id.
     */
    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Categoria categoria) {
        if (categoria.getId_categoria() == 0) {
            categoriaService.guardar(categoria);
        } else {
            categoriaService.actualizar(categoria);
        }
        return "redirect:/admin/categorias";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable("id") int id, Model model) {
        try {
            categoriaService.deleteById(id);
        } catch (Exception e) {
            // Si hay error de integridad referencial, mostrar mensaje
            model.addAttribute("error", "No se puede eliminar la categoría porque tiene productos asociados");
            model.addAttribute("categorias", categoriaService.listarTodas());
            return "admincategorias";
        }
        return "redirect:/admin/categorias";
    }

    @PostMapping("/cambiar-estado")
    public String cambiarEstado(@RequestParam("id") int id, @RequestParam("activo") boolean activo) {
        categoriaService.cambiarEstado(id, activo);
        return "redirect:/admin/categorias";
    }
}
