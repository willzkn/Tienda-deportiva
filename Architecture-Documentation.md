# Documentación de Arquitectura - VENTADEPOR

## Overview
Este documento describe las arquitecturas de software implementadas en el repositorio VENTADEPOR, explicando patrones de diseño, estructura de capas y decisiones arquitectónicas.

---

## 1. Arquitectura General del Sistema

### 1.1 Arquitectura MVC (Model-View-Controller)
**Tipo**: Arquitectura de 3 capas clásica

**Propósito**: Separación de responsabilidades en la aplicación web

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   View (JSP)    │ ←→ │ Controller      │ ←→ │ Model (Java)    │
│                 │    │                 │    │                 │
│ • HTML/CSS/JS   │    │ • @Controllers  │    │ • Entities      │
│ • JSTL Tags     │    │ • @Mappings     │    │ • DTOs          │
│ • Bootstrap     │    │ • Validation    │    │ • Services      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

**Implementación específica:**
- **View**: Archivos JSP en `/src/main/webapp/WEB-INF/views/`
- **Controller**: Clases con `@Controller` en `com.example.demo.controllers`
- **Model**: Entities y DTOs en `com.example.demo.models`

**Flujo de datos MVC:**
```
1. HTTP Request → DispatcherServlet
2. DispatcherServlet → Controller (mapeado por @RequestMapping)
3. Controller → Service Layer (lógica de negocio)
4. Service → Repository (acceso a datos)
5. Repository → Database
6. Database → Repository → Service → Controller
7. Controller → Model (datos) + View Name
8. ViewResolver → JSP View → HTML Response
```

### 1.2 Arquitectura de Capas (Layered Architecture)
**Tipo**: Arquitectura N-Tier

**Propósito**: Organización jerárquica de componentes

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   JSP Views │  │   CSS/JS    │  │   Static Resources  │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ↑
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Controllers │  │   DTOs      │  │   Validation        │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ↑
┌─────────────────────────────────────────────────────────────┐
│                     Business Layer                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Services   │  │  Business   │  │   Calculations      │  │
│  │             │  │   Logic     │  │   Transformations  │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ↑
┌─────────────────────────────────────────────────────────────┐
│                    Data Access Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │Repositories │  │ JdbcTemplate│  │   Database Schema   │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

**Ventajas de esta arquitectura:**
- **Separación de responsabilidades**: Cada capa tiene un propósito claro
- **Mantenibilidad**: Cambios en una capa no afectan a otras
- **Testabilidad**: Cada capa puede ser probada independientemente
- **Reutilización**: Componentes pueden ser reutilizados

---

## 2. Patrones de Diseño Implementados

### 2.1 Pattern: Data Access Object (DAO)
**Propósito**: Abstracción del acceso a datos

**Implementación:**
```java
@Repository
public class CategoriaRepository {
    private final JdbcTemplate jdbcTemplate;
    
    public List<Categoria> findAll() {
        String sql = "SELECT * FROM Categorias ORDER BY id_categoria";
        return jdbcTemplate.query(sql, new CategoriaRowMapper());
    }
}
```

**Beneficios:**
- Aislamiento de la lógica de base de datos
- Cambio de base de datos sin afectar el business logic
- Centralización de consultas SQL

### 2.2 Pattern: Service Layer
**Propósito**: Encapsulación de lógica de negocio

**Implementación:**
```java
@Service
public class CategoriaService {
    private final CategoriaRepository categoriaRepository;
    
    @Transactional
    public Categoria save(Categoria categoria) {
        // Validaciones y lógica de negocio
        return categoriaRepository.save(categoria);
    }
}
```

**Características:**
- Transacciones declarativas con `@Transactional`
- Coordinación entre múltiples repositories
- Reglas de negocio centralizadas

### 2.3 Pattern: Dependency Injection
**Propósito**: Inversión de control para componentes

**Implementación via Spring:**
```java
@Controller
public class AdminCategoriasController {
    private final CategoriaService categoriaService;
    
    // Inyección por constructor (recomendado)
    public AdminCategoriasController(CategoriaService categoriaService) {
        this.categoriaService = categoriaService;
    }
}
```

**Ventajas:**
- Componentes desacoplados
- Fácil testing (mocking)
- Configuración flexible

---

## 3. Arquitectura de Base de Datos

### 3.1 Arquitectura Relacional
**Tipo**: Base de datos relacional con esquema normalizado

**Diseño del esquema:**
```sql
-- Tablas principales
Categorias (id_categoria PK, nombre_categoria)
Productos (id_producto PK, nombre_producto, precio, stock, id_categoria FK)
Pedidos (id_pedido PK, fecha_pedido, total, estado, id_usuario FK)
DetallePedido (id_detalle PK, id_pedido FK, id_producto FK, cantidad, precio_unitario)
```

**Normalización aplicada:**
- **1NF**: Valores atómicos en cada celda
- **2NF**: Dependencia funcional completa de la clave primaria
- **3FN**: Eliminación de dependencias transitivas

### 3.2 Arquitectura de Persistencia
**Enfoque**: JDBC directo sin ORM

**Razones arquitectónicas:**
1. **Performance**: Control total sobre SQL
2. **Simplicidad**: Sin complejidad de mapeo ORM
3. **Transparencia**: Consultas visibles y optimizables
4. **Learning Curve**: Menor complejidad para el equipo

**Implementación:**
```java
@Repository
public class ProductoRepository {
    private final JdbcTemplate jdbcTemplate;
    
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
}
```

---

## 4. Arquitectura Frontend

### 4.1 Arquitectura de Vistas Server-Side
**Tipo**: JSP con renderizado en servidor

**Características:**
- **Server-side rendering**: HTML generado en el servidor
- **Template inheritance**: Includes para componentes comunes
- **Tag libraries**: JSTL para lógica de presentación

**Estructura de vistas:**
```
WEB-INF/views/
├── includes/
│   ├── appHead.jspf      (head común)
│   ├── header.jspf       (header público)
│   └── headerAdmin.jspf  (header administrador)
├── inicio.jsp             (página principal)
├── adminpanel.jsp         (panel admin)
├── adminproductos.jsp     (gestión productos)
├── adminreporte.jsp       (reportes con Chart.js)
└── carrito.jsp            (carrito de compras)
```

### 4.2 Arquitectura de Componentes UI
**Framework**: Bootstrap 5 + Font Awesome

**Patrón Component-based:**
```jsp
<!-- Componente Card reutilizable -->
<div class="card">
  <div class="card-header">
    <h5><i class="fa-solid fa-${icon}"></i> ${title}</h5>
  </div>
  <div class="card-body">
    ${content}
  </div>
</div>
```

**Ventajas:**
- **Consistencia visual**: Componentes estandarizados
- **Responsive design**: Adaptación automática
- **Maintainability**: Cambios centralizados

---

## 5. Arquitectura de Datos y Flujo

### 5.1 Arquitectura de Transferencia de Datos
**Pattern**: DTO (Data Transfer Object)

**Propósito**: Transferencia eficiente de datos entre capas

**Ejemplo de DTO:**
```java
public class ReporteData {
    private Map<String, Double> ventasPorMes;
    private Map<String, Integer> pedidosPorMes;
    private Map<String, Integer> unidadesPorCategoria;
    // Getters/Setters
}
```

**Beneficios:**
- **Performance**: Solo datos necesarios
- **Security**: Oculta detalles internos
- **Flexibility**: Formato optimizado para frontend

### 5.2 Arquitectura de Serialización
**Formato**: JSON para comunicación frontend-backend

**Implementación en Controller:**
```java
@GetMapping("/admin/reportes")
public String verReportes(Model model) {
    ReporteData data = reporteService.obtenerDatosReporte();
    
    // Serialización a JSON para JavaScript
    model.addAttribute("ventasPorMesJson", 
        new ObjectMapper().writeValueAsString(data.getVentasPorMes()));
    
    return "adminreporte";
}
```

---

## 6. Arquitectura de Seguridad

### 6.1 Arquitectura de Validación
**Niveles de validación:**

1. **Frontend Validation**: HTML5 + JavaScript
2. **Controller Validation**: Spring Validation
3. **Service Validation**: Reglas de negocio
4. **Database Validation**: Constraints SQL

**Ejemplo implementado:**
```java
@Controller
public class AdminCategoriasController {
    
    @PostMapping("/admin/categorias/guardar")
    public String guardar(@Valid Categoria categoria, 
                         BindingResult result, 
                         RedirectAttributes attr) {
        
        if (result.hasErrors()) {
            // Validación falló
            return "admincategoria-editar";
        }
        
        // Validación de negocio en Service
        if (!categoriaService.nombreDisponible(categoria.getNombreCategoria())) {
            attr.addFlashAttribute("error", "Nombre ya existe");
            return "redirect:/admin/categorias/nuevo";
        }
        
        categoriaService.save(categoria);
        return "redirect:/admin/categorias";
    }
}
```

### 6.2 Arquitectura de Prevención XSS
**Estrategia**: Escape automático en JSP

```jsp
<!-- Prevención XSS con JSTL -->
<c:out value="${producto.nombreProducto}" />

<!-- vs (inseguro) -->
${producto.nombreProducto}
```

---

## 7. Arquitectura de Configuración

### 7.1 Arquitectura de Configuración Externaizada
**Archivo**: `application.properties`

**Propósito**: Separación de configuración del código

```properties
# Database Configuration
spring.datasource.url=jdbc:h2:file:./ventadepor-db
spring.datasource.username=sa
spring.datasource.password=

# Server Configuration
server.port=8080
server.servlet.encoding.charset=UTF-8

# Logging Configuration
logging.level.org.springframework=DEBUG
```

**Ventajas:**
- **Environment-specific**: Diferentes configs por ambiente
- **Runtime changes**: Cambios sin recompilar
- **Security**: Credenciales fuera del código

### 7.2 Arquitectura de Componentes Spring
**Pattern**: Component Scanning + Auto-configuration

**Anotaciones principales:**
```java
@SpringBootApplication // → @SpringBootConfiguration + @EnableAutoConfiguration + @ComponentScan
@Controller          // → Componente MVC
@Service            // → Business logic
@Repository         // → Data access
@Component          // → Componente genérico
```

---

## 8. Arquitectura de Despliegue

### 8.1 Arquitectura Monolítica
**Tipo**: Single JAR deployment

**Estructura del artefacto:**
```
ventadepor.jar
├── BOOT-INF/
│   ├── classes/      (Tu código compilado)
│   ├── lib/          (Dependencias)
│   └── lib-provided/ (Tomcat embebido)
└── META-INF/
    └── MANIFEST.MF
```

**Ventajas:**
- **Simple deployment**: Un solo archivo
- **Embedded server**: Sin configuración externa
- **Self-contained**: Todas las dependencias incluidas

### 8.2 Arquitectura de Recursos Estáticos
**Organización**: Estructura de recursos webapp

```
src/main/webapp/
├── WEB-INF/
│   ├── views/        (JSPs)
│   └── web.xml       (Configuración web)
├── css/              (Archivos CSS)
├── js/               (Archivos JavaScript)
├── images/           (Imágenes)
└── fonts/            (Fuentes)
```

---

## 9. Arquitectura de Monitoreo y Logging

### 9.1 Arquitectura de Logging
**Framework**: SLF4J + Logback (Spring Boot default)

**Configuración:**
```properties
# Niveles de logging
logging.level.org.springframework=DEBUG
logging.level.org.apache.catalina=DEBUG
logging.level.com.example.demo=INFO
```

**Estrategia de logging:**
```java
@Service
public class CategoriaService {
    private static final Logger logger = LoggerFactory.getLogger(CategoriaService.class);
    
    public Categoria save(Categoria categoria) {
        logger.info("Guardando categoría: {}", categoria.getNombreCategoria());
        try {
            return categoriaRepository.save(categoria);
        } catch (Exception e) {
            logger.error("Error guardando categoría", e);
            throw e;
        }
    }
}
```

---

## 10. Arquitectura de Testing

### 10.1 Arquitectura de Test Layers
**Estrategia**: Testing por capas

**Unit Tests (Service Layer):**
```java
@ExtendWith(MockitoExtension.class)
class CategoriaServiceTest {
    @Mock
    private CategoriaRepository categoriaRepository;
    
    @InjectMocks
    private CategoriaService categoriaService;
    
    @Test
    void shouldSaveCategoria() {
        // Arrange
        Categoria categoria = new Categoria();
        categoria.setNombreCategoria("Nueva Categoría");
        
        // Act & Assert
        when(categoriaRepository.save(any())).thenReturn(categoria);
        
        Categoria result = categoriaService.save(categoria);
        
        assertThat(result.getNombreCategoria()).isEqualTo("Nueva Categoría");
    }
}
```

**Integration Tests (Controller Layer):**
```java
@SpringBootTest
@AutoConfigureTestDatabase
class AdminCategoriasControllerTest {
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    void shouldShowCategoriasPage() {
        ResponseEntity<String> response = restTemplate.getForEntity(
            "/admin/categorias", String.class);
        
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).contains("Categorías");
    }
}
```

---

## 11. Arquitectura de Performance

### 11.1 Arquitectura de Caching (Potencial)
**Estrategia sugerida**: Caching de consultas frecuentes

```java
@Service
public class CategoriaService {
    @Cacheable("categorias")
    public List<Categoria> findAll() {
        return categoriaRepository.findAll();
    }
}
```

### 11.2 Arquitectura de Conexiones
**Pool**: HikariCP (configurado por defecto en Spring Boot)

```properties
# Configuración de pool
spring.datasource.hikari.maximum-pool-size=5
spring.datasource.hikari.minimum-idle=2
spring.datasource.hikari.idle-timeout=30000
```

---

## 12. Arquitectura de Escalabilidad

### 12.1 Arquitectura Horizontal (Futura)
**Estrategia**: Stateless application + External database

**Requisitos para escalabilidad:**
1. **Session management**: Redis o similar
2. **Load balancer**: Nginx o Apache
3. **External database**: PostgreSQL/MySQL
4. **File storage**: S3 o similar

### 12.2 Arquitectura de Microservicios (Evolución)
**Descomposición potencial:**
```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  Product Service│  │  Order Service  │  │  User Service   │
│                 │  │                 │  │                 │
│ • CRUD Products │  │ • Order Mgmt    │  │ • Auth          │
│ • Categories    │  │ • Cart Logic    │  │ • Profiles      │
└─────────────────┘  └─────────────────┘  └─────────────────┘
         ↓                    ↓                    ↓
┌─────────────────────────────────────────────────────────────┐
│                    API Gateway                             │
│                    (Spring Cloud Gateway)                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 13. Resumen de Decisiones Arquitectónicas

| Decisión | Razón | Alternativas Consideradas |
|----------|-------|---------------------------|
| **Spring Boot** | Simplicidad y productividad | Spring MVC tradicional, Quarkus |
| **JDBC vs JPA** | Control total y simplicidad | JPA/Hibernate, MyBatis |
| **JSP vs Thymeleaf** | Familiaridad del equipo | Thymeleaf, React/Vue |
| **H2 vs PostgreSQL** | Desarrollo rápido | PostgreSQL, MySQL |
| **Monolítico vs Microservicios** | MVP simple | Microservicios desde inicio |
| **Bootstrap vs Tailwind** | Componentes listos | Tailwind CSS, Material UI |

---

## 14. Conclusiones Arquitectónicas

La arquitectura actual de VENTADEPOR sigue los principios SOLID y las mejores prácticas de Spring Boot:

1. **Mantenibilidad**: Separación clara de responsabilidades
2. **Escalabilidad**: Arquitectura preparada para evolución
3. **Performance**: Optimizaciones en acceso a datos
4. **Security**: Múltiples capas de validación
5. **Testability**: Arquitectura testable por capas

Esta arquitectura proporciona una base sólida para el desarrollo actual y permite una evolución gradual hacia patrones más complejos si el crecimiento de la aplicación lo requiere.
