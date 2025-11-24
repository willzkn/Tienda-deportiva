# Guía de Archivos Java del Backend

Este documento explica el propósito y uso de cada archivo Java en el backend del proyecto, incluyendo anotaciones Spring, patrones y operaciones JDBC utilizadas.

## 📁 Estructura General

El backend sigue una arquitectura MVC con Spring Boot:
- **Controllers**: Manejan peticiones HTTP y devuelven vistas
- **Services**: Contienen lógica de negocio y delegan a DAOs
- **Repositories/DAOs**: Acceso a datos con JDBC
- **Models**: Entidades que representan tablas de la BD

---

## 🚀 Configuración y Aplicación

### `DemoApplication.java`
```java
@SpringBootApplication
public class DemoApplication extends SpringBootServletInitializer
```
- **@SpringBootApplication**: Marca la clase principal de Spring Boot
- **extends SpringBootServletInitializer**: Permite despliegue como WAR en servidores externos
- **main()**: Punto de entrada que inicia la aplicación
- **@Bean StandardServletMultipartResolver**: Habilita subida de archivos (imágenes de productos)

### `WebConfig.java`
```java
@Configuration
public class WebConfig implements WebMvcConfigurer
```
- **@Configuration**: Clase de configuración de Spring
- **addResourceHandlers()**: Mapea URLs estáticas (`/css/**`, `/js/**`, `/images/**`, `/fonts/**`) a recursos en `classpath:/static/`

---

## 🎮 Controllers (Capa de Presentación)

### `HomeController.java`
```java
@Controller
public class HomeController
```
- **@Controller**: Marca como controlador Spring MVC
- **@GetMapping**: Mapea URLs GET a métodos (ej: `/`, `/productos`, `/contacto`)
- **@RequestParam**: Vincula parámetros de URL a variables (ej: `categoria`, `orden`)
- **Model**: Objeto para pasar datos a las vistas JSP
- **Uso**: Expone páginas públicas y lista productos con filtros

### `AdminController.java`
```java
@Controller
@RequestMapping("/admin")
```
- **@RequestMapping("/admin")**: Prefijo común para todas las rutas
- **@PostMapping**: Maneja formularios POST (login, reportes)
- **HttpSession**: Maneja sesión de administrador
- **Uso**: Panel administrativo con autenticación y reportes

### `AdminBoletasController.java`
```java
@Controller
@RequestMapping("/admin/boletas")
```
- **@PathVariable**: Extrae valores de URLs (ej: `/editar/{id}`)
- **@ModelAttribute**: Vincula objetos del formulario a parámetros del método
- **RedirectAttributes**: Para mensajes flash entre redirecciones
- **Uso**: CRUD completo de boletas y sus detalles

### `AdminCategoriasController.java`
```java
@Controller
@RequestMapping("/admin/categorias")
```
- **@Valid**: Habilita validación de formularios (si se usa Bean Validation)
- **BindingResult**: Contiene errores de validación
- **Uso**: Gestión de categorías de productos

### `AdminClientesController.java`
```java
@Controller
@RequestMapping("/admin/usuarios")
```
- **Uso**: Administración de usuarios/clientes del sistema

### `CarritoController.java`
```java
@Controller
```
- **Uso**: Expone la vista del carrito de compras (`/carrito`)

---

## 🧠 Services (Capa de Negocio)

### Interfaces de Servicio
- **BoletaService, CategoriaService, ProductoService, etc.**
- Definen contratos con métodos CRUD estándar
- Permiten desacoplamiento entre controllers y implementaciones

### Implementaciones de Servicio
```java
@Service
public class ProductoServiceImpl implements ProductoService
```
- **@Service**: Marca como componente de servicio de Spring
- **@Autowired**: Inyección de dependencias (DAOs)
- **MultipartFile**: Para manejar archivos subidos (imágenes)
- **Uso**: Lógica de negocio, validaciones y manejo de imágenes

### `ConsultaDataSource.java`
```java
@Service
public class ConsultaDataSource
```
- **DataSource**: Conexión a base de datos proporcionada por Spring
- **try-with-resources**: Garantiza cierre de Connection, PreparedStatement, ResultSet
- **PreparedStatement**: Evita SQL injection, permite parámetros
- **executeQuery()**: Para consultas SELECT
- **Uso**: Acceso directo a BD usando JDBC puro (alternativa a JdbcTemplate)

---

## 🗄️ Repositories/DAOs (Capa de Datos)

### Interfaces DAO
```java
public interface BoletaDAO
```
- Definen operaciones CRUD: `findAll()`, `findById()`, `save()`, `update()`, `deleteById()`
- Métodos específicos: `recalcTotal()`, `findByBoletaId()`, etc.

### Implementaciones JDBC
```java
@Repository
public class JdbcBoletaRepository implements BoletaDAO
```
- **@Repository**: Marca como componente de acceso a datos
- **JdbcTemplate**: Clase Spring para simplificar JDBC
- **RowMapper**: Convierte filas de ResultSet a objetos Java

#### Operaciones JdbcTemplate Comunes

##### `jdbcTemplate.query(sql, rowMapper)`
```java
List<Boleta> findAll() {
    String sql = "SELECT * FROM Boletas";
    return jdbcTemplate.query(sql, rowMapper);
}
```
- **Uso**: Ejecuta consultas SELECT que devuelven múltiples filas
- **Retorna**: List<T> donde T es el tipo mapeado

##### `jdbcTemplate.queryForObject(sql, rowMapper, id)`
```java
Optional<Boleta> findById(int id) {
    String sql = "SELECT * FROM Boletas WHERE id_boleta = ?";
    return Optional.ofNullable(jdbcTemplate.queryForObject(sql, rowMapper, id));
}
```
- **Uso**: Consultas SELECT que devuelven una sola fila
- **Retorna**: Objeto único o null

##### `jdbcTemplate.update(sql, params...)`
```java
void save(Boleta boleta) {
    String sql = "INSERT INTO Boletas (id_usuario, total) VALUES (?, ?)";
    jdbcTemplate.update(sql, boleta.getId_usuario(), boleta.getTotal());
}
```
- **Uso**: INSERT, UPDATE, DELETE
- **Retorna**: int (número de filas afectadas)

##### `jdbcTemplate.update(sql, params...)` con PreparedStatement
```java
void update(Producto producto) {
    String sql = "UPDATE Productos SET nombre = ?, precio = ? WHERE id_producto = ?";
    jdbcTemplate.update(sql, producto.getNombre(), producto.getPrecio(), producto.getId_producto());
}
```
- **Uso**: Operaciones de modificación con parámetros
- **Seguro contra SQL injection**

---

## 📦 Models (Entidades)

### Clases de Modelo
```java
public class Producto {
    private int id_producto;
    private String sku;
    private String nombre;
    private byte[] imagen;  // Para almacenar imágenes como bytes
    // getters/setters
}
```
- **POJOs**: Plain Old Java Objects que representan tablas
- **byte[] imagen**: Almacena imágenes como arreglo de bytes en BD
- **getImagenBase64()**: Método adicional para convertir imagen a Base64 (para mostrar en HTML)

---

## 🔧 Anotaciones Spring Principales

| Anotación | Propósito | Dónde se usa |
|-----------|-----------|--------------|
| `@SpringBootApplication` | Configuración principal | DemoApplication |
| `@Controller` | Maneja peticiones HTTP | Controllers |
| `@Service` | Lógica de negocio | Services |
| `@Repository` | Acceso a datos | DAOs |
| `@Configuration` | Clases de configuración | WebConfig |
| `@Autowired` | Inyección de dependencias | En constructores/campos |
| `@GetMapping` | Rutas GET | Métodos de controller |
| `@PostMapping` | Rutas POST | Métodos de controller |
| `@RequestMapping` | Ruta base | Clases de controller |
| `@RequestParam` | Parámetros URL | Métodos de controller |
| `@PathVariable` | Variables en URL | Métodos de controller |
| `@Bean` | Define un bean Spring | Métodos @Configuration |

---

## 📊 Operaciones JDBC Explicadas

### 1. Consultas (SELECT)
```java
// Múltiples resultados
jdbcTemplate.query(sql, rowMapper);

// Un solo resultado
jdbcTemplate.queryForObject(sql, rowMapper, id);
```

### 2. Modificaciones (INSERT/UPDATE/DELETE)
```java
// Sin parámetros
jdbcTemplate.update("DELETE FROM Boletas");

// Con parámetros (seguro)
jdbcTemplate.update("INSERT INTO Productos (nombre, precio) VALUES (?, ?)", 
                   nombre, precio);
```

### 3. RowMapper (Mapeo de Resultados)
```java
private final RowMapper<Boleta> rowMapper = (rs, rowNum) -> {
    Boleta b = new Boleta();
    b.setId_boleta(rs.getInt("id_boleta"));
    b.setTotal(rs.getDouble("total"));
    // Manejo de valores nulos
    Timestamp ts = rs.getTimestamp("fecha");
    if (ts != null) {
        b.setFecha(ts.toLocalDateTime());
    }
    return b;
};
```
- **rs**: ResultSet con los datos de la fila
- **rowNum**: Número de fila (generalmente no se usa)
- **Conversión**: De tipos SQL a tipos Java

### 4. Manejo de Fechas
```java
// SQL -> Java
Timestamp ts = rs.getTimestamp("fecha_emision");
if (ts != null) {
    boleta.setFecha_emision(ts.toLocalDateTime());
}

// Java -> SQL
ps.setTimestamp(1, Timestamp.valueOf(localDateTime));
```

---

## 🔄 Flujo Completo de una Petición

1. **Cliente** hace request HTTP (ej: GET `/admin/productos`)
2. **Controller** recibe la petición, valida parámetros
3. **Controller** llama a **Service** para obtener datos
4. **Service** delega a **DAO/Repository** usando JDBC
5. **DAO** ejecuta SQL con **JdbcTemplate**
6. **RowMapper** convierte resultados a objetos Java
7. **Service** aplica lógica de negocio si es necesario
8. **Controller** agrega datos al **Model**
9. **Controller** devuelve nombre de vista JSP
10. **Spring** renderiza la vista con los datos

---

## 🎯 Mejores Prácticas Observadas

1. **Inyección por constructor**: Preferible a @Autowired en campos
2. **Optional**: Para manejar valores que pueden ser nulos
3. **PreparedStatement**: Siempre para parámetros dinámicos
4. **try-with-resources**: Para manejo manual de conexiones
5. **Separación de responsabilidades**: Cada capa con su propósito claro
6. **Anotaciones descriptivas**: Comentadas para facilitar mantenimiento

---

## 📝 Notas Adicionales

- **JPA vs JDBC**: Este proyecto usa JDBC puro (no JPA/Hibernate)
- **Transacciones**: No se ven explícitamente (Spring las maneja automáticamente)
- **Validación**: Básica, sin Bean Validation
- **Seguridad**: Autenticación simple por sesión
- **Imágenes**: Se almacenan como bytes en BD, no como archivos
