package com.example.demo.controllers;

import com.example.demo.models.Producto;
import com.example.demo.models.UsuarioAdmin;
import com.example.demo.services.ProductoService;
import com.example.demo.services.UsuarioAdminService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

/**
 * Controlador público que expone las páginas principales del sitio (home,
 * catálogo y secciones informativas).
 */
@Controller
public class HomeController {

    private final ProductoService productoService;
    private final UsuarioAdminService usuarioAdminService;

    public HomeController(ProductoService productoService, UsuarioAdminService usuarioAdminService) {
        this.productoService = productoService;
        this.usuarioAdminService = usuarioAdminService;
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
     * Lista productos aplicando filtros simples por categoría y ordenamiento en
     * memoria antes de enviarlos a la vista.
     */
    @GetMapping("/productos")
    public String verPaginaDeProductos(
            @RequestParam(required = false) Integer categoriaId,
            @RequestParam(required = false, defaultValue = "relevancia") String sortBy,
            Model model) {

        List<Producto> productos = productoService.listarActivos();

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
        model.addAttribute("categorias", productoService.findAllCategorias());

        // 4. Devolver los valores seleccionados para mantener el estado en los <select>
        model.addAttribute("selectedCategoriaId", categoriaId);
        model.addAttribute("selectedSortBy", sortBy);

        return "productos"; // Renderiza productos.jsp
    }

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

    @PostMapping("/registro")
    public String procesarRegistro(
            @RequestParam String correo,
            @RequestParam String clave,
            @RequestParam String confirmarClave,
            RedirectAttributes redirectAttributes) {

        try {
            // Validar que las contraseñas coincidan
            if (!clave.equals(confirmarClave)) {
                redirectAttributes.addFlashAttribute("error", "Las contraseñas no coinciden");
                return "redirect:/registro";
            }

            // Validar longitud de contraseña
            if (clave.length() < 6) {
                redirectAttributes.addFlashAttribute("error", "La contraseña debe tener al menos 6 caracteres");
                return "redirect:/registro";
            }

            // Verificar si el correo ya existe
            Optional<UsuarioAdmin> usuarioExistente = usuarioAdminService.autenticar(correo, "cualquiercosa");
            if (usuarioExistente.isPresent() || usuarioAdminService.listarTodos().stream()
                    .anyMatch(u -> u.getCorreo().equals(correo))) {
                redirectAttributes.addFlashAttribute("error", "El correo ya está registrado");
                return "redirect:/registro";
            }

            // Crear nuevo usuario
            UsuarioAdmin nuevoUsuario = new UsuarioAdmin();
            nuevoUsuario.setCorreo(correo);
            nuevoUsuario.setClave(clave);
            nuevoUsuario.setRol("Cliente"); // Rol por defecto
            nuevoUsuario.setActivo(true); // Activo por defecto

            // Guardar en la base de datos
            usuarioAdminService.guardar(nuevoUsuario);

            redirectAttributes.addFlashAttribute("success", "Cuenta creada exitosamente. Ahora puedes iniciar sesión.");
            return "redirect:/login";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error al crear la cuenta: " + e.getMessage());
            return "redirect:/registro";
        }
    }

    @GetMapping("/promociones")
    public String verPaginaDePromociones() {
        return "promociones";
    }

}

    

    