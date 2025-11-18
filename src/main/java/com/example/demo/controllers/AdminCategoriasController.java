package com.example.demo.controllers;

import com.example.demo.models.Categoria;
import com.example.demo.services.CategoriaService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/admin/categorias")
public class AdminCategoriasController {

    private final CategoriaService categoriaService;

    public AdminCategoriasController(CategoriaService categoriaService) {
        this.categoriaService = categoriaService;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("categorias", categoriaService.listarTodas());
        return "admincategorias";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable("id") int id, Model model) {
        Optional<Categoria> cat = categoriaService.obtenerPorId(id);
        if (cat.isPresent()) {
            model.addAttribute("categoria", cat.get());
            return "admincategoria-editar";
        }
        return "redirect:/admin/categorias";
    }

    @GetMapping("/nuevo")
    public String nuevo(Model model) {
        model.addAttribute("categoria", new Categoria());
        return "admincategoria-editar";
    }

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
            categoriaService.eliminar(id);
        } catch (Exception e) {
            // Si hay error de integridad referencial, mostrar mensaje
            model.addAttribute("error", "No se puede eliminar la categoría porque tiene productos asociados");
            model.addAttribute("categorias", categoriaService.listarTodas());
            return "admincategorias";
        }
        return "redirect:/admin/categorias";
    }
}
