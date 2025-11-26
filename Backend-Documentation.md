# Documentación del Backend - VENTADEPOR

## Overview
Este documento explica en detalle todo el backend del repositorio VENTADEPOR, incluyendo estructura de paquetes, controllers, services, repositories y configuración.

---

## 1. Estructura General del Backend

### 1.1 Organización de Paquetes
```
src/main/java/com/example/demo/
├── TiendaDeportivaApplication.java    (Clase principal Spring Boot)
├── config/
│   └── DatabaseConfig.java           (Configuración personalizada de BD)
├── controllers/
│   ├── AdminController.java          (Panel administrador y reportes)
│   ├── AdminBoletasController.java   (Gestión completa de boletas y detalles)
│   ├── AdminCategoriasController.java (CRUD de categorías)
│   ├── AdminClientesController.java  (Gestión de clientes/usuarios)
│   ├── AdminProductosController.java  (CRUD de productos con imágenes)
│   ├── CartController.java            (Carrito de compras con sesión)
│   ├── ContactoController.java        (Formulario contacto y envío emails)
│   ├── HomeController.java            (Página principal y navegación)
│   ├── LoginController.java           (Autenticación de usuarios)
│   └── RegisterController.java        (Registro de nuevos usuarios)
├── models/
│   ├── Boleta.java                     (Entidad principal de ventas)
│   ├── DetalleBoleta.java              (Líneas de detalle de boleta)
│   ├── Categoria.java                 (Categorías de productos)
│   ├── DetallePedido.java             (Detalles de pedidos)
│   ├── Pedido.java                    (Pedidos de clientes)
│   ├── Producto.java                  (Productos con imágenes y stock)
│   └── Usuario.java                   (Usuarios del sistema)
├── repositories/
│   ├── BoletaDAO.java                 (Acceso a datos de boletas)
│   ├── DetalleBoletaDAO.java          (Acceso a detalles de boleta)
│   ├── CategoriaRepository.java       (Acceso a categorías)
│   ├── DetallePedidoRepository.java   (Acceso a detalles de pedido)
│   ├── PedidoRepository.java          (Acceso a pedidos)
│   ├── ProductoRepository.java        (Acceso a productos)
│   └── UsuarioRepository.java          (Acceso a usuarios)
├── services/
│   ├── AdminService.java              (Servicios administrativos)
│   ├── BoletaService.java              (Lógica de negocio de boletas)
│   ├── DetalleBoletaService.java       (Gestión de detalles)
│   ├── CartService.java               (Lógica del carrito de compras)
│   ├── CategoriaService.java          (Validaciones de categorías)
│   ├── EmailService.java              (Envío de correos)
│   ├── PedidoService.java             (Gestión de pedidos)
│   ├── ProductoService.java           (Validaciones de productos)
│   ├── ReporteService.java            (Generación de reportes)
│   ├── UsuarioAdminService.java        (Gestión de usuarios admin)
│   └── UsuarioService.java            (Gestión de usuarios regulares)
└── utils/
    ├── Carrito.java                   (Clase utilitaria para carrito)
    └── Email.java                     (Modelo de datos para emails)
```

**Principios de Organización:**
- **Separación de responsabilidades**: Cada paquete tiene un propósito específico
- **Arquitectura en capas**: Controllers → Services → Repositories → Models
- **Inyección de dependencias**: Spring maneja las dependencias automáticamente
- **Configuración externa**: `application.properties` para parámetros de entorno

---

## 2. Clase Principal y Configuración

### 2.1 TiendaDeportivaApplication.java
```java
@SpringBootApplication
public class TiendaDeportivaApplication {
    public static void main(String[] args) {
        SpringApplication.run(TiendaDeportivaApplication.class, args);
    }
}
```

**Función:**
- **Punto de entrada**: Método main que inicia la aplicación
- **Auto-configuración**: Spring Boot configura automáticamente componentes
- **Servidor embebido**: Inicia Tomcat en el puerto 8080 por defecto
- **Component scanning**: Busca automáticamente @Controller, @Service, @Repository, etc.

**Anotaciones Spring Boot:**
- `@SpringBootApplication` = `@Configuration` + `@EnableAutoConfiguration` + `@ComponentScan`
- **@Configuration**: Clase de configuración de beans
- **@EnableAutoConfiguration**: Configura automáticamente basado en dependencias
- **@ComponentScan**: Escanea componentes en el paquete actual y subpaquetes

**Flujo de inicio:**
1. Ejecuta método `main()`
2. Spring Boot crea contexto de aplicación
3. Escanea componentes en el paquete `com.example.demo`
4. Configura automáticamente beans (DataSource, JdbcTemplate, etc.)
5. Inicia servidor web embebido (Tomcat)
6. La aplicación está lista para recibir peticiones HTTP

---

## 3. Capa de Controllers (Presentación)

### 3.1 AdminController.java
**Propósito**: Panel principal de administración y generación de reportes

```java
@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @GetMapping("/panel")
    public String verPanel() {
        return "adminpanel";  // Retorna vista adminpanel.jsp
    }
    
    @GetMapping("/reportes")
    public String verReportes(Model model, 
                             @RequestParam(value = "mes", required = false) String mesParam) 
            throws JsonProcessingException {
        
        // 1. Cargar todas las boletas UNA SOLA VEZ (optimización)
        List<Boleta> todasLasBoletas = boletaService.listarTodas();
        
        // 2. Cargar productos y categorías en memoria UNA SOLA VEZ
        Map<Integer, Producto> prodById = new HashMap<>();
        for (Producto producto : productoService.listarTodos()) {
            prodById.put(producto.getId_producto(), producto);
        }
        
        Map<Integer, String> catNombreById = new HashMap<>();
        for (Categoria categoria : productoService.listarCategorias()) {
            catNombreById.put(categoria.getId_categoria(), categoria.getNombre_categoria());
        }

        // 3. Acumuladores (usar TreeMap para mantener orden cronológico)
        double ingresos = 0;
        Map<String, Double> ventasPorMes = new TreeMap<>();
        Map<String, Integer> pedidosPorMes = new TreeMap<>();
        Map<String, Integer> unidadesPorCategoria = new HashMap<>();
        Map<String, Integer> unidadesPorProducto = new HashMap<>();

        // 4. Procesar todas las boletas en UNA SOLA ITERACIÓN
        for (Boleta b : todasLasBoletas) {
            // Procesamiento de datos para reportes...
        }
        
        // 5. Convertir a JSON para JavaScript
        ObjectMapper mapper = new ObjectMapper();
        model.addAttribute("ventasPorMesJson", mapper.writeValueAsString(ventasPorMes));
        model.addAttribute("pedidosPorMesJson", mapper.writeValueAsString(pedidosPorMes));
        model.addAttribute("unidadesPorCategoriaJson", mapper.writeValueAsString(unidadesPorCategoria));
        
        return "adminreporte";
    }
}
```

**Funcionalidades principales:**
- **Dashboard administrativo**: Punto de entrada para funciones admin
- **Reportes avanzados**: Métricas de ventas, productos y categorías
- **Optimización de consultas**: Carga datos en memoria una sola vez
- **Serialización JSON**: Convierte datos Java a JSON para Chart.js
- **Filtros dinámicos**: Permite filtrar reportes por mes

**Estrategia de optimización:**
1. **Evita N+1 queries**: Carga datos masivamente en memoria
2. **Procesamiento en memoria**: Más rápido que múltiples consultas SQL
3. **TreeMap**: Mantiene orden cronológico automáticamente
4. **JSON eficiente**: Serializa solo datos necesarios para frontend

**Integración con frontend:**
- Los datos JSON se inyectan directamente en JavaScript
- Chart.js consume los JSON para generar gráficos interactivos
- Los filtros se manejan por parámetros URL (?mes=2024-01)

### 3.2 AdminCategoriasController.java
**Propósito**: CRUD completo de categorías con validación de negocio

```java
@Controller
@RequestMapping("/admin/categorias")
public class AdminCategoriasController {
    
    @Autowired
    private CategoriaService categoriaService;
    
    @GetMapping("")
    public String listar(Model model) {
        model.addAttribute("categorias", categoriaService.findAll());
        return "admincategorias";
    }
    
    @GetMapping("/nuevo")
    public String nuevo(Model model) {
        model.addAttribute("categoria", new Categoria());
        return "admincategoria-editar";
    }
    
    @PostMapping("/guardar")
    public String guardar(@Valid Categoria categoria, 
                         BindingResult result, 
                         RedirectAttributes attr) {
        if (result.hasErrors()) {
            return "admincategoria-editar";
        }
        categoriaService.save(categoria);
        attr.addFlashAttribute("success", "Categoría guardada exitosamente");
        return "redirect:/admin/categorias";
    }
    
    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Integer id, Model model) {
        Optional<Categoria> categoria = categoriaService.findById(id);
        if (categoria.isPresent()) {
            model.addAttribute("categoria", categoria.get());
            return "admincategoria-editar";
        }
        return "redirect:/admin/categorias";
    }
    
    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable Integer id, RedirectAttributes attr) {
        categoriaService.deleteById(id);
        attr.addFlashAttribute("success", "Categoría eliminada exitosamente");
        return "redirect:/admin/categorias";
    }
}
```

**Endpoints implementados:**
- `GET /admin/categorias` - Listar todas las categorías
- `GET /admin/categorias/nuevo` - Formulario para nueva categoría
- `POST /admin/categorias/guardar` - Guardar categoría (crear/editar)
- `GET /admin/categorias/editar/{id}` - Editar categoría específica
- `GET /admin/categorias/eliminar/{id}` - Eliminar categoría

**Características de implementación:**
- **Validación automática**: @Valid para validación de campos
- **Manejo de errores**: BindingResult detecta errores de validación
- **Mensajes flash**: RedirectAttributes para mensajes entre requests
- **Optional seguro**: Manejo de IDs que no existen
- **Redirección POST-Redirect-GET**: Evita envíos duplicados de formulario

**Flujo de validación:**
1. **@Valid**: Activa validaciones en la entidad (anotaciones)
2. **BindingResult**: Contiene errores si los hay
3. **Retorno a formulario**: Si hay errores, vuelve al formulario con datos
4. **Guardado en service**: Si no hay errores, delega a service layer
5. **Mensaje de éxito**: Redirige con mensaje flash para usuario

**Integración con frontend:**
- Las vistas JSP usan `${categorias}` para mostrar lista
- Formularios usan `<form:form>` con Spring Form Tags
- Mensajes se muestran con `<c:if test="${not empty success}">`

### 3.3 AdminProductosController.java
**Propósito**: Gestión completa de productos

```java
@Controller
@RequestMapping("/admin/productos")
public class AdminProductosController {
    
    @Autowired
    private ProductoService productoService;
    
    @Autowired
    private CategoriaService categoriaService;
    
    @GetMapping("")
    public String listar(Model model) {
        model.addAttribute("productos", productoService.findAll());
        return "adminproductos";
    }
    
    @GetMapping("/nuevo")
    public String nuevo(Model model) {
        model.addAttribute("producto", new Producto());
        model.addAttribute("categorias", categoriaService.findAll());
        return "adminproducto-editar";
    }
    
    @PostMapping("/guardar")
    public String guardar(@Valid Producto producto, 
                         BindingResult result, 
                         @RequestParam("file") MultipartFile file,
                         Model model,
                         RedirectAttributes attr) {
        if (result.hasErrors()) {
            model.addAttribute("categorias", categoriaService.findAll());
            return "adminproducto-editar";
        }
        
        // Manejo de imagen
        if (!file.isEmpty()) {
            try {
                byte[] bytes = file.getBytes();
                Path path = Paths.get("src/main/webapp/images/" + file.getOriginalFilename());
                Files.write(path, bytes);
                producto.setImagen(file.getOriginalFilename());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        productoService.save(producto);
        attr.addFlashAttribute("success", "Producto guardado exitosamente");
        return "redirect:/admin/productos";
    }
}
```

**Características especiales:**
- **Upload de imágenes**: Manejo de archivos MultipartFile
- **Validación**: @Valid para validación automática
- **Relaciones**: Carga de categorías para select

### 3.4 AdminReportesController.java
**Propósito**: Generación de reportes y métricas

```java
@Controller
@RequestMapping("/admin/reportes")
public class AdminReportesController {
    
    @Autowired
    private ReporteService reporteService;
    
    @GetMapping("")
    public String verReportes(@RequestParam(value = "mes", required = false) String mes,
                            Model model) {
        
        // Datos para reportes
        ReporteData data = reporteService.obtenerDatosReporte();
        
        // Métricas principales
        model.addAttribute("ingresosGenerados", data.getIngresosGenerados());
        model.addAttribute("pedidosMes", data.getPedidosMes(mes));
        model.addAttribute("mayorCategoriaVendida", data.getMayorCategoriaVendida());
        model.addAttribute("cantidadMayorCategoria", data.getCantidadMayorCategoria());
        model.addAttribute("mejorProductoMes", data.getMejorProductoMes(mes));
        model.addAttribute("cantidadMejorProductoMes", data.getCantidadMejorProductoMes(mes));
        model.addAttribute("mayorMesVentas", data.getMayorMesVentas());
        
        // Datos para gráficos (JSON)
        try {
            ObjectMapper mapper = new ObjectMapper();
            model.addAttribute("ventasPorMesJson", mapper.writeValueAsString(data.getVentasPorMes()));
            model.addAttribute("pedidosPorMesJson", mapper.writeValueAsString(data.getPedidosPorMes()));
            model.addAttribute("unidadesPorCategoriaJson", mapper.writeValueAsString(data.getUnidadesPorCategoria()));
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Datos para comparación
        model.addAttribute("mesesDisponibles", data.getMesesDisponibles());
        model.addAttribute("selectedMes", mes != null ? mes : data.getMesActual());
        model.addAttribute("ingresosMes", data.getIngresosMes(mes));
        model.addAttribute("promedioPedidosMensuales", data.getPromedioPedidosMensuales());
        
        return "adminreporte";
    }
}
```

**Funcionalidades:**
- **Métricas en tiempo real**: Cálculo de KPIs
- **Serialización JSON**: Para consumo de Chart.js
- **Filtros dinámicos**: Por mes y período
- **Comparación temporal**: Entre diferentes meses

### 3.5 CartController.java
**Propósito**: Gestión del carrito de compras

```java
@Controller
@RequestMapping("/carrito")
public class CartController {
    
    @Autowired
    private CartService cartService;
    
    @GetMapping("")
    public String verCarrito(HttpSession session, Model model) {
        Carrito carrito = cartService.getCarrito(session);
        model.addAttribute("carrito", carrito);
        model.addAttribute("total", carrito.getTotal());
        return "carrito";
    }
    
    @PostMapping("/agregar")
    public String agregarAlCarrito(@RequestParam Integer idProducto,
                                 @RequestParam Integer cantidad,
                                 HttpSession session,
                                 RedirectAttributes attr) {
        try {
            cartService.agregarProducto(session, idProducto, cantidad);
            attr.addFlashAttribute("success", "Producto agregado al carrito");
        } catch (Exception e) {
            attr.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/carrito";
    }
    
    @PostMapping("/actualizar")
    public String actualizarCarrito(@RequestParam Map<String, String> cantidades,
                                   HttpSession session,
                                   RedirectAttributes attr) {
        try {
            cartService.actualizarCarrito(session, cantidades);
            attr.addFlashAttribute("success", "Carrito actualizado");
        } catch (Exception e) {
            attr.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/carrito";
    }
    
    @PostMapping("/eliminar/{id}")
    public String eliminarDelCarrito(@PathVariable Integer id,
                                   HttpSession session,
                                   RedirectAttributes attr) {
        cartService.eliminarProducto(session, id);
        attr.addFlashAttribute("success", "Producto eliminado del carrito");
        return "redirect:/carrito";
    }
    
    @PostMapping("/vaciar")
    public String vaciarCarrito(HttpSession session, RedirectAttributes attr) {
        cartService.vaciarCarrito(session);
        attr.addFlashAttribute("success", "Carrito vaciado");
        return "redirect:/carrito";
    }
}
```

**Características:**
- **Gestión de sesión**: Carrito persistente en HttpSession
- **Operaciones CRUD**: Agregar, actualizar, eliminar productos
- **Validaciones**: Stock disponible, cantidades válidas
- **Feedback al usuario**: Mensajes flash

---

## 4. Capa de Models (Entidades)

### 4.1 Categoria.java
```java
public class Categoria {
    private Integer idCategoria;
    private String nombreCategoria;
    
    // Constructores
    public Categoria() {}
    
    public Categoria(String nombreCategoria) {
        this.nombreCategoria = nombreCategoria;
    }
    
    // Getters y Setters
    public Integer getIdCategoria() { return idCategoria; }
    public void setIdCategoria(Integer idCategoria) { this.idCategoria = idCategoria; }
    
    public String getNombreCategoria() { return nombreCategoria; }
    public void setNombreCategoria(String nombreCategoria) { this.nombreCategoria = nombreCategoria; }
}
```

**Características:**
- **POJO simple**: Sin anotaciones JPA (usa JDBC directo)
- **Validación**: @Valid en controllers para validación automática

### 4.2 Producto.java
```java
public class Producto {
    private Integer idProducto;
    private String nombreProducto;
    private Double precio;
    private Integer stock;
    private String descripcion;
    private String imagen;
    private Integer idCategoria;
    private String nombreCategoria; // Para mostrar en vistas
    
    // Constructores
    public Producto() {}
    
    public Producto(String nombreProducto, Double precio, Integer stock, 
                   String descripcion, String imagen, Integer idCategoria) {
        this.nombreProducto = nombreProducto;
        this.precio = precio;
        this.stock = stock;
        this.descripcion = descripcion;
        this.imagen = imagen;
        this.idCategoria = idCategoria;
    }
    
    // Getters y Setters...
    
    // Métodos de utilidad
    public boolean tieneStock() {
        return stock != null && stock > 0;
    }
    
    public String getImagenUrl() {
        return imagen != null ? "/images/" + imagen : "/images/default-product.png";
    }
}
```

**Características especiales:**
- **Campo adicional**: `nombreCategoria` para facilitar vistas
- **Métodos de utilidad**: Validaciones y formato
- **Manejo de imágenes**: URL dinámica para imágenes

### 4.3 Pedido.java
```java
public class Pedido {
    private Integer idPedido;
    private Integer idUsuario;
    private Date fechaPedido;
    private Double total;
    private String estado; // PENDIENTE, CONFIRMADO, ENVIADO, ENTREGADO, CANCELADO
    private String nombreUsuario; // Campo adicional para vistas
    
    // Estados posibles
    public static final String ESTADO_PENDIENTE = "PENDIENTE";
    public static final String ESTADO_CONFIRMADO = "CONFIRMADO";
    public static final String ESTADO_ENVIADO = "ENVIADO";
    public static final String ESTADO_ENTREGADO = "ENTREGADO";
    public static final String ESTADO_CANCELADO = "CANCELADO";
    
    // Constructores y getters/setters...
    
    // Métodos de negocio
    public boolean estaPendiente() {
        return ESTADO_PENDIENTE.equals(estado);
    }
    
    public boolean estaFinalizado() {
        return ESTADO_ENTREGADO.equals(estado) || ESTADO_CANCELADO.equals(estado);
    }
    
    public String getEstadoFormateado() {
        return estado != null ? estado.substring(0, 1).toUpperCase() + estado.substring(1).toLowerCase() : "";
    }
}
```

### 4.4 DetallePedido.java
```java
public class DetallePedido {
    private Integer idDetalle;
    private Integer idPedido;
    private Integer idProducto;
    private Integer cantidad;
    private Double precioUnitario;
    private String nombreProducto; // Campo adicional
    
    // Constructores...
    
    // Métodos de cálculo
    public Double getSubtotal() {
        return (precioUnitario != null && cantidad != null) ? 
               precioUnitario * cantidad : 0.0;
    }
    
    // Método estático para crear desde carrito
    public static DetallePedido fromCarritoItem(Integer idPedido, 
                                               CarritoItem item) {
        DetallePedido detalle = new DetallePedido();
        detalle.setIdPedido(idPedido);
        detalle.setIdProducto(item.getProducto().getIdProducto());
        detalle.setCantidad(item.getCantidad());
        detalle.setPrecioUnitario(item.getProducto().getPrecio());
        detalle.setNombreProducto(item.getProducto().getNombreProducto());
        return detalle;
    }
}
```

---

## 5. Capa de Repositories (Acceso a Datos)

### 5.1 CategoriaRepository.java
```java
@Repository
public class CategoriaRepository {
    
    private final JdbcTemplate jdbcTemplate;
    
    public CategoriaRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    public List<Categoria> findAll() {
        String sql = "SELECT * FROM Categorias ORDER BY id_categoria";
        return jdbcTemplate.query(sql, new CategoriaRowMapper());
    }
    
    public Optional<Categoria> findById(Integer id) {
        String sql = "SELECT * FROM Categorias WHERE id_categoria = ?";
        List<Categoria> results = jdbcTemplate.query(sql, new CategoriaRowMapper(), id);
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }
    
    public Categoria save(Categoria categoria) {
        if (categoria.getIdCategoria() == null) {
            // Insertar nueva categoría
            String sql = "INSERT INTO Categorias (nombre_categoria) VALUES (?)";
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id_categoria"});
                ps.setString(1, categoria.getNombreCategoria());
                return ps;
            }, keyHolder);
            
            categoria.setIdCategoria(keyHolder.getKey().intValue());
        } else {
            // Actualizar categoría existente
            String sql = "UPDATE Categorias SET nombre_categoria = ? WHERE id_categoria = ?";
            jdbcTemplate.update(sql, categoria.getNombreCategoria(), categoria.getIdCategoria());
        }
        return categoria;
    }
    
    public void deleteById(Integer id) {
        String sql = "DELETE FROM Categorias WHERE id_categoria = ?";
        jdbcTemplate.update(sql, id);
    }
    
    public boolean existsById(Integer id) {
        String sql = "SELECT COUNT(*) FROM Categorias WHERE id_categoria = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, id);
        return count != null && count > 0;
    }
    
    // RowMapper interno
    private static final class CategoriaRowMapper implements RowMapper<Categoria> {
        @Override
        public Categoria mapRow(ResultSet rs, int rowNum) throws SQLException {
            Categoria categoria = new Categoria();
            categoria.setIdCategoria(rs.getInt("id_categoria"));
            categoria.setNombreCategoria(rs.getString("nombre_categoria"));
            return categoria;
        }
    }
}
```

**Características:**
- **JdbcTemplate**: Acceso directo a base de datos
- **RowMapper**: Mapeo automático de ResultSet a objetos
- **CRUD completo**: Create, Read, Update, Delete
- **Optional**: Manejo seguro de nulos

### 5.2 ProductoRepository.java
```java
@Repository
public class ProductoRepository {
    
    private final JdbcTemplate jdbcTemplate;
    
    public ProductoRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    public List<Producto> findAll() {
        String sql = """
            SELECT p.*, c.nombre_categoria 
            FROM Productos p 
            LEFT JOIN Categorias c ON p.id_categoria = c.id_categoria 
            ORDER BY p.nombre_producto
            """;
        return jdbcTemplate.query(sql, new ProductoRowMapper());
    }
    
    public List<Producto> findByCategoria(Integer idCategoria) {
        String sql = """
            SELECT p.*, c.nombre_categoria 
            FROM Productos p 
            JOIN Categorias c ON p.id_categoria = c.id_categoria 
            WHERE p.id_categoria = ? 
            ORDER BY p.nombre_producto
            """;
        return jdbcTemplate.query(sql, new ProductoRowMapper(), idCategoria);
    }
    
    public Optional<Producto> findById(Integer id) {
        String sql = """
            SELECT p.*, c.nombre_categoria 
            FROM Productos p 
            LEFT JOIN Categorias c ON p.id_categoria = c.id_categoria 
            WHERE p.id_producto = ?
            """;
        List<Producto> results = jdbcTemplate.query(sql, new ProductoRowMapper(), id);
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }
    
    public Producto save(Producto producto) {
        if (producto.getIdProducto() == null) {
            // Insertar nuevo producto
            String sql = """
                INSERT INTO Productos (nombre_producto, precio, stock, descripcion, imagen, id_categoria) 
                VALUES (?, ?, ?, ?, ?, ?)
                """;
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id_producto"});
                ps.setString(1, producto.getNombreProducto());
                ps.setDouble(2, producto.getPrecio());
                ps.setInt(3, producto.getStock());
                ps.setString(4, producto.getDescripcion());
                ps.setString(5, producto.getImagen());
                ps.setInt(6, producto.getIdCategoria());
                return ps;
            }, keyHolder);
            
            producto.setIdProducto(keyHolder.getKey().intValue());
        } else {
            // Actualizar producto existente
            String sql = """
                UPDATE Productos 
                SET nombre_producto = ?, precio = ?, stock = ?, descripcion = ?, imagen = ?, id_categoria = ? 
                WHERE id_producto = ?
                """;
            jdbcTemplate.update(sql, 
                producto.getNombreProducto(),
                producto.getPrecio(),
                producto.getStock(),
                producto.getDescripcion(),
                producto.getImagen(),
                producto.getIdCategoria(),
                producto.getIdProducto()
            );
        }
        return producto;
    }
    
    public void updateStock(Integer idProducto, Integer cantidad) {
        String sql = "UPDATE Productos SET stock = stock - ? WHERE id_producto = ? AND stock >= ?";
        int affected = jdbcTemplate.update(sql, cantidad, idProducto, cantidad);
        if (affected == 0) {
            throw new RuntimeException("Stock insuficiente o producto no encontrado");
        }
    }
    
    public void deleteById(Integer id) {
        String sql = "DELETE FROM Productos WHERE id_producto = ?";
        jdbcTemplate.update(sql, id);
    }
    
    // RowMapper con JOIN
    private static final class ProductoRowMapper implements RowMapper<Producto> {
        @Override
        public Producto mapRow(ResultSet rs, int rowNum) throws SQLException {
            Producto producto = new Producto();
            producto.setIdProducto(rs.getInt("id_producto"));
            producto.setNombreProducto(rs.getString("nombre_producto"));
            producto.setPrecio(rs.getDouble("precio"));
            producto.setStock(rs.getInt("stock"));
            producto.setDescripcion(rs.getString("descripcion"));
            producto.setImagen(rs.getString("imagen"));
            producto.setIdCategoria(rs.getInt("id_categoria"));
            
            // Campo adicional del JOIN
            producto.setNombreCategoria(rs.getString("nombre_categoria"));
            
            return producto;
        }
    }
}
```

**Características avanzadas:**
- **JOINs**: Consultas con relación a categorías
- **Stock management**: Método específico para actualización de stock
- **Validación en BD**: Verificación de stock disponible
- **RowMapper complejo**: Mapeo con campos adicionales

---

## 6. Capa de Services (Lógica de Negocio)

### 6.1 CategoriaService.java
```java
@Service
public class CategoriaService {
    
    private final CategoriaRepository categoriaRepository;
    
    public CategoriaService(CategoriaRepository categoriaRepository) {
        this.categoriaRepository = categoriaRepository;
    }
    
    @Transactional
    public Categoria save(Categoria categoria) {
        // Validaciones de negocio
        if (categoria.getNombreCategoria() == null || categoria.getNombreCategoria().trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre de la categoría es requerido");
        }
        
        // Verificar duplicados
        if (!categoriaRepository.findAll().stream()
            .filter(c -> !c.getIdCategoria().equals(categoria.getIdCategoria()))
            .filter(c -> c.getNombreCategoria().equalsIgnoreCase(categoria.getNombreCategoria()))
            .collect(Collectors.toList()).isEmpty()) {
            throw new IllegalArgumentException("Ya existe una categoría con ese nombre");
        }
        
        return categoriaRepository.save(categoria);
    }
    
    @Transactional(readOnly = true)
    public List<Categoria> findAll() {
        return categoriaRepository.findAll();
    }
    
    @Transactional(readOnly = true)
    public Optional<Categoria> findById(Integer id) {
        return categoriaRepository.findById(id);
    }
    
    @Transactional
    public void deleteById(Integer id) {
        // Verificar que no haya productos asociados
        // (Esta validación podría hacerse aquí o en el repository)
        categoriaRepository.deleteById(id);
    }
    
    @Transactional(readOnly = true)
    public boolean nombreDisponible(String nombre) {
        return categoriaRepository.findAll().stream()
            .noneMatch(c -> c.getNombreCategoria().equalsIgnoreCase(nombre));
    }
}
```

**Características:**
- **Transacciones**: @Transactional para gestión automática
- **Validaciones**: Reglas de negocio específicas
- **Excepciones**: Mensajes claros para el usuario
- **Read-only**: Optimización para consultas

### 6.2 ProductoService.java
```java
@Service
public class ProductoService {
    
    private final ProductoRepository productoRepository;
    private final CategoriaRepository categoriaRepository;
    
    public ProductoService(ProductoRepository productoRepository, 
                          CategoriaRepository categoriaRepository) {
        this.productoRepository = productoRepository;
        this.categoriaRepository = categoriaRepository;
    }
    
    @Transactional
    public Producto save(Producto producto) {
        // Validaciones de negocio
        validarProducto(producto);
        
        // Verificar que la categoría exista
        if (!categoriaRepository.existsById(producto.getIdCategoria())) {
            throw new IllegalArgumentException("La categoría especificada no existe");
        }
        
        // Si es nuevo producto, asignar imagen por defecto si no se proporcionó
        if (producto.getIdProducto() == null && 
            (producto.getImagen() == null || producto.getImagen().trim().isEmpty())) {
            producto.setImagen("default-product.png");
        }
        
        return productoRepository.save(producto);
    }
    
    private void validarProducto(Producto producto) {
        if (producto.getNombreProducto() == null || producto.getNombreProducto().trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre del producto es requerido");
        }
        
        if (producto.getPrecio() == null || producto.getPrecio() <= 0) {
            throw new IllegalArgumentException("El precio debe ser mayor a cero");
        }
        
        if (producto.getStock() == null || producto.getStock() < 0) {
            throw new IllegalArgumentException("El stock no puede ser negativo");
        }
        
        if (producto.getIdCategoria() == null) {
            throw new IllegalArgumentException("Debe seleccionar una categoría");
        }
    }
    
    @Transactional(readOnly = true)
    public List<Producto> findAll() {
        return productoRepository.findAll();
    }
    
    @Transactional(readOnly = true)
    public List<Producto> findByCategoria(Integer idCategoria) {
        return productoRepository.findByCategoria(idCategoria);
    }
    
    @Transactional(readOnly = true)
    public Optional<Producto> findById(Integer id) {
        return productoRepository.findById(id);
    }
    
    @Transactional
    public void deleteById(Integer id) {
        productoRepository.deleteById(id);
    }
    
    @Transactional(readOnly = true)
    public List<Producto> findConStock() {
        return findAll().stream()
            .filter(Producto::tieneStock)
            .collect(Collectors.toList());
    }
    
    @Transactional
    public void actualizarStock(Integer idProducto, Integer cantidad) {
        productoRepository.updateStock(idProducto, cantidad);
    }
}
```

### 6.3 ReporteService.java
```java
@Service
public class ReporteService {
    
    private final PedidoRepository pedidoRepository;
    private final DetallePedidoRepository detallePedidoRepository;
    private final ProductoRepository productoRepository;
    private final CategoriaRepository categoriaRepository;
    
    public ReporteService(PedidoRepository pedidoRepository,
                          DetallePedidoRepository detallePedidoRepository,
                          ProductoRepository productoRepository,
                          CategoriaRepository categoriaRepository) {
        this.pedidoRepository = pedidoRepository;
        this.detallePedidoRepository = detallePedidoRepository;
        this.productoRepository = productoRepository;
        this.categoriaRepository = categoriaRepository;
    }
    
    @Transactional(readOnly = true)
    public ReporteData obtenerDatosReporte() {
        ReporteData data = new ReporteData();
        
        // 1. Ingresos totales
        data.setIngresosGenerados(pedidoRepository.getTotalIngresos());
        
        // 2. Ventas por mes
        data.setVentasPorMes(pedidoRepository.getVentasPorMes());
        
        // 3. Pedidos por mes
        data.setPedidosPorMes(pedidoRepository.getPedidosPorMes());
        
        // 4. Unidades por categoría
        data.setUnidadesPorCategoria(detallePedidoRepository.getUnidadesPorCategoria());
        
        // 5. Mejor mes de ventas
        data.setMayorMesVentas(obtenerMayorMesVentas(data.getVentasPorMes()));
        
        // 6. Categoría más vendida
        data.setMayorCategoriaVendida(obtenerMayorCategoriaVendida(data.getUnidadesPorCategoria()));
        
        return data;
    }
    
    private String obtenerMayorMesVentas(Map<String, Double> ventasPorMes) {
        return ventasPorMes.entrySet().stream()
            .max(Map.Entry.comparingByValue())
            .map(Map.Entry::getKey)
            .orElse("N/A");
    }
    
    private String obtenerMayorCategoriaVendida(Map<String, Integer> unidadesPorCategoria) {
        return unidadesPorCategoria.entrySet().stream()
            .max(Map.Entry.comparingByValue())
            .map(Map.Entry::getKey)
            .orElse("N/A");
    }
}
```

---

## 7. Clases de Utilidad

### 7.1 Carrito.java
```java
public class Carrito implements Serializable {
    private List<CarritoItem> items = new ArrayList<>();
    
    public void agregarProducto(Producto producto, Integer cantidad) {
        // Buscar si el producto ya está en el carrito
        Optional<CarritoItem> existingItem = items.stream()
            .filter(item -> item.getProducto().getIdProducto().equals(producto.getIdProducto()))
            .findFirst();
        
        if (existingItem.isPresent()) {
            // Actualizar cantidad
            CarritoItem item = existingItem.get();
            int nuevaCantidad = item.getCantidad() + cantidad;
            
            // Validar stock
            if (nuevaCantidad > producto.getStock()) {
                throw new RuntimeException("Stock insuficiente. Disponible: " + producto.getStock());
            }
            
            item.setCantidad(nuevaCantidad);
        } else {
            // Validar stock
            if (cantidad > producto.getStock()) {
                throw new RuntimeException("Stock insuficiente. Disponible: " + producto.getStock());
            }
            
            // Agregar nuevo item
            items.add(new CarritoItem(producto, cantidad));
        }
    }
    
    public void eliminarProducto(Integer idProducto) {
        items.removeIf(item -> item.getProducto().getIdProducto().equals(idProducto));
    }
    
    public void actualizarCantidad(Integer idProducto, Integer nuevaCantidad) {
        Optional<CarritoItem> item = items.stream()
            .filter(i -> i.getProducto().getIdProducto().equals(idProducto))
            .findFirst();
        
        if (item.isPresent()) {
            if (nuevaCantidad <= 0) {
                eliminarProducto(idProducto);
            } else {
                // Validar stock
                if (nuevaCantidad > item.get().getProducto().getStock()) {
                    throw new RuntimeException("Stock insuficiente");
                }
                item.get().setCantidad(nuevaCantidad);
            }
        }
    }
    
    public void vaciar() {
        items.clear();
    }
    
    public Double getTotal() {
        return items.stream()
            .mapToDouble(item -> item.getProducto().getPrecio() * item.getCantidad())
            .sum();
    }
    
    public Integer getTotalItems() {
        return items.stream()
            .mapToInt(CarritoItem::getCantidad)
            .sum();
    }
    
    // Getters y Setters
    public List<CarritoItem> getItems() { return items; }
    public void setItems(List<CarritoItem> items) { this.items = items; }
}
```

### 7.2 CarritoItem.java
```java
public class CarritoItem implements Serializable {
    private Producto producto;
    private Integer cantidad;
    
    public CarritoItem(Producto producto, Integer cantidad) {
        this.producto = producto;
        this.cantidad = cantidad;
    }
    
    public Double getSubtotal() {
        return producto.getPrecio() * cantidad;
    }
    
    // Getters y Setters
    public Producto getProducto() { return producto; }
    public void setProducto(Producto producto) { this.producto = producto; }
    
    public Integer getCantidad() { return cantidad; }
    public void setCantidad(Integer cantidad) { this.cantidad = cantidad; }
}
```

---

## 8. Configuración de Base de Datos

### 8.1 DatabaseConfig.java
```java
@Configuration
public class DatabaseConfig {
    
    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
    
    @Bean
    public DataSource dataSource() {
        return DataSourceBuilder.create()
            .driverClassName("org.h2.Driver")
            .url("jdbc:h2:file:./ventadepor-db")
            .username("sa")
            .password("")
            .build();
    }
}
```

---

## 9. Manejo de Errores y Validaciones

### 9.1 Validaciones en Controllers
```java
@PostMapping("/guardar")
public String guardar(@Valid Categoria categoria, 
                     BindingResult result, 
                     RedirectAttributes attr) {
    
    if (result.hasErrors()) {
        // Errores de validación (anotaciones @NotNull, @Size, etc.)
        return "admincategoria-editar";
    }
    
    try {
        categoriaService.save(categoria);
        attr.addFlashAttribute("success", "Categoría guardada exitosamente");
    } catch (IllegalArgumentException e) {
        // Errores de negocio
        attr.addFlashAttribute("error", e.getMessage());
        return "redirect:/admin/categorias/nuevo";
    }
    
    return "redirect:/admin/categorias";
}
```

### 9.2 Manejo Global de Errores
```java
@ControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model) {
        model.addAttribute("error", "Ha ocurrido un error: " + e.getMessage());
        return "error";
    }
    
    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIllegalArgumentException(IllegalArgumentException e, 
                                               RedirectAttributes attr) {
        attr.addFlashAttribute("error", e.getMessage());
        return "redirect:/admin/categorias";
    }
}
```

---

## 10. Flujo Completo de una Operación

### 10.1 Ejemplo: Crear un Producto
```
1. Usuario envía formulario POST /admin/productos/guardar
   ↓
2. AdminProductosController.guardar() recibe request
   - @Valid Producto con datos del formulario
   - MultipartFile con imagen
   ↓
3. Validación automática (@Valid)
   - Si hay errores → volver al formulario
   ↓
4. ProductoService.save(producto)
   - Validaciones de negocio
   - Verificar categoría existente
   ↓
5. ProductoRepository.save(producto)
   - JdbcTemplate ejecuta INSERT/UPDATE
   - KeyHolder obtiene ID generado
   ↓
6. Manejo de imagen (si existe)
   - Guardar archivo en /src/main/webapp/images/
   - Actualizar nombre en objeto
   ↓
7. RedirectAttributes.addFlashAttribute()
   - Mensaje de éxito para siguiente request
   ↓
8. Redirect a /admin/productos
   - Lista actualizada de productos
```

---

## 11. Resumen de Componentes Backend

| Componente | Responsabilidad | Tecnologías |
|------------|-----------------|-------------|
| **Controllers** | Manejo HTTP, validación inicial | Spring MVC, @Controller |
| **Services** | Lógica de negocio, transacciones | @Service, @Transactional |
| **Repositories** | Acceso a datos, SQL | Spring JDBC, JdbcTemplate |
| **Models** | Entidades de datos | POJOs, validaciones |
| **Utils** | Componentes reutilizables | Carrito, Email, etc. |
| **Config** | Configuración de beans | @Configuration, @Bean |

Este backend proporciona una arquitectura robusta, escalable y mantenible siguiendo las mejores prácticas de Spring Boot y patrones de diseño enterprise.
