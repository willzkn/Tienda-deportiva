# Flujo Completo del Backend - Tienda Deportiva

## 📋 Tabla de Contenidos
- [1. Arquitectura General](#1-arquitectura-general)
- [2. Flujo de Configuración](#2-flujo-de-configuración)
- [3. Flujo de Controllers](#3-flujo-de-controllers)
- [4. Flujo de Models](#4-flujo-de-models)
- [5. Flujo de Repositories](#5-flujo-de-repositories)
- [6. Flujo de Services](#6-flujo-de-services)
- [7. Flujo Completo de una Operación](#7-flujo-completo-de-una-operación)

---

## 1. Arquitectura General

### 🏗️ Estructura en Capas
```
┌─────────────────────────────────────┐
│           Controllers               │ ← Manejo de HTTP y vistas
├─────────────────────────────────────┤
│            Services                 │ ← Lógica de negocio
├─────────────────────────────────────┤
│          Repositories               │ ← Acceso a datos (DAO)
├─────────────────────────────────────┤
│             Models                  │ ← Entidades de datos
├─────────────────────────────────────┤
│           Database                  │ ← H2 Database
└─────────────────────────────────────┘
```

### 🔄 Patrón MVC (Model-View-Controller)
- **Model**: Entidades (`Boleta`, `Producto`, `Categoria`, etc.)
- **View**: JSPs (`adminboletas.jsp`, `productos.jsp`, etc.)
- **Controller: Spring MVC Controllers

---

## 2. Flujo de Configuración

### 🚀 Inicio de la Aplicación

#### 2.1 TiendaDeportivaApplication.java
```java
@SpringBootApplication
public class TiendaDeportivaApplication {
    public static void main(String[] args) {
        SpringApplication.run(TiendaDeportivaApplication.class, args);
    }
}
```

**Flujo de inicio:**
1. **Spring Boot escanea** el paquete base y subpaquetes
2. **Detecta anotaciones**: `@Controller`, `@Service`, `@Repository`
3. **Configura DataSource** basado en `application.properties`
4. **Inicializa JdbcTemplate** para acceso a datos
5. **Carga contextos** MVC y de persistencia
6. **Inicia servidor Tomcat** embebido

#### 2.2 application.properties
```properties
# Configuración de base de datos H2
spring.datasource.url=jdbc:h2:file:./data/tienda
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

# Configuración JPA/Hibernate
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=update

# Inicialización de datos
spring.sql.init.mode=always
spring.sql.init.schema-locations=classpath:schema.sql
spring.sql.init.data-locations=classpath:data.sql

# Configuración MVC
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

**Flujo de configuración:**
1. **Conexión a BD**: Crea archivo `./data/tienda.mv.db`
2. **Scripts SQL**: Ejecuta `schema.sql` y `data.sql` al iniciar
3. **JSP Views**: Configura prefijo y sufijo para vistas
4. **MVC**: Habilita controladores y manejo de peticiones

---

## 3. Flujo de Controllers

### 🎯 Papel en la Arquitectura
Los Controllers son el **punto de entrada** de todas las peticiones HTTP y el **puente** entre el frontend y el backend.

### 📁 Estructura de Controllers
```
controllers/
├── AdminController.java          ← Panel administrativo
├── AdminBoletasController.java    ← Gestión de boletas
├── AdminCategoriasController.java ← Gestión de categorías
├── AdminClientesController.java  ← Gestión de usuarios
├── CarritoController.java        ← Carrito de compras
└── HomeController.java            ← Páginas públicas
```

### 🔄 Flujo de un Controller

#### 3.1 Anotaciones Principales
```java
@Controller                    // Marca como controlador Spring MVC
@RequestMapping("/admin")     // Mapeo base para todas las rutas
public class AdminController {
    
    @GetMapping("/panel")     // GET /admin/panel
    public String verPanel() {
        return "adminpanel";   // Retorna vista JSP
    }
    
    @PostMapping("/guardar")   // POST /admin/guardar
    public String guardar(@ModelAttribute Modelo modelo) {
        // Procesa datos del formulario
        return "redirect:/admin/lista";  // Redirección
    }
}
```

#### 3.2 Flujo de Ejecución
```
Petición HTTP → Controller → Service → Repository → BD
     ↑              ↓
   Vista ← Model ← Service ← Repository ← BD
```

**Paso a paso:**
1. **Petición entra** a través de URL mapeada
2. **Spring MVC** invoca método del controller correspondiente
3. **Controller** valida parámetros y delega a Services
4. **Service** ejecuta lógica de negocio
5. **Repository** realiza operaciones en BD
6. **Controller** recibe resultados y prepara Model
7. **Retorna vista** con datos para renderizar

#### 3.3 Ejemplo Completo: AdminBoletasController
```java
@Controller
@RequestMapping("/admin/boletas")
public class AdminBoletasController {
    
    // Inyección de dependencias
    private final BoletaService boletaService;
    private final DetalleBoletaService detalleBoletaService;
    
    public AdminBoletasController(BoletaService boletaService,
                                  DetalleBoletaService detalleBoletaService) {
        this.boletaService = boletaService;
        this.detalleBoletaService = detalleBoletaService;
    }
    
    @GetMapping
    public String listar(Model model) {
        // 1. Obtiene datos desde la capa de servicio
        model.addAttribute("boletas", boletaService.listarTodas());
        // 2. Prepara modelo para la vista
        // 3. Retorna nombre de la vista JSP
        return "adminboletas";
    }
    
    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Boleta boleta) {
        // 1. Valida datos recibidos
        // 2. Delega a servicio para guardar
        if (boleta.getId_boleta() == 0) {
            boletaService.guardar(boleta);      // Nueva boleta
        } else {
            boletaService.actualizar(boleta);   // Actualizar existente
        }
        // 3. Redirige para evitar duplicados POST
        return "redirect:/admin/boletas";
    }
}
```

---

## 4. Flujo de Models

### 🏗️ Papel en la Arquitectura
Los Models son las **entidades de datos** que representan la estructura de la información en el sistema.

### 📁 Estructura de Models
```
models/
├── Boleta.java           ← Venta/Transacción principal
├── DetalleBoleta.java    ← Líneas de venta
├── Producto.java         ← Productos del catálogo
├── Categoria.java        ← Categorías de productos
├── Usuario.java          ← Usuarios del sistema
└── Pedido.java           ← Pedidos de clientes
```

### 🔄 Flujo de un Model

#### 4.1 Estructura Básica
```java
public class Producto {
    // Atributos privados
    private Integer idProducto;
    private String nombreProducto;
    private Double precio;
    private Integer stock;
    private String descripcion;
    private String imagen;
    private Integer idCategoria;
    
    // Campo adicional para vistas (JOIN)
    private String nombreCategoria;
    
    // Constructor vacío (requerido por Spring)
    public Producto() {}
    
    // Constructor con parámetros
    public Producto(String nombre, Double precio, Integer stock) {
        this.nombreProducto = nombre;
        this.precio = precio;
        this.stock = stock;
    }
    
    // Getters y Setters...
    public Integer getIdProducto() { return idProducto; }
    public void setIdProducto(Integer idProducto) { this.idProducto = idProducto; }
    
    // Métodos de utilidad
    public boolean tieneStock() {
        return stock != null && stock > 0;
    }
    
    public String getImagenUrl() {
        return imagen != null ? "/images/" + imagen : "/images/default.png";
    }
}
```

#### 4.2 Flujo de Datos
```
BD → Repository → Service → Controller → Model → Vista
↑                                      ↓
BD ← Repository ← Service ← Controller ← Formulario
```

**Paso a paso:**
1. **BD almacena** datos en tablas relacionales
2. **Repository mapea** ResultSet a objetos Model
3. **Service procesa** objetos Model con lógica de negocio
4. **Controller prepara** Model para la vista
5. **Vista accede** a propiedades del Model via EL `${producto.nombre}`

#### 4.3 Model con Relaciones: Boleta y DetalleBoleta
```java
// Entidad principal
public class Boleta {
    private int id_boleta;
    private int id_usuario;
    private LocalDateTime fecha_emision;
    private double total;
    
    // Campo de display (JOIN)
    private String usuario_correo;
    
    // Métodos de formato
    public String getFechaFormateada() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return fecha_emision != null ? fecha_emision.format(formatter) : "";
    }
}

// Entidad relacionada
public class DetalleBoleta {
    private int id_detalle_boleta;
    private int id_boleta;          // FK a Boleta
    private int id_producto;        // FK a Producto
    private int cantidad;
    private double precio_unitario;
    
    // Campo de display (JOIN)
    private String producto_nombre;
    
    // Cálculo de subtotal
    public double getSubtotal() {
        return cantidad * precio_unitario;
    }
}
```

---

## 5. Flujo de Repositories

### 🗄️ Papel en la Arquitectura
Los Repositories son la **capa de acceso a datos** que abstraen las operaciones SQL y manejan la persistencia.

### 📁 Estructura de Repositories
```
repositories/
├── BoletaDAO.java           ← Acceso a datos de boletas
├── DetalleBoletaDAO.java    ← Acceso a datos de detalles
├── ProductoRepository.java  ← Acceso a datos de productos
├── CategoriaRepository.java ← Acceso a datos de categorías
└── UsuarioRepository.java   ← Acceso a datos de usuarios
```

### 🔄 Flujo de un Repository

#### 5.1 Estructura Básica con JdbcTemplate
```java
@Repository
public class ProductoRepository {
    
    private final JdbcTemplate jdbcTemplate;
    
    // Inyección de JdbcTemplate
    public ProductoRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    // Operación CRUD - Leer todos
    public List<Producto> findAll() {
        String sql = """
            SELECT p.*, c.nombre_categoria 
            FROM Productos p 
            LEFT JOIN Categorias c ON p.id_categoria = c.id_categoria 
            ORDER BY p.nombre_producto
            """;
        return jdbcTemplate.query(sql, new ProductoRowMapper());
    }
    
    // Operación CRUD - Leer por ID
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
    
    // Operación CRUD - Guardar/Actualizar
    public Producto save(Producto producto) {
        if (producto.getIdProducto() == null) {
            // INSERTAR nuevo producto
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
            // ACTUALIZAR producto existente
            String sql = """
                UPDATE Productos 
                SET nombre_producto = ?, precio = ?, stock = ?, descripcion = ?, imagen = ?, id_categoria = ?
                WHERE id_producto = ?
                """;
            jdbcTemplate.update(sql, producto.getNombreProducto(), producto.getPrecio(), 
                              producto.getStock(), producto.getDescripcion(), 
                              producto.getImagen(), producto.getIdCategoria(), 
                              producto.getIdProducto());
        }
        return producto;
    }
    
    // Operación CRUD - Eliminar
    public void deleteById(Integer id) {
        String sql = "DELETE FROM Productos WHERE id_producto = ?";
        jdbcTemplate.update(sql, id);
    }
    
    // RowMapper para mapear ResultSet a objeto
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
            producto.setNombreCategoria(rs.getString("nombre_categoria")); // Campo JOIN
            return producto;
        }
    }
}
```

#### 5.2 Flujo de Ejecución
```
Service → Repository → JdbcTemplate → BD → ResultSet → Model
      ↑                                      ↓
Service ← Repository ← JdbcTemplate ← BD ← SQL
```

**Paso a paso:**
1. **Service solicita** datos al Repository
2. **Repository construye** consulta SQL
3. **JdbcTemplate ejecuta** SQL en BD
4. **BD retorna** ResultSet
5. **RowMapper convierte** ResultSet a objeto Model
6. **Repository retorna** lista/objeto al Service

#### 5.3 Repository con Consultas Complejas
```java
@Repository
public class BoletaDAO {
    
    // Consulta con JOINs para obtener datos relacionados
    public List<Boleta> findAllWithUsuario() {
        String sql = """
            SELECT b.*, u.email as usuario_correo 
            FROM Boletas b 
            LEFT JOIN Usuarios u ON b.id_usuario = u.id_usuario 
            ORDER BY b.fecha_emision DESC
            """;
        return jdbcTemplate.query(sql, new BoletaRowMapper());
    }
    
    // Consulta con agregación para reportes
    public List<ReporteVentas> getVentasPorMes(String mes) {
        String sql = """
            SELECT 
                DATE(fecha_emision) as fecha,
                COUNT(*) as cantidad_boletas,
                SUM(total) as total_ventas
            FROM Boletas 
            WHERE DATE_FORMAT(fecha_emision, '%Y-%m') = ?
            GROUP BY DATE(fecha_emision)
            ORDER BY fecha
            """;
        return jdbcTemplate.query(sql, new ReporteVentasRowMapper(), mes);
    }
    
    // Operación por lotes para mejor rendimiento
    public void guardarDetallesLote(List<DetalleBoleta> detalles) {
        String sql = """
            INSERT INTO DetalleBoletas (id_boleta, id_producto, cantidad, precio_unitario) 
            VALUES (?, ?, ?, ?)
            """;
        
        jdbcTemplate.batchUpdate(sql, detalles, detalles.size(),
            (ps, detalle) -> {
                ps.setInt(1, detalle.getId_boleta());
                ps.setInt(2, detalle.getId_producto());
                ps.setInt(3, detalle.getCantidad());
                ps.setDouble(4, detalle.getPrecio_unitario());
            });
    }
}
```

---

## 6. Flujo de Services

### ⚙️ Papel en la Arquitectura
Los Services contienen la **lógica de negocio** y actúan como intermediarios entre Controllers y Repositories.

### 📁 Estructura de Services
```
services/
├── BoletaService.java           ← Lógica de boletas
├── DetalleBoletaService.java    ← Lógica de detalles
├── ProductoService.java         ← Lógica de productos
├── CategoriaService.java        ← Lógica de categorías
└── UsuarioAdminService.java     ← Lógica de usuarios
```

### 🔄 Flujo de un Service

#### 6.1 Estructura Básica
```java
@Service
public class ProductoService {
    
    private final ProductoRepository productoRepository;
    private final CategoriaRepository categoriaRepository;
    
    // Inyección de dependencias
    public ProductoService(ProductoRepository productoRepository,
                          CategoriaRepository categoriaRepository) {
        this.productoRepository = productoRepository;
        this.categoriaRepository = categoriaRepository;
    }
    
    // Operación básica CRUD
    public List<Producto> listarTodos() {
        return productoRepository.findAll();
    }
    
    public Optional<Producto> obtenerPorId(Integer id) {
        return productoRepository.findById(id);
    }
    
    // Lógica de negocio compleja
    @Transactional
    public Producto guardar(Producto producto) {
        // 1. Validaciones de negocio
        if (producto.getNombreProducto() == null || producto.getNombreProducto().trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre del producto es requerido");
        }
        
        if (producto.getPrecio() == null || producto.getPrecio() <= 0) {
            throw new IllegalArgumentException("El precio debe ser mayor a 0");
        }
        
        // 2. Verificar categoría existente
        if (!categoriaRepository.existsById(producto.getIdCategoria())) {
            throw new IllegalArgumentException("La categoría especificada no existe");
        }
        
        // 3. Lógica específica del negocio
        if (producto.getIdProducto() == null) {
            // Nuevo producto: establecer fecha de creación
            producto.setFechaCreacion(LocalDateTime.now());
        } else {
            // Producto existente: verificar cambios
            Producto existente = obtenerPorId(producto.getIdProducto())
                .orElseThrow(() -> new IllegalArgumentException("Producto no encontrado"));
            
            // Si cambia de categoría, actualizar contadores
            if (!existente.getIdCategoria().equals(producto.getIdCategoria())) {
                actualizarContadoresCategoria(existente.getIdCategoria(), -1);
                actualizarContadoresCategoria(producto.getIdCategoria(), +1);
            }
        }
        
        // 4. Delegar a repository
        return productoRepository.save(producto);
    }
    
    // Método con lógica compleja
    public List<Producto> buscarProductosFiltrados(String nombre, Integer categoriaId, Double precioMin, Double precioMax) {
        List<Producto> productos = listarTodos();
        
        // Aplicar filtros en memoria (podría optimizarse con SQL)
        return productos.stream()
            .filter(p -> nombre == null || p.getNombreProducto().toLowerCase().contains(nombre.toLowerCase()))
            .filter(p -> categoriaId == null || p.getIdCategoria().equals(categoriaId))
            .filter(p -> precioMin == null || p.getPrecio() >= precioMin)
            .filter(p -> precioMax == null || p.getPrecio() <= precioMax)
            .collect(Collectors.toList());
    }
    
    // Operación transaccional compleja
    @Transactional
    public void actualizarStock(Integer idProducto, Integer cantidad) {
        Producto producto = obtenerPorId(idProducto)
            .orElseThrow(() -> new IllegalArgumentException("Producto no encontrado"));
        
        Integer stockActual = producto.getStock();
        Integer nuevoStock = stockActual + cantidad;
        
        if (nuevoStock < 0) {
            throw new IllegalArgumentException("Stock insuficiente");
        }
        
        producto.setStock(nuevoStock);
        productoRepository.save(producto);
        
        // Registrar movimiento en log de inventario
        registrarMovimientoInventario(idProducto, cantidad, "AJUSTE_MANUAL");
    }
}
```

#### 6.2 Flujo de Ejecución
```
Controller → Service → Repository → BD
     ↑           ↓
Controller ← Service ← Repository ← BD
     ↓
   Vista
```

**Paso a paso:**
1. **Controller invoca** método del Service
2. **Service valida** parámetros y reglas de negocio
3. **Service ejecuta** lógica específica
4. **Service delega** operaciones CRUD a Repositories
5. **Service procesa** resultados y aplica transformaciones
6. **Service retorna** resultado al Controller

#### 6.3 Service con Múltiples Repositories
```java
@Service
public class BoletaService {
    
    private final BoletaDAO boletaDAO;
    private final DetalleBoletaDAO detalleBoletaDAO;
    private final ProductoService productoService;
    
    // Operación transaccional compleja
    @Transactional
    public Boleta crearBoletaConDetalles(Boleta boleta, List<DetalleBoleta> detalles) {
        try {
            // 1. Validar stock para todos los productos
            for (DetalleBoleta detalle : detalles) {
                Producto producto = productoService.obtenerPorId(detalle.getId_producto())
                    .orElseThrow(() -> new IllegalArgumentException("Producto no encontrado: " + detalle.getId_producto()));
                
                if (producto.getStock() < detalle.getCantidad()) {
                    throw new IllegalArgumentException("Stock insuficiente para producto: " + producto.getNombreProducto());
                }
            }
            
            // 2. Guardar boleta principal
            boleta.setFecha_emision(LocalDateTime.now());
            boleta.setTotal(calcularTotal(detalles));
            Boleta boletaGuardada = boletaDAO.save(boleta);
            
            // 3. Guardar detalles y actualizar stock
            for (DetalleBoleta detalle : detalles) {
                detalle.setId_boleta(boletaGuardada.getId_boleta());
                detalleBoletaDAO.save(detalle);
                
                // Actualizar stock de productos
                productoService.actualizarStock(detalle.getId_producto(), -detalle.getCantidad());
            }
            
            return boletaGuardada;
            
        } catch (Exception e) {
            throw new RuntimeException("Error al crear boleta: " + e.getMessage(), e);
        }
    }
    
    // Método de cálculo de negocio
    private double calcularTotal(List<DetalleBoleta> detalles) {
        return detalles.stream()
            .mapToDouble(d -> d.getCantidad() * d.getPrecio_unitario())
            .sum();
    }
    
    // Operación de reporte
    public ReporteVentas generarReporteVentas(LocalDate fechaInicio, LocalDate fechaFin) {
        List<Boleta> boletas = boletaDAO.findByFechaBetween(fechaInicio, fechaFin);
        
        double totalVentas = boletas.stream().mapToDouble(Boleta::getTotal).sum();
        int cantidadBoletas = boletas.size();
        
        // Calcular productos más vendidos
        Map<Integer, Integer> productosVendidos = new HashMap<>();
        for (Boleta boleta : boletas) {
            List<DetalleBoleta> detalles = detalleBoletaDAO.listarPorBoleta(boleta.getId_boleta());
            for (DetalleBoleta detalle : detalles) {
                productosVendidos.merge(detalle.getId_producto(), detalle.getCantidad(), Integer::sum);
            }
        }
        
        return new ReporteVentas(totalVentas, cantidadBoletas, productosVendidos);
    }
}
```

---

## 7. Flujo Completo de una Operación

### 🎯 Ejemplo: Creación de una Boleta

#### 7.1 Flujo Frontend → Backend
```
Usuario → Formulario → Controller → Service → Repository → BD
   ↑         ↓            ↓         ↓          ↓      ↓
Vista ← Model ← Controller ← Service ← Repository ← BD
```

#### 7.2 Paso a Paso Detallado

**Paso 1: Petición desde el Frontend**
```jsp
<!-- adminboleta-editar.jsp -->
<form action="/admin/boletas/guardar" method="POST">
    <input type="hidden" name="id_boleta" value="0">
    <select name="id_usuario">
        <option value="1">usuario@ejemplo.com</option>
    </select>
    <button type="submit">Guardar Boleta</button>
</form>
```

**Paso 2: Controller recibe la petición**
```java
@PostMapping("/guardar")
public String guardar(@ModelAttribute Boleta boleta) {
    // Spring automáticamente mapea los campos del formulario al objeto Boleta
    if (boleta.getId_boleta() == 0) {
        boletaService.guardar(boleta);      // Nueva boleta
    } else {
        boletaService.actualizar(boleta);   // Actualizar existente
    }
    return "redirect:/admin/boletas";
}
```

**Paso 3: Service procesa la lógica**
```java
@Service
public class BoletaService {
    
    @Transactional
    public Boleta guardar(Boleta boleta) {
        // Validaciones de negocio
        if (boleta.getId_usuario() <= 0) {
            throw new IllegalArgumentException("ID de usuario inválido");
        }
        
        // Establecer valores por defecto
        boleta.setFecha_emision(LocalDateTime.now());
        boleta.setTotal(0.0); // Se calculará al agregar detalles
        
        // Delegar a repository
        return boletaDAO.save(boleta);
    }
}
```

**Paso 4: Repository ejecuta SQL**
```java
@Repository
public class BoletaDAO {
    
    public Boleta save(Boleta boleta) {
        if (boleta.getId_boleta() == 0) {
            String sql = "INSERT INTO Boletas (id_usuario, fecha_emision, total) VALUES (?, ?, ?)";
            KeyHolder keyHolder = new GeneratedKeyHolder();
            
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id_boleta"});
                ps.setInt(1, boleta.getId_usuario());
                ps.setTimestamp(2, Timestamp.valueOf(boleta.getFecha_emision()));
                ps.setDouble(3, boleta.getTotal());
                return ps;
            }, keyHolder);
            
            boleta.setId_boleta(keyHolder.getKey().intValue());
        }
        return boleta;
    }
}
```

**Paso 5: Base de datos almacena los datos**
```sql
-- SQL ejecutado en H2 Database
INSERT INTO Boletas (id_usuario, fecha_emision, total) 
VALUES (1, '2024-01-15 10:30:00', 0.0);
```

**Paso 6: Respuesta al Frontend**
```java
// Controller redirige a la lista
return "redirect:/admin/boletas";
```

**Paso 7: Vista actualizada**
```jsp
<!-- adminboletas.jsp -->
<table>
    <tr>
        <th>ID</th>
        <th>Usuario</th>
        <th>Fecha</th>
        <th>Total</th>
    </tr>
    <c:forEach items="${boletas}" var="boleta">
        <tr>
            <td>${boleta.id_boleta}</td>
            <td>${boleta.usuario_correo}</td>
            <td>${boleta.fechaFormateada}</td>
            <td>${boleta.totalFormateado}</td>
        </tr>
    </c:forEach>
</table>
```

### 🔄 Flujo de Operación Compleja: Agregar Detalle a Boleta

#### 7.3 Operación con Múltiples Capas
```
Petición POST /admin/boletas/123/detalle/guardar
    ↓
Controller: AdminBoletasController.guardarDetalle()
    ↓
Service: BoletaService.agregarDetalle()
    ↓
Service: ProductoService.actualizarStock() (valida stock)
    ↓
Repository: DetalleBoletaDAO.save()
    ↓
Repository: ProductoRepository.updateStock()
    ↓
BD: INSERT DetalleBoleta + UPDATE Productos
    ↓
Service: BoletaService.recalcTotal()
    ↓
Repository: BoletaDAO.updateTotal()
    ↓
BD: UPDATE Boletas SET total = ?
    ↓
Controller: redirect:/admin/boletas/123
    ↓
Vista: adminboleta-detalle.jsp (actualizada)
```

### 📊 Resumen del Flujo Completo

| Capa | Responsabilidad | Tecnologías | Flujo de Datos |
|------|------------------|-------------|----------------|
| **Controllers** | Manejo HTTP, vistas, validación básica | Spring MVC, JSP, HttpSession | HTTP ↔ Model |
| **Services** | Lógica de negocio, transacciones, validaciones | Spring Services, @Transactional | Model ↔ Repository |
| **Repositories** | Acceso a datos, SQL, mapeo de objetos | JdbcTemplate, RowMapper | Model ↔ BD |
| **Models** | Entidades de datos, estructura de información | POJOs, getters/setters | BD ↔ Aplicación |
| **Database** | Persistencia, relaciones, consultas | H2 Database, SQL | Datos estructurados |

### 🎯 Puntos Clave del Flujo

1. **Separación de responsabilidades**: Cada capa tiene un propósito específico
2. **Inyección de dependencias**: Spring conecta las capas automáticamente
3. **Transacciones**: Service maneja operaciones atómicas
4. **Mapeo de objetos**: RowMapper convierte SQL a objetos Java
5. **Redirecciones POST-Redirect-GET**: Evita envíos duplicados
6. **Manejo de errores**: Validaciones en cada capa
7. **Optimizaciones**: Caching, batch operations, N+1 queries

Este flujo asegura una arquitectura limpia, mantenible y escalable para la aplicación de tienda deportiva.
