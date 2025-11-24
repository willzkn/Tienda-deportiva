package com.example.demo.controllers;

import com.example.demo.models.Producto;
import com.example.demo.services.ProductoService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Comparator;
import java.util.List;

/**
 * Controlador público que expone las páginas principales del sitio (home, catálogo y secciones informativas).
 */
@Controller
public class HomeController {

    private final ProductoService productoService;

    public HomeController(ProductoService productoService) {
        this.productoService = productoService;
    }

    @GetMapping("/")
    public String root() {
        return "redirect:/inicio";
    }

    @GetMapping("/inicio")
    public String verPaginaDeInicio() {
        return "inicio";
    }

    /**
     * Lista productos aplicando filtros simples por categoría y ordenamiento en memoria antes de enviarlos a la vista.
     */
    @GetMapping("/productos")
    public String verPaginaDeProductos(
            @RequestParam(required = false) Integer categoriaId,
            @RequestParam(required = false, defaultValue = "relevancia") String sortBy,
            Model model) {

        List<Producto> productos = productoService.listarTodos();

        // 1. Filtrar por Categoría si se ha seleccionado una
        if (categoriaId != null) {
            List<Producto> filtrados = new java.util.ArrayList<>();
            for (Producto producto : productos) {
                if (producto.getId_categoria() == categoriaId) {
                    filtrados.add(producto);
                }
            }
            productos = filtrados;
        }

        // 2. Ordenar la lista de productos
        switch (sortBy) {
            case "precio-asc":
                productos.sort(Comparator.comparing(Producto::getPrecio));
                break;
            case "precio-desc":
                productos.sort(Comparator.comparing(Producto::getPrecio).reversed());
                break;
            case "nombre":
                productos.sort(Comparator.comparing(Producto::getNombre, String.CASE_INSENSITIVE_ORDER));
                break;
        }
        
        // 3. Añadir los datos al modelo para que la vista los pueda usar
        model.addAttribute("productos", productos);
        model.addAttribute("categorias", productoService.listarCategorias());
        
        // 4. Devolver los valores seleccionados para mantener el estado en los <select>
        model.addAttribute("selectedCategoriaId", categoriaId);
        model.addAttribute("selectedSortBy", sortBy);

        return "productos"; // Renderiza productos.jsp
    }

    // ... (resto de tus mappings: /nosotros, /contacto, /login, etc.)
    @GetMapping("/nosotros")
    public String verPaginaDeNosotros() {
        return "nosotros";
    }

    @GetMapping("/contacto")
    public String verPaginaDeContacto() {
        return "contacto";
    }

    @GetMapping("/login")
    public String verPaginaDeLogin() {
        return "login";
    }
    
    @GetMapping("/registro")
    public String verPaginaDeRegistro() {
        return "registro";
    }
    
    @GetMapping("/promociones")
    public String verPaginaDePromociones() {
        return "promociones";
    }
}