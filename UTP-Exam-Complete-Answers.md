# 🎓 Preguntas y Respuestas de Código Profundo - Tienda Deportiva UTP

## 📋 Tabla de Contenidos
- [Backend - Controllers](#backend---controllers)
- [Backend - Services](#backend---services)
- [Backend - Repositories/DAOs](#backend---repositoriesdaos)
- [Backend - Models](#backend---models)
- [Frontend - JSPs](#frontend---jsps)
- [Frontend - JavaScript](#frontend---javascript)
- [Configuración y Arquitectura](#configuración-y-arquitectura)

---

## Backend - Controllers

### 🎯 **AdminController.java**

**1. ¿Qué hace exactamente `@RequestMapping("/admin")` a nivel interno de Spring?**

**📄 Código:**
```java
@Controller
@RequestMapping("/admin")
public class AdminController {
```

**✅ Respuesta:**
- **Qué hace:** Spring registra este mapeo en el `HandlerMapping` del `DispatcherServlet`
- **Cómo funciona:** Spring escanea las anotaciones al inicio y crea un `RequestMappingInfo` que asocia la URL "/admin" con este controller
- **Por qué:** Centraliza las rutas y permite que todas las URLs de este controller comiencen con "/admin"
- **Alternativas:** `@GetMapping`, `@PostMapping` individuales, o configuración XML
- **Problemas:** Si dos controllers tienen el mismo @RequestMapping base, Spring lanza `IllegalStateException`
- **Mejoras:** Usar paths más específicos como `/admin/dashboard` para evitar colisiones

**🔍 Código interno de Spring (simplificado):**
```java
// Spring internamente hace algo como:
RequestMappingInfo mapping = RequestMappingInfo.paths("/admin").build();
this.mappingRegistry.registerMapping(mapping, this.adminController, method);
```

---

**2. ¿Qué sucede internamente cuando se ejecuta `model.addAttribute("boletas", boletaService.listarTodas())`?**

**📄 Código:**
```java
@GetMapping("/reportes")
public String verReportes(Model model) {
    model.addAttribute("boletas", boletaService.listarTodas());
    model.addAttribute("productos", productoService.listarTodos());
```

**✅ Respuesta:**
- **Qué hace:** Spring almacena los datos en el `ModelMap` que está en el `HttpServletRequest`
- **Cómo funciona:** Spring usa `BindingAwareModelMap` que implementa `Model` y `ModelMap`, almacenando los datos en el request scope
- **Por qué:** Para pasar datos desde el controller a la vista JSP
- **Alternativas:** `ModelAndView`, `@ModelAttribute` en parámetros
- **Problemas:** Si se almacenan muchos objetos, puede consumir mucha memoria en el request
- **Mejoras:** Usar DTOs para transferir solo los datos necesarios

**🔍 Código interno de Spring:**
```java
// Spring internamente hace:
public class BindingAwareModelMap extends ExtendedModelMap {
    // Almacena en request.setAttribute()
    request.setAttribute("boletas", boletas);
    request.setAttribute("productos", productos);
}
```

---

**3. ¿Qué hace `ObjectMapper objectMapper = new ObjectMapper()` en memoria?**

**📄 Código:**
```java
ObjectMapper objectMapper = new ObjectMapper();
String ventasPorMesJson = objectMapper.writeValueAsString(ventasPorMes);
```

**✅ Respuesta:**
- **Qué hace:** Crea una instancia de Jackson ObjectMapper para convertir objetos Java a JSON
- **Cómo funciona:** Usa reflection para analizar los campos del objeto y generar el JSON string
- **Por qué:** Para pasar datos estructurados a JavaScript en el frontend
- **Alternativas:** Gson, JSON-B, o JSON.stringify manual
- **Problemas:** Si hay referencias cíclicas, puede causar `StackOverflowError`
- **Mejoras:** Reutilizar la misma instancia, configurar como bean de Spring

**🔍 Código interno de Jackson:**
```java
// ObjectMapper internamente:
public String writeValueAsString(Object value) throws JsonProcessingException {
    // 1. Crea un JsonGenerator
    // 2. Usa reflection para analizar el objeto
    // 3. Escribe cada campo como JSON
    // 4. Retorna el string resultante
}
```

---

**4. ¿Qué significa `RedirectAttributes attr` y cómo funciona internamente?**

**📄 Código:**
```java
public String eliminar(@PathVariable("id") int id, RedirectAttributes attr) {
    attr.addFlashAttribute("success", "Boleta eliminada exitosamente");
```

**✅ Respuesta:**
- **Qué hace:** Almacena atributos temporalmente entre una redirección y el siguiente request
- **Cómo funciona:** Spring usa `FlashMapManager` que almacena los datos en la sesión HTTP y los elimina después del siguiente request
- **Por qué:** Para pasar mensajes entre redirecciones sin perderlos
- **Alternativas:** Parámetros en URL, sesión directa
- **Problemas:** Si el usuario hace refresh, los mensajes desaparecen
- **Mejoras:** Usar `RedirectAttributes` con `@ModelAttribute` para validaciones

**🔍 Código interno de Spring:**
```java
// Spring internamente:
public class FlashMapManager {
    public void saveOutputFlashMap(FlashMap flashMap, HttpServletRequest request) {
        // Almacena en HttpSession
        HttpSession session = request.getSession();
        session.setAttribute("org.springframework.web.servlet.FlashMap.FLASH_MAPS", flashMap);
    }
}
```

---

**5. ¿Qué hace `@PostMapping("/guardar")` a nivel de HTTP y Spring?**

**📄 Código:**
```java
@PostMapping("/guardar")
public String guardar(@ModelAttribute Producto producto) {
```

**✅ Respuesta:**
- **Qué hace:** Mapea peticiones HTTP POST a la URL "/admin/productos/guardar"
- **Cómo funciona:** Spring usa `RequestMappingHandlerMapping` para registrar el mapeo y `DispatcherServlet` para enrutar la petición
- **Por qué:** Para procesar envíos de formularios que modifican datos
- **Alternativas:** `@RequestMapping(method = RequestMethod.POST)`
- **Problemas:** Si viene un GET a esta URL, devuelve 405 Method Not Allowed
- **Mejoras:** Usar CSRF protection para seguridad

**🔍 Código interno de Spring:**
```java
// Spring internamente:
@PostMapping("/guardar")
// es equivalente a:
@RequestMapping(value = "/guardar", method = RequestMethod.POST)
```

---

### 🎯 **AdminBoletasController.java**

**6. ¿Qué sucede exactamente cuando se ejecuta `@ModelAttribute Boleta boleta`?**

**📄 Código:**
```java
@PostMapping("/guardar")
public String guardar(@ModelAttribute Boleta boleta) {
```

**✅ Respuesta:**
- **Qué hace:** Spring automaticamente mapea los parámetros del formulario HTML a un objeto Boleta
- **Cómo funciona:** Usa `DataBinder` y `PropertyEditor` para convertir strings a los tipos apropiados
- **Por qué:** Para evitar el manejo manual de parámetros HTTP
- **Alternativas:** `@RequestParam` individual, HttpServletRequest manual
- **Problemas:** Si los campos no coinciden, quedan null
- **Mejoras:** Usar `@Valid` con validaciones

**🔍 Código interno de Spring:**
```java
// Spring internamente:
public class DataBinder {
    public void bind(PropertyValues propertyValues) {
        // 1. Itera sobre los parámetros del request
        // 2. Usa reflection para encontrar setters
        // 3. Convierte tipos automáticamente
        // 4. Aplica validaciones si hay @Valid
    }
}
```

---

**7. ¿Qué hace `@PathVariable("id") int id` internamente?**

**📄 Código:**
```java
@GetMapping("/editar/{id}")
public String editar(@PathVariable("id") int id, Model model) {
```

**✅ Respuesta:**
- **Qué hace:** Extrae el valor de la URL y lo convierte al tipo especificado
- **Cómo funciona:** Spring usa `UriTemplate` para hacer match del pattern y extraer variables
- **Por qué:** Para crear URLs RESTful y amigables
- **Alternativas:** `@RequestParam` con query parameters
- **Problemas:** Si la URL tiene texto en vez de número, lanza `NumberFormatException`
- **Mejoras:** Usar `Optional<Integer>` para manejar valores inválidos

**🔍 Código interno de Spring:**
```java
// Spring internamente:
public boolean match(String lookupPath, Map<String, String> uriVariables) {
    // 1. Hace match del pattern "/editar/{id}" con "/editar/123"
    // 2. Extrae "123" como variable "id"
    // 3. Convierte "123" a Integer
    // 4. Maneja excepciones de conversión
}
```

---

**8. ¿Qué significa `boletaService.recalcTotal(idBoleta)` a nivel de base de datos?**

**📄 Código:**
```java
detalleBoletaService.guardar(detalle);
boletaService.recalcTotal(idBoleta);
```

**✅ Respuesta:**
- **Qué hace:** Ejecuta un UPDATE SQL que suma los subtotales de todos los detalles de la boleta
- **Cómo funciona:** El DAO ejecuta un query con SUM() y actualiza el campo total
- **Por qué:** Para mantener la consistencia entre detalles y total
- **Alternativas:** Calcular el total en Java y actualizar
- **Problemas:** Si el recalcTotal falla después de guardar, quedan datos inconsistentes
- **Mejoras:** Usar @Transactional para atomicidad

**🔍 SQL que se ejecuta:**
```sql
-- Internamente el DAO ejecuta:
UPDATE Boletas 
SET total = (
    SELECT COALESCE(SUM(cantidad * precio_unitario), 0) 
    FROM DetalleBoletas 
    WHERE id_boleta = ?
)
WHERE id_boleta = ?;
```

---

### 🎯 **HomeController.java**

**9. ¿Qué hace `return "redirect:/inicio";` internamente?**

**📄 Código:**
```java
@GetMapping("/")
public String root() {
    return "redirect:/inicio";
}
```

**✅ Respuesta:**
- **Qué hace:** Envía una respuesta HTTP 302 Found con header Location: /inicio
- **Cómo funciona:** Spring usa `RedirectView` que establece el status code y header apropiados
- **Por qué:** Para redirigir al usuario a otra URL
- **Alternativas:** `ResponseEntity.redirect()`, `HttpServletResponse.sendRedirect()`
- **Problemas:** El browser hace una segunda petición, duplicando el trabajo
- **Mejoras:** Usar forward si es dentro de la misma aplicación

**🔍 Código interno de Spring:**
```java
// Spring internamente:
public class RedirectView {
    protected void renderMergedOutputModel(Map<String, Object> model, 
                                          HttpServletRequest request, 
                                          HttpServletResponse response) {
        response.sendRedirect(url); // Envía HTTP 302
    }
}
```

---

**10. ¿Qué sucede cuando se ejecuta `productos.sort(Comparator.comparing(Producto::getPrecio))`?**

**📄 Código:**
```java
case "precio-asc":
    productos.sort(Comparator.comparing(Producto::getPrecio));
    break;
```

**✅ Respuesta:**
- **Qué hace:** Ordena la lista de productos por precio usando el algoritmo TimSort de Java
- **Cómo funciona:** `Comparator.comparing()` crea un comparator basado en el método getPrecio()
- **Por qué:** Para mostrar productos ordenados al usuario
- **Alternativas:** `Collections.sort()`, streams con `sorted()`
- **Problemas:** Con 1000 productos hace muchas comparaciones O(n log n)
- **Mejoras:** Ordenar en la base de datos con ORDER BY

**🔍 Código interno de Java:**
```java
// Java internamente usa TimSort:
public static <T> void sort(T[] a, Comparator<? super T> c) {
    // TimSort es híbrido: MergeSort + InsertionSort
    // O(n log n) en promedio, O(n) en el mejor caso
    // Estable: mantiene el orden de elementos iguales
}
```

---

**11. ¿Qué hace `model.addAttribute("selectedCategoriaId", categoriaId)`?**

**📄 Código:**
```java
model.addAttribute("selectedCategoriaId", categoriaId);
model.addAttribute("selectedSortBy", sortBy);
```

**✅ Respuesta:**
- **Qué hace:** Almacena los valores seleccionados en el request para que los selectores mantengan su estado
- **Cómo funciona:** Spring los pone como atributos en el HttpServletRequest
- **Por qué:** Para que el usuario vea qué opciones seleccionó
- **Alternativas:** Session attributes, cookies
- **Problemas:** Si categoriaId es null, puede causar errores en JSP
- **Mejoras:** Usar valores por defecto

**🔍 Código interno de Spring:**
```java
// Spring internamente:
request.setAttribute("selectedCategoriaId", categoriaId);
request.setAttribute("selectedSortBy", sortBy);
```

---

## Backend - Services

### 🎯 **BoletaServiceImpl.java**

**12. ¿Qué hace `@Service` internamente en Spring?**

**📄 Código:**
```java
@Service
public class BoletaServiceImpl implements BoletaService {
```

**✅ Respuesta:**
- **Qué hace:** Registra esta clase como bean de Spring y le da semántica de capa de servicio
- **Cómo funciona:** Spring escanea @Service, crea proxy si es necesario, y la registra en el ApplicationContext
- **Por qué:** Para separar la lógica de negocio y permitir inyección de dependencias
- **Alternativas:** @Component, @Repository
- **Problemas:** Si hay múltiples implementaciones, Spring no sabe cuál inyectar
- **Mejoras:** Usar @Qualifier si hay múltiples beans

**🔍 Código interno de Spring:**
```java
// @Service es meta-anotación de @Component:
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component  // <- Esta es la anotación clave
public @interface Service {
    String value() default "";
}
```

---

**13. ¿Qué sucede cuando se inyecta `private final BoletaDAO boletaDao`?**

**📄 Código:**
```java
private final BoletaDAO boletaDao;

public BoletaServiceImpl(BoletaDAO boletaDao) {
    this.boletaDao = boletaDao;
}
```

**✅ Respuesta:**
- **Qué hace:** Spring busca un bean que implemente BoletaDAO y lo inyecta en el constructor
- **Cómo funciona:** Usa `AutowiredAnnotationBeanPostProcessor` para resolver dependencias
- **Por qué:** Para desacoplar el service de la implementación concreta del DAO
- **Alternativas:** Inyección por campo con @Autowired, por setter
- **Problemas:** Si hay dos implementaciones, Spring lanza `NoUniqueBeanDefinitionException`
- **Mejoras:** Usar @Qualifier o @Primary

**🔍 Código interno de Spring:**
```java
// Spring internamente:
public class ConstructorResolver {
    public Object resolveAutowiredArgument(MethodParameter parameter, ...) {
        // 1. Busca beans del tipo BoletaDAO
        // 2. Si hay uno, lo inyecta
        // 3. Si hay múltiples, busca @Qualifier
        // 4. Si no hay ninguno, lanza excepción
    }
}
```

---

**14. ¿Qué significa `boletaDao.findAll()` a nivel de JDBC?**

**📄 Código:**
```java
@Override
public List<Boleta> listarTodas() { 
    return boletaDao.findAll(); 
}
```

**✅ Respuesta:**
- **Qué hace:** Abre una conexión a la BD, ejecuta SELECT, crea objetos Boleta, cierra conexión
- **Cómo funciona:** JdbcTemplate obtiene conexión del pool, crea PreparedStatement, ejecuta query, mapea ResultSet
- **Por qué:** Para obtener todas las boletas de la base de datos
- **Alternativas:** JPA, Criteria API, queries nativos
- **Problemas:** Si hay muchas boletas, puede consumir mucha memoria
- **Mejoras:** Paginación, caching, solo campos necesarios

**🔍 Código interno de JdbcTemplate:**
```java
// JdbcTemplate internamente:
public <T> List<T> query(String sql, RowMapper<T> rowMapper, Object... args) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        // 1. Obtiene conexión del pool
        conn = DataSourceUtils.getConnection(obtainDataSource());
        // 2. Crea PreparedStatement
        ps = conn.prepareStatement(sql);
        // 3. Ejecuta query
        rs = ps.executeQuery();
        // 4. Mapea cada fila a objeto
        return rowMapper.mapRows(rs, this);
    } finally {
        // 5. Cierra recursos en orden inverso
        JdbcUtils.closeResultSet(rs);
        JdbcUtils.closeStatement(ps);
        DataSourceUtils.releaseConnection(conn, getDataSource());
    }
}
```

---

**15. ¿Qué pasa si `boletaDao.save(boleta)` lanza una excepción?**

**📄 Código:**
```java
@Override
public void guardar(Boleta boleta) { 
    boletaDao.save(boleta); 
}
```

**✅ Respuesta:**
- **Qué hace:** La excepción se propaga hacia arriba, Spring puede hacer rollback si hay @Transactional
- **Cómo funciona:** Si no hay @Transactional, los cambios persisten; si hay, Spring intercepta y hace rollback
- **Por qué:** Para mantener la integridad de los datos
- **Alternativas:** Try-catch manual, manejo de excepciones específicas
- **Problemas:** Si no hay manejo, el usuario ve error 500
- **Mejoras:** @Transactional con rollback específico

**🔍 Código interno de Spring Transaction:**
```java
// Spring TransactionInterceptor:
public Object invoke(MethodInvocation invocation) throws Throwable {
    try {
        // 1. Inicia transacción
        TransactionInfo txInfo = createTransactionIfNecessary(...);
        // 2. Ejecuta método
        Object retVal = invocation.proceed();
        // 3. Si todo bien, hace commit
        commitTransactionAfterReturning(txInfo);
        return retVal;
    } catch (Throwable ex) {
        // 4. Si hay excepción, hace rollback
        completeTransactionAfterThrowing(txInfo, ex);
        throw ex;
    }
}
```

---

### 🎯 **ProductoService.java**

**16. ¿Qué hace `productoService.listarTodos()` internamente?**

**📄 Código:**
```java
List<Producto> productos = productoService.listarTodos();
```

**✅ Respuesta:**
- **Qué hace:** Ejecuta SELECT * FROM Productos y crea un objeto Producto por cada fila
- **Cómo funciona:** El service delega al repository, que usa JdbcTemplate para ejecutar el query
- **Por qué:** Para obtener todos los productos disponibles
- **Alternativas:** Streaming, paginación, caching
- **Problemas:** Con 1 millón de productos, puede causar OutOfMemoryError
- **Mejoras:** Paginar, solo campos necesarios, lazy loading

**🔍 Consumo de memoria:**
```java
// Si hay 1000 productos:
// Cada Producto ~200 bytes
// Total: 200KB + overhead del ArrayList ~8KB
// Con 1M productos: ~200MB + overhead ~8MB
```

---

**17. ¿Qué significa `productoService.listarCategorias()`?**

**📄 Código:**
```java
model.addAttribute("categorias", productoService.listarCategorias());
```

**✅ Respuesta:**
- **Qué hace:** Obtiene todas las categorías disponibles para los filtros
- **Cómo funciona:** Probablemente ejecuta SELECT DISTINCT o JOIN con categorías
- **Por qué:** Para que el usuario pueda filtrar productos por categoría
- **Alternativas:** Servicio de categorías separado
- **Problemas:** Acoplamiento: productoService no debería manejar categorías
- **Mejoras:** Inyectar CategoriaService directamente

**🔍 Mejor diseño:**
```java
// Mejor sería:
@Autowired
private CategoriaService categoriaService;

@GetMapping("/productos")
public String verProductos(Model model) {
    model.addAttribute("categorias", categoriaService.listarTodas());
    // ...
}
```

---

## Backend - Repositories/DAOs

### 🎯 **Interfaces DAO**

**18. ¿Qué significa que `BoletaDAO` sea una interfaz?**

**📄 Código:**
```java
public interface BoletaDAO {
    List<Boleta> findAll();
    Optional<Boleta> findById(int id);
```

**✅ Respuesta:**
- **Qué hace:** Define el contrato de operaciones de base de datos sin implementación
- **Cómo funciona:** Spring busca una clase que implemente esta interfaz con @Repository
- **Por qué:** Para desacoplar la lógica de negocio de la implementación JDBC
- **Alternativas:** Clases concretas directamente, JPA repositories
- **Problemas:** Si no hay implementación, Spring no puede iniciar
- **Mejoras:** Usar Spring Data JPA que genera implementación automáticamente

**🔍 Spring busca implementación:**
```java
// Spring busca clases con:
@Repository
public class BoletaDAOImpl implements BoletaDAO {
    // implementación aquí
}
```

---

**19. ¿Qué hace `Optional<Boleta>` internamente?**

**📄 Código:**
```java
Optional<Boleta> findById(int id);
```

**✅ Respuesta:**
- **Qué hace:** Envuelve un objeto que puede o no existir, evitando null
- **Cómo funciona:** Optional es un container que puede estar vacío o contener un valor
- **Por qué:** Para evitar NullPointerException y forzar manejo de ausencia
- **Alternativas:** Return null, excepción, Result pattern
- **Problemas:** Si no se usa correctamente, puede generar más complejidad
- **Mejoras:** Usar métodos como orElse(), orElseThrow(), map()

**🔍 Código interno de Optional:**
```java
// Optional simplificado:
public final class Optional<T> {
    private final T value;
    private final boolean present;
    
    public static <T> Optional<T> ofNullable(T value) {
        return value == null ? empty() : of(value);
    }
    
    public T orElse(T other) {
        return present ? value : other;
    }
}
```

---

**20. ¿Qué significa `void save(Boleta boleta)` a nivel de base de datos?**

**📄 Código:**
```java
void save(Boleta boleta);
```

**✅ Respuesta:**
- **Qué hace:** Ejecuta INSERT INTO Boletas VALUES(...) o UPDATE si ya existe
- **Cómo funciona:** El DAO determina si es INSERT o UPDATE basado en el ID
- **Por qué:** Para persistir el objeto en la base de datos
- **Alternativas:** saveOrUpdate(), métodos separados insert()/update()
- **Problemas:** Si el ID es autoincremental, hay que obtener el generated key
- **Mejoras:** Usar JPA que maneja esto automáticamente

**🔍 SQL generado:**
```sql
-- Si boleta.getId_boleta() == null:
INSERT INTO Boletas (id_usuario, fecha_emision, total) 
VALUES (?, ?, ?);

-- Si boleta.getId_boleta() != null:
UPDATE Boletas 
SET id_usuario = ?, fecha_emision = ?, total = ? 
WHERE id_boleta = ?;
```

---

### 🎯 **Implementaciones (si existen)**

**21. ¿Qué hace `JdbcTemplate jdbcTemplate` internamente?**

**📄 Código:**
```java
private final JdbcTemplate jdbcTemplate;
```

**✅ Respuesta:**
- **Qué hace:** Maneja conexiones, statements, y recursos JDBC automáticamente
- **Cómo funciona:** Usa un DataSource para obtener conexiones del pool y maneja excepciones
- **Por qué:** Para evitar el boilerplate de JDBC tradicional
- **Alternativas:** JPA Hibernate, MyBatis, JDBC puro
- **Problemas:** Si el pool se agota, las peticiones esperan indefinidamente
- **Mejoras:** Configurar timeout, pool size adecuado

**🔍 Pool de conexiones HikariCP:**
```java
// HikariCP internamente:
public class HikariDataSource {
    private final HikariPool pool;
    
    public Connection getConnection() throws SQLException {
        // 1. Toma conexión del pool
        // 2. Si no hay, espera timeout
        // 3. Si timeout, lanza SQLException
        // 4. Devuelve conexión envuelta
    }
}
```

---

**22. ¿Qué sucede cuando se ejecuta `jdbcTemplate.query(sql, new BoletaRowMapper())`?**

**📄 Código:**
```java
return jdbcTemplate.query(sql, new BoletaRowMapper());
```

**✅ Respuesta:**
- **Qué hace:** Ejecuta el SQL, itera sobre el ResultSet, crea un Boleta por cada fila
- **Cómo funciona:** JdbcTemplate maneja conexión/statement, RowMapper mapea cada fila
- **Por qué:** Para convertir resultados SQL a objetos Java automáticamente
- **Alternativas:** ResultSetExtractor, queryForList, queryForObject
- **Problemas:** Con muchos resultados, usa mucha memoria
- **Mejoras:** Streaming, paginación, solo campos necesarios

**🔍 Flujo completo:**
```java
// 1. JdbcTemplate obtiene conexión
Connection conn = dataSource.getConnection();

// 2. Crea PreparedStatement
PreparedStatement ps = conn.prepareStatement(sql);

// 3. Ejecuta query
ResultSet rs = ps.executeQuery();

// 4. Por cada fila, llama al RowMapper
List<Boleta> boletas = new ArrayList<>();
while (rs.next()) {
    Boleta boleta = rowMapper.mapRow(rs, rowNum);
    boletas.add(boleta);
}

// 5. Cierra recursos automáticamente
```

---

**23. ¿Qué hace `new BoletaRowMapper()` en memoria?**

**📄 Código:**
```java
private static final class BoletaRowMapper implements RowMapper<Boleta> {
    @Override
    public Boleta mapRow(ResultSet rs, int rowNum) throws SQLException {
```

**✅ Respuesta:**
- **Qué hace:** Crea una instancia del mapper que será llamado por cada fila del ResultSet
- **Cómo funciona:** RowMapper.mapRow() es llamado por cada fila para crear un objeto
- **Por qué:** Para convertir ResultSet a objetos de dominio
- **Alternativas:** BeanPropertyRowMapper, ResultSetExtractor
- **Problemas:** Si el ResultSet tiene 1000 filas, se crean 1000 objetos Boleta
- **Mejoras:** Reusar el mapper, usar singleton pattern

**🔍 Código interno de mapeo:**
```java
// Por cada fila del ResultSet:
public Boleta mapRow(ResultSet rs, int rowNum) throws SQLException {
    Boleta boleta = new Boleta();  // Nuevo objeto por fila
    boleta.setId_boleta(rs.getInt("id_boleta"));
    boleta.setId_usuario(rs.getInt("id_usuario"));
    boleta.setFecha_emision(rs.getTimestamp("fecha_emision").toLocalDateTime());
    boleta.setTotal(rs.getDouble("total"));
    return boleta;  // Objeto creado y poblado
}
```

---

**24. ¿Qué significa `KeyHolder keyHolder = new GeneratedKeyHolder()`?**

**📄 Código:**
```java
KeyHolder keyHolder = new GeneratedKeyHolder();
jdbcTemplate.update(connection -> {...}, keyHolder);
```

**✅ Respuesta:**
- **Qué hace:** Captura las claves generadas automáticamente por la base de datos
- **Cómo funciona:** Usa PreparedStatement.getGeneratedKeys() para obtener IDs autoincrementales
- **Por qué:** Para obtener el ID generado después de un INSERT
- **Alternativas:** Query después del INSERT, SELECT LAST_INSERT_ID()
- **Problemas:** No funciona con todas las bases de datos
- **Mejoras:** Usar JPA que maneja esto automáticamente

**🔍 Código interno de GeneratedKeyHolder:**
```java
// GeneratedKeyHolder internamente:
public class GeneratedKeyHolder implements KeyHolder {
    private List<Map<String, Object>> keyList;
    
    public Number getKey() throws InvalidDataAccessApiUsageException {
        // Obtiene la primera clave generada
        return (Number) this.keyList.get(0).get("id_boleta");
    }
}
```

---

## Backend - Models

### 🎯 **Entidades JPA/POJOs**

**25. ¿Qué hace `private Integer id_producto;` en memoria?**

**📄 Código:**
```java
public class Producto {
    private Integer id_producto;
    private String nombreProducto;
    private Double precio;
```

**✅ Respuesta:**
- **Qué hace:** Reserva espacio para un objeto Integer (16 bytes) + referencia (4 bytes)
- **Cómo funciona:** Integer es un wrapper que permite null y tiene métodos útiles
- **Por qué:** Para poder tener null (indicando que no tiene ID aún) y usar en colecciones
- **Alternativas:** int primitivo (8 bytes, no puede ser null)
- **Problemas:** Usa más memoria que int primitivo
- **Mejoras:** Usar int si nunca será null

**🔍 Consumo de memoria:**
```java
// Integer vs int:
Integer id = 123;    // 16 bytes (objeto) + 4 bytes (referencia) = 20 bytes
int id = 123;        // 8 bytes directamente
```

---

**26. ¿Qué significa `String nombreProducto;` vs `String nombre_producto;`?**

**📄 Código:**
```java
private String nombreProducto;  // camelCase
private String nombre_producto; // snake_case
```

**✅ Respuesta:**
- **Qué hace:** Ambos declaran una variable String, pero siguen convenciones diferentes
- **Cómo funciona:** Spring mapea usando reflection, no le afecta el naming
- **Por qué:** camelCase es convención Java, snake_case es convención BD
- **Alternativas:** Usar @Column para mapeo explícito
- **Problemas:** Inconsistencia entre código y BD
- **Mejoras:** Estandarizar a camelCase con @Column

**🔍 Mapeo con JPA:**
```java
@Column(name = "nombre_producto")
private String nombreProducto;
```

---

**27. ¿Qué sucede cuando se ejecuta `new Producto()`?**

**📄 Código:**
```java
model.addAttribute("producto", new Producto());
```

**✅ Respuesta:**
- **Qué hace:** Crea un objeto Producto con todos los campos en null/0
- **Cómo funciona:** Java llama al constructor por defecto y reserva memoria
- **Por qué:** Para tener un objeto vacío para el formulario
- **Alternativas:** Builder pattern, factory methods
- **Problemas:** Todos los campos null, puede causar NPE
- **Mejoras:** Inicializar con valores por defecto

**🔍 Estado inicial del objeto:**
```java
Producto producto = new Producto();
// Estado inicial:
producto.id_producto = null;
producto.nombreProducto = null;
producto.precio = null;
producto.stock = null;
```

---

**28. ¿Qué hace `public Integer getId_producto() { return id_producto; }`?**

**📄 Código:**
```java
public Integer getId_producto() { return id_producto; }
public void setId_producto(Integer id_producto) { this.id_producto = id_producto; }
```

**✅ Respuesta:**
- **Qué hace:** Proporciona acceso controlado a los campos privados
- **Cómo funciona:** Spring usa reflection para llamar a estos getters/setters
- **Por qué:** Para encapsulación y permitir frameworks acceder a los datos
- **Alternativas:** Campos públicos, Lombok @Getter/@Setter
- **Problemas:** Boilerplate repetitivo
- **Mejoras:** Usar Lombok para generar automáticamente

**🔍 Spring y getters:**
```java
// Spring usa reflection para llamar:
Method getter = Producto.class.getMethod("getId_producto");
Integer id = (Integer) getter.invoke(producto);
```

---

### 🎯 **Campos Calculados**

**29. ¿Qué hace `public String getFechaFormateada()`?**

**📄 Código:**
```java
public String getFechaFormateada() {
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    return fecha_emision != null ? fecha_emision.format(formatter) : "";
}
```

**✅ Respuesta:**
- **Qué hace:** Formatea la fecha a un formato legible para el usuario
- **Cómo funciona:** Usa DateTimeFormatter para convertir LocalDateTime a String
- **Por qué:** Para mostrar fechas en un formato consistente en la UI
- **Alternativas:** Formatear en el JSP, usar @JsonFormat
- **Problemas:** Se ejecuta cada vez que se accede, puede ser ineficiente
- **Mejoras:** Cachear el resultado si no cambia

**🔍 Formato en JSP:**
```jsp
<!-- En JSP se puede acceder directamente: -->
<td>${boleta.fechaFormateada}</td>
<!-- Spring llama automáticamente al getter -->
```

---

**30. ¿Qué significa `public double getSubtotal()`?**

**📄 Código:**
```java
public double getSubtotal() {
    return cantidad * precio_unitario;
}
```

**✅ Respuesta:**
- **Qué hace:** Calcula el subtotal multiplicando cantidad por precio unitario
- **Cómo funciona:** Operación aritmética simple en tiempo de ejecución
- **Por qué:** Para no almacenar datos calculados que pueden volverse inconsistentes
- **Alternativas:** Almacenar el subtotal, calcular en la BD
- **Problemas:** Se recalcula cada vez que se accede
- **Mejoras:** Cachear si no cambia frecuentemente

**🔍 Uso en JSP:**
```jsp
<td>${detalle.subtotal}</td>
<!-- Spring llama al getter y muestra el resultado -->
```

---

## Frontend - JSPs

### 🎯 **JSTL y Expression Language**

**31. ¿Qué hace `${boletas}` exactamente?**

**📄 Código:**
```jsp
<c:forEach items="${boletas}" var="boleta">
```

**✅ Respuesta:**
- **Qué hace:** Busca el atributo "boletas" en pageContext, request, session, application scopes
- **Cómo funciona:** EL (Expression Language) resuelve la variable usando PageContext.findAttribute()
- **Por qué:** Para acceder a los datos que el controller puso en el Model
- **Alternativas:** JSP scriptlets <%= request.getAttribute("boletas") %>
- **Problemas:** Si no existe, devuelve null (o empty string)
- **Mejoras:** Usar <c:if test="${not empty boletas}"> para validar

**🔍 Resolución de EL:**
```java
// EL internamente hace:
Object boletas = pageContext.findAttribute("boletas");
// Busca en orden: page -> request -> session -> application
```

---

**32. ¿Qué sucede cuando se ejecuta `<c:forEach items="${boletas}" var="boleta">`?**

**📄 Código:**
```jsp
<c:forEach items="${boletas}" var="boleta">
    <tr>
        <td>${boleta.id_boleta}</td>
        <td>${boleta.usuario_correo}</td>
```

**✅ Respuesta:**
- **Qué hace:** Itera sobre la colección de boletas, creando una variable "boleta" por cada elemento
- **Cómo funciona:** JSTL crea un iterador y expone cada elemento en el PageContext
- **Por qué:** Para generar filas de tabla dinámicamente
- **Alternativas:** JSP for loop, JavaScript iteration
- **Problemas:** Con muchas boletas, genera mucho HTML
- **Mejoras:** Paginar, virtual scrolling

**🔍 Código generado:**
```jsp
<!-- Si hay 3 boletas, genera: -->
<tr><td>1</td><td>user1@email.com</td></tr>
<tr><td>2</td><td>user2@email.com</td></tr>
<tr><td>3</td><td>user3@email.com</td></tr>
```

---

**33. ¿Qué significa `${boleta.fechaFormateada}`?**

**📄 Código:**
```jsp
<td>${boleta.fechaFormateada}</td>
```

**✅ Respuesta:**
- **Qué hace:** Lama al método getFechaFormateada() del objeto boleta y muestra el resultado
- **Cómo funciona:** EL usa reflection para encontrar y ejecutar el getter
- **Por qué:** Para mostrar la fecha formateada en lugar del objeto LocalDateTime
- **Alternativas:** Formatear en JSP con fmt:formatDate
- **Problemas:** Si el método lanza excepción, muestra error en página
- **Mejoras:** Manejar nulos en el getter

**🔍 EL y getters:**
```java
// EL convierte ${boleta.fechaFormateada} a:
Object boleta = pageContext.findAttribute("boleta");
Method getter = boleta.getClass().getMethod("getFechaFormateada");
String result = (String) getter.invoke(boleta);
out.print(result);
```

---

**34. ¿Qué hace `<form:form action="/admin/productos/guardar" modelAttribute="producto">`?**

**📄 Código:**
```jsp
<form:form action="/admin/productos/guardar" modelAttribute="producto">
    <form:input path="nombreProducto"/>
```

**✅ Respuesta:**
- **Qué hace:** Crea un formulario HTML y lo vincula con el objeto "producto" del Model
- **Cómo funciona:** Spring Form tags generan HTML y vinculan campos con el backend
- **Por qué:** Para binding automático y validación
- **Alternativas:** HTML form puro, JavaScript frameworks
- **Problemas:** Requiere que el objeto exista en el Model
- **Mejoras:** Usar form:errors para validación

**🔍 HTML generado:**
```html
<!-- <form:form> genera: -->
<form action="/admin/productos/guardar" method="post">
    <input name="nombreProducto" type="text" value=""/>
</form>
```

---

**35. ¿Qué sucede con `<form:errors path="*" cssClass="error" />`?**

**📄 Código:**
```jsp
<form:errors path="*" cssClass="error" />
<form:errors path="nombreProducto" cssClass="error" />
```

**✅ Respuesta:**
- **Qué hace:** Muestra mensajes de error de validación para los campos del formulario
- **Cómo funciona:** Spring busca errores en BindingResult y los muestra
- **Por qué:** Para dar feedback al usuario sobre errores de validación
- **Alternativas:** Manejo manual de errores, JavaScript validation
- **Problemas:** Si no hay errores, no muestra nada
- **Mejoras:** Personalizar mensajes con MessageSource

**🔍 BindingResult y errores:**
```java
// Spring almacena errores en BindingResult:
if (result.hasErrors()) {
    // Agrega errores al Model para mostrar en JSP
    model.addAttribute("org.springframework.validation.BindingResult.producto", result);
}
```

---

### 🎯 **Includes y Layouts**

**36. ¿Qué hace `<%@ include file="header.jsp" %>`?**

**📄 Código:**
```jsp
<%@ include file="header.jsp" %>
<%@ include file="navbar.jsp" %>
```

**✅ Respuesta:**
- **Qué hace:** Incluye el contenido del archivo especificado en tiempo de compilación
- **Cómo funciona:** El contenedor JSP copia el contenido del archivo incluido directamente en la página
- **Por qué:** Para reutilizar componentes comunes
- **Alternativas:** <jsp:include>, Tag files
- **Problemas:** Si el archivo no existe, error de compilación
- **Mejoras:** Usar <jsp:include> para includes dinámicos

**🔍 Diferencia include types:**
```jsp
<%@ include file="header.jsp" %>    <!-- Include estático (compilación) -->
<jsp:include page="header.jsp" />   <!-- Include dinámico (runtime) -->
```

---

**37. ¿Qué significa `<c:url value="/admin/productos" var="productosUrl" />`?**

**📄 Código:**
```jsp
<c:url value="/admin/productos" var="productosUrl" />
<a href="${productosUrl}">Productos</a>
```

**✅ Respuesta:**
- **Qué hace:** Genera una URL completa incluyendo el context path de la aplicación
- **Cómo funciona:** JSTL toma el context path y lo concatena con la URL relativa
- **Por qué:** Para que las URLs funcionen sin importar dónde está desplegada la app
- **Alternativas:** URL hardcoded, pageContext.request.contextPath
- **Problemas:** Si el context path cambia, las URLs rotas
- **Mejoras:** Usar siempre c:url para URLs relativas

**🔍 URL generada:**
```jsp
<!-- Si la app está en /tienda-deportiva: -->
<c:url value="/admin/productos" var="productosUrl" />
<!-- Genera: /tienda-deportiva/admin/productos -->
<a href="/tienda-deportiva/admin/productos">Productos</a>
```

---

## Frontend - JavaScript

### 🎯 **Chart.js Integration**

**38. ¿Qué hace `const ventasPorMes = ${ventasPorMesJson};` exactamente?**

**📄 Código:**
```jsp
<script>
    const ventasPorMes = ${ventasPorMesJson};
    const pedidosPorMes = ${pedidosPorMesJson};
</script>
```

**✅ Respuesta:**
- **Qué hace:** Spring convierte el objeto Java a JSON y lo incrusta directamente en el JavaScript
- **Cómo funciona:** ObjectMapper serializa el objeto y Spring lo imprime en el HTML
- **Por qué:** Para pasar datos estructurados del backend al frontend
- **Alternativas:** AJAX calls, REST API endpoints
- **Problemas:** Si el JSON tiene comillas, puede romper el JavaScript
- **Mejoras:** Usar JSON.stringify con escape proper

**🔍 HTML generado:**
```html
<script>
    const ventasPorMes = [100, 150, 200, 180];
    const pedidosPorMes = [10, 15, 20, 18];
</script>
```

---

**39. ¿Qué sucede cuando se ejecuta `new Chart(ctx, {...})`?**

**📄 Código:**
```javascript
const ctx = document.getElementById('ventasChart').getContext('2d');
new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['Enero', 'Febrero', 'Marzo'],
        datasets: [{
            label: 'Ventas',
            data: ventasPorMes,
```

**✅ Respuesta:**
- **Qué hace:** Crea una instancia de Chart.js que dibuja un gráfico en el canvas
- **Cómo funciona:** Chart.js usa Canvas API para dibujar el gráfico pixel por pixel
- **Por qué:** Para visualizar datos de forma interactiva
- **Alternativas:** D3.js, Google Charts, CSS charts
- **Problemas:** Con muchos datos, puede ser lento
- **Mejoras:** Usar datasets más pequeños, lazy loading

**🔍 Canvas API:**
```javascript
// Chart.js internamente usa:
const canvas = document.getElementById('ventasChart');
const ctx = canvas.getContext('2d');
ctx.fillStyle = 'rgba(54, 162, 235, 0.2)';
ctx.fillRect(x, y, width, height); // Dibuja cada barra
```

---

**40. ¿Qué significa `data: ventasPorMes`?**

**📄 Código:**
```javascript
data: {
    labels: meses,
    datasets: [{
        data: ventasPorMes,
        backgroundColor: 'rgba(54, 162, 235, 0.2)',
```

**✅ Respuesta:**
- **Qué hace:** Asigna el array de datos al dataset para que Chart.js lo grafique
- **Cómo funciona:** Chart.js itera sobre el array y dibuja un elemento por cada valor
- **Por qué:** Para conectar los datos del backend con la visualización
- **Alternativas:** Datos hardcoded, API calls
- **Problemas:** Si ventasPorMes cambia después, el gráfico no se actualiza
- **Mejoras:** Usar chart.update() para actualizaciones

**🔍 Chart.js y datos:**
```javascript
// Chart.js copia el array:
const dataset = {
    data: [...ventasPorMes], // Copia el array
    // Si ventasPorMes cambia después, el gráfico no se afecta
};
```

---

### 🎯 **DOM Manipulation**

**41. ¿Qué hace `document.getElementById('total')` internamente?**

**📄 Código:**
```javascript
document.getElementById('total').textContent = '$' + total.toFixed(2);
```

**✅ Respuesta:**
- **Qué hace:** Busca en el DOM un elemento con id="total" y actualiza su contenido
- **Cómo funciona:** El browser recorre el árbol DOM hasta encontrar el elemento
- **Por qué:** Para actualizar dinámicamente el contenido sin recargar la página
- **Alternativas:** querySelector, jQuery
- **Problemas:** Si el elemento no existe, lanza TypeError
- **Mejoras:** Validar que exista antes de usarlo

**🔍 DOM traversal:**
```javascript
// getElementById internamente:
document.getElementById = function(id) {
    // Recorre el árbol DOM buscando elemento con id específico
    // O(n) donde n es el número de elementos
    return this._getElementById(id);
};
```

---

**42. ¿Qué sucede cuando se ejecuta `addEventListener('click', function() {...})`?**

**📄 Código:**
```javascript
document.querySelector('.btn-agregar').addEventListener('click', function() {
    const cantidad = parseInt(document.getElementById('cantidad').value);
```

**✅ Respuesta:**
- **Qué hace:** Registra una función que se ejecutará cada vez que se haga click en el elemento
- **Cómo funciona:** El browser guarda el listener en una lista y lo ejecuta en eventos
- **Por qué:** Para hacer la página interactiva sin recargar
- **Alternativas:** onclick attribute, jQuery
- **Problemas:** Si no se remueven, pueden causar memory leaks
- **Mejoras:** Usar event delegation para elementos dinámicos

**🔍 Event system:**
```javascript
// Browser internamente:
element.addEventListener = function(type, listener, options) {
    // Agrega listener a la lista de eventos del elemento
    this._eventListeners[type].push(listener);
};
```

---

**43. ¿Qué hace `parseFloat(document.getElementById('precio').value)`?**

**📄 Código:**
```javascript
const precio = parseFloat(document.getElementById('precio').value);
const subtotal = cantidad * precio;
```

**✅ Respuesta:**
- **Qué hace:** Convierte el string del input a número decimal para cálculos
- **Cómo funciona:** parseFloat analiza el string y retorna un Number o NaN
- **Por qué:** Los inputs siempre retornan strings, se necesita conversión para matemáticas
- **Alternativas:** Number(), parseInt para enteros
- **Problemas:** Si el valor no es numérico, retorna NaN
- **Mejoras:** Validar con isNaN() antes de usar

**🔍 Conversión de tipos:**
```javascript
// parseFloat comportamiento:
parseFloat("123.45")  // 123.45
parseFloat("123")     // 123
parseFloat("abc")     // NaN
parseFloat("")        // NaN
parseFloat("123abc")  // 123
```

---

## Configuración y Arquitectura

### 🎯 **Spring Boot Configuration**

**44. ¿Qué hace `@SpringBootApplication` internamente?**

**📄 Código:**
```java
@SpringBootApplication
public class TiendaDeportivaApplication {
    public static void main(String[] args) {
        SpringApplication.run(TiendaDeportivaApplication.class, args);
    }
}
```

**✅ Respuesta:**
- **Qué hace:** Combina 3 anotaciones: @Configuration, @EnableAutoConfiguration, @ComponentScan
- **Cómo funciona:** Spring escanea paquetes, configura beans automáticamente, y habilita autoconfiguración
- **Por qué:** Para reducir boilerplate y configuración manual
- **Alternativas:** Configuración XML, anotaciones separadas
- **Problemas:** Autoconfiguración puede configurar cosas no deseadas
- **Mejoras:** Usar @SpringBootApplication(exclude = ...) para excluir autoconfiguración

**🔍 @SpringBootApplication =:**
```java
// Es equivalente a:
@Configuration
@EnableAutoConfiguration
@ComponentScan
public class TiendaDeportivaApplication {
```

---

**45. ¿Qué sucede cuando se ejecuta `SpringApplication.run()`?**

**📄 Código:**
```java
SpringApplication.run(TiendaDeportivaApplication.class, args);
```

**✅ Respuesta:**
- **Qué hace:** Inicia el contexto de Spring, configura el entorno, y levanta el servidor web
- **Cómo funciona:** Crea ApplicationContext, registra beans, configura Tomcat embebido
- **Por qué:** Para iniciar la aplicación web
- **Alternativas:** Configuración manual de servlet container
- **Problemas:** Si hay errores en configuración, falla al iniciar
- **Mejoras:** Usar profiles para diferentes entornos

**🔍 Flujo de inicio:**
```java
// SpringApplication.run() internamente:
1. Prepara el entorno (Environment)
2. Imprime banner
3. Crea ApplicationContext
4. Registra beans (@Component, @Service, etc.)
5. Configura autoconfiguración
6. Inicia web server (Tomcat)
7. Publica contexto
8. Aplicación lista para recibir peticiones
```

---

**46. ¿Qué significa `spring.datasource.url=jdbc:h2:file:./data/tienda`?**

**📄 Código:**
```properties
spring.datasource.url=jdbc:h2:file:./data/tienda
spring.datasource.username=sa
spring.datasource.password=
```

**✅ Respuesta:**
- **Qué hace:** Configura la conexión a base de datos H2 en modo archivo
- **Cómo funciona:** Spring Boot usa estas propiedades para crear DataSource y JdbcTemplate
- **Por qué:** Para conectar la aplicación con la base de datos
- **Alternativas:** JNDI, configuración programática
- **Problemas:** Si la carpeta data no existe, H2 la crea automáticamente
- **Mejoras:** Usar paths absolutos en producción

**🔍 DataSource creation:**
```java
// Spring Boot crea:
DataSource dataSource = DataSourceBuilder.create()
    .url("jdbc:h2:file:./data/tienda")
    .username("sa")
    .password("")
    .driverClassName("org.h2.Driver")
    .build();
```

---

**47. ¿Qué hace `spring.jpa.hibernate.ddl-auto=update`?**

**📄 Código:**
```properties
spring.jpa.hibernate.ddl-auto=update
spring.sql.init.mode=always
```

**✅ Respuesta:**
- **Qué hace:** Hibernate actualiza el esquema de BD automáticamente cuando cambia
- **Cómo funciona:** Compara las entidades con la BD y genera ALTER TABLEs necesarios
- **Por qué:** Para sincronizar el modelo de datos con la base de datos
- **Alternativas:** validate, create, create-drop, none
- **Problemas:** En producción puede ser peligroso si hace cambios inesperados
- **Mejoras:** Usar Flyway o Liquibase para control de versiones

**🔍 Hibernate DDL:**
```java
// Hibernate internamente:
DatabaseMetaData metaData = connection.getMetaData();
// Compara entidades con tablas existentes
// Genera ALTER TABLE si hay diferencias
// Ejecuta los cambios automáticamente
```

---

### 🎯 **MVC Configuration**

**48. ¿Qué significa `spring.mvc.view.prefix=/WEB-INF/views/`?**

**📄 Código:**
```properties
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

**✅ Respuesta:**
- **Qué hace:** Configura el resolvedor de vistas para buscar JSPs en /WEB-INF/views/
- **Cómo funciona:** Spring concatena prefijo + nombre de vista + sufijo
- **Por qué:** Para no tener que escribir rutas completas en los controllers
- **Alternativas:** XmlViewResolver, UrlBasedViewResolver manual
- **Problemas:** Si el JSP no existe, lanza 404
- **Mejoras:** Usar tiles o thymeleaf para layouts

**🔍 Resolución de vistas:**
```java
// "adminboletas" se resuelve a:
String viewName = "adminboletas";
String resolvedPath = prefix + viewName + suffix;
// "/WEB-INF/views/adminboletas.jsp"
```

---

**49. ¿Qué hace `InternalResourceViewResolver` internamente?**

**📄 Código:**
```java
// Spring Boot crea automáticamente
InternalResourceViewResolver resolver = new InternalResourceViewResolver();
resolver.setPrefix("/WEB-INF/views/");
resolver.setSuffix(".jsp");
```

**✅ Respuesta:**
- **Qué hace:** Resuelve nombres lógicos de vistas a paths físicos de JSPs
- **Cómo funciona:** Usa RequestDispatcher.forward() para entregar la vista
- **Por qué:** Para separar la lógica de la presentación
- **Alternativas:** UrlBasedViewResolver, ResourceBundleViewResolver
- **Problemas:** No puede resolver vistas fuera de /WEB-INF/
- **Mejoras:** Configurar múltiples resolvers

**🔍 Forward vs Redirect:**
```java
// Forward (interno):
request.getRequestDispatcher("/WEB-INF/views/adminboletas.jsp").forward(request, response);
// URL no cambia en el browser

// Redirect (externo):
response.sendRedirect("/admin/boletas");
// URL cambia en el browser
```

---

### 🎯 **Database Configuration**

**50. ¿Qué significa `spring.sql.init.mode=always`?**

**📄 Código:**
```properties
spring.sql.init.mode=always
spring.sql.init.schema-locations=classpath:schema.sql
spring.sql.init.data-locations=classpath:data.sql
```

**✅ Respuesta:**
- **Qué hace:** Spring ejecuta schema.sql y data.sql cada vez que inicia la aplicación
- **Cómo funciona:** ResourceDatabasePopulator lee y ejecuta los scripts SQL
- **Por qué:** Para inicializar la base de datos con estructura y datos de prueba
- **Alternativas:** never, embedded, conditional
- **Problemas:** En producción sobrescribe datos existentes
- **Mejoras:** Usar profiles para diferenciar ambientes

**🔍 Script execution:**
```java
// Spring internamente:
ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
populator.addScript(new ClassPathResource("schema.sql"));
populator.addScript(new ClassPathResource("data.sql"));
populator.populate(dataSource); // Ejecuta scripts en orden
```

---

**51. ¿Qué sucede con el pool de conexiones HikariCP?**

**📄 Código:**
```java
// Spring Boot usa HikariCP por defecto
```

**✅ Respuesta:**
- **Qué hace:** Mantiene un pool de conexiones a BD para reutilizarlas
- **Cómo funciona:** HikariCP crea N conexiones y las presta cuando se necesitan
- **Por qué:** Para evitar el overhead de crear conexiones por cada query
- **Alternativas:** Tomcat JDBC, C3P0, DBCP2
- **Problemas:** Si el pool se agota, las peticiones esperan
- **Mejoras:** Configurar pool size según carga esperada

**🔍 HikariCP pool:**
```java
// HikariCP internamente:
public class HikariPool {
    private final ConcurrentBag<HikariProxyConnection> connectionBag;
    
    public Connection getConnection() throws SQLException {
        // 1. Toma conexión del pool
        // 2. Si no hay disponibles, espera timeout
        // 3. Si timeout, lanza SQLException
        // 4. Devuelve conexión proxy
    }
}
```

---

## 🎯 **Preguntas Finales de Examen UTP**

**66. ¿Qué hace Spring cuando inicia la aplicación?**

**✅ Respuesta completa:**
1. **Carga @SpringBootApplication** - Combina @Configuration, @EnableAutoConfiguration, @ComponentScan
2. **Escanea paquetes** - Busca @Component, @Service, @Repository, @Controller
3. **Crea ApplicationContext** - Contenedor de IoC que maneja todos los beans
4. **Configura DataSource** - Crea pool de conexiones HikariCP
5. **Registra JdbcTemplate** - Para acceso a datos JDBC
6. **Configura MVC** - InternalResourceViewResolver para JSPs
7. **Inicia Tomcat** - Servidor web embebido en puerto 8080
8. **Ejecuta init scripts** - schema.sql y data.sql si mode=always
9. **Publica contexto** - Aplicación lista para recibir peticiones HTTP

**🔍 Orden exacto:**
```java
// 1. SpringApplication.run() inicia
// 2. Environment preparation
// 3. ApplicationContext creation
// 4. Bean definition loading
// 5. Bean instantiation and wiring
// 6. Auto-configuration
// 7. Web server start
// 8. Application ready
```

---

**67. ¿Cuál es el ciclo de vida completo de una petición HTTP?**

**✅ Respuesta completa:**
1. **Browser envía HTTP request** - GET /admin/boletas
2. **Tomcat recibe la petición** - En el puerto 8080
3. **DispatcherServlet la recibe** - Front controller de Spring MVC
4. **HandlerMapping encuentra controller** - Mapea URL a AdminBoletasController.listar()
5. **Controller ejecuta lógica** - Llama a boletaService.listarTodas()
6. **Service llama a DAO** - boletaDAO.findAll()
7. **DAO ejecuta SQL** - SELECT * FROM Boletas
8. **ResultSet mapea a objetos** - BoletaRowMapper crea objetos Boleta
9. **Controller agrega al Model** - model.addAttribute("boletas", lista)
10. **ViewResolver resuelve vista** - "adminboletas" → "/WEB-INF/views/adminboletas.jsp"
11. **JSP se compila y ejecuta** - Genera HTML con los datos
12. **Response se envía al browser** - HTTP 200 con HTML

**🔍 Threads involucrados:**
```java
// Tomcat thread pool (por defecto 200 threads):
// Cada petición usa un thread del pool
// Thread 1: GET /admin/boletas → AdminBoletasController.listar()
// Thread 2: GET /admin/productos → AdminProductosController.listar()
// Threads son reutilizados para siguientes peticiones
```

---

**68. ¿Qué sucede cuando se guarda una boleta con detalles?**

**✅ Respuesta completa:**
1. **Frontend envía POST** - Formulario con datos de boleta
2. **Controller recibe @ModelAttribute** - Spring mapea formulario a Boleta
3. **Controller llama a service** - boletaService.guardar(boleta)
4. **Service valida datos** - ID usuario > 0, total >= 0
5. **Service llama a DAO** - boletaDAO.save(boleta)
6. **DAO ejecuta INSERT** - INSERT INTO Boletas VALUES(...)
7. **DAO obtiene generated key** - KeyHolder captura ID generado
8. **Controller redirige a detalles** - redirect:/admin/boletas/123
9. **Controller de detalles carga** - detalleBoletaService.listarPorBoleta(123)
10. **DAO ejecuta JOIN** - SELECT db.*, p.nombre FROM DetalleBoletas db JOIN Productos p...
11. **JSP muestra formulario** - Con boleta y detalles para agregar más

**🔍 Queries ejecutados:**
```sql
-- 1. Insertar boleta principal
INSERT INTO Boletas (id_usuario, fecha_emision, total) VALUES (?, ?, ?);

-- 2. Obtener ID generado (H2)
CALL IDENTITY();

-- 3. Cargar detalles con JOIN
SELECT db.*, p.nombre_producto 
FROM DetalleBoletas db 
JOIN Productos p ON db.id_producto = p.id_producto 
WHERE db.id_boleta = ?;
```

---

**69. ¿Cómo funciona la integración entre JSP y Spring?**

**✅ Respuesta completa:**
1. **Controller pone datos en Model** - model.addAttribute("boletas", lista)
2. **Spring almacena en request** - request.setAttribute("boletas", lista)
3. **JSP accede con EL** - ${boletas} busca en pageContext.findAttribute()
4. **JSTL itera sobre colección** - <c:forEach> crea variable por cada elemento
5. **EL llama getters automáticamente** - ${boleta.id_boleta} → getId_boleta()
6. **Spring Form tags genera HTML** - <form:form> vincula con backend
7. **Validación errors en BindingResult** - form:errors muestra errores
8. **URLs con context path** - c:url agrega /tienda-deportiva automáticamente

**🔍 Flujo de datos:**
```java
// Controller → Model → Request → JSP → EL → HTML
model.addAttribute("producto", producto);
request.setAttribute("producto", producto);
// En JSP:
${producto.nombre} // EL llama getNombre()
```

---

**70. ¿Cuál es el flujo completo de un error en la aplicación?**

**✅ Respuesta completa:**
1. **Ocurre excepción** - SQLException en DAO
2. **Service no la captura** - Se propaga hacia arriba
3. **Controller no la captura** - Sigue propagando
4. **DispatcherServlet la captura** - Manejo centralizado de errores
5. **Spring busca @ExceptionHandler** - Busca método anotado en controllers
6. **Si no encuentra, usa DefaultHandlerExceptionResolver** - Convierte a HTTP status
7. **Genera página de error** - error.jsp o Whitelabel Error Page
8. **Envía response con error** - HTTP 500 Internal Server Error
9. **Browser muestra error** - Página de error del browser o de la app

**🔍 Manejo personalizado:**
```java
@ExceptionHandler(SQLException.class)
public String handleDatabaseError(SQLException ex, Model model) {
    model.addAttribute("error", "Error en base de datos: " + ex.getMessage());
    return "error";
}
```

---

## 🚀 **Preguntas Bonus - Optimización Extrema**

**71. ¿Cuánta memoria usa la aplicación con 1000 usuarios concurrentes?**

**✅ Respuesta completa:**
- **Por usuario:** ~50KB (request + session + objetos temporales)
- **Total:** 1000 × 50KB = 50MB solo por usuarios
- **Objects creados por petición:**
  - HttpServletRequest: ~2KB
  - HttpSession: ~5KB
  - Model/ModelMap: ~1KB
  - ArrayList de boletas: ~10KB (100 boletas × 100 bytes)
  - DTOs y objetos temporales: ~32KB
- **Heap total necesario:** ~200MB (50MB usuarios + 100MB app + 50MB buffer)
- **Configuración JVM recomendada:** `-Xms256m -Xmx512m`

**🔍 Cálculo detallado:**
```java
// Memoria por request:
// - HttpServletRequest: 2048 bytes
// - Model con 100 boletas: 100 × 200 = 20KB
// - ArrayList overhead: 100 × 8 = 800 bytes
// - String objects: ~10KB
// Total por request: ~32KB

// Con 1000 concurrentes:
// 1000 × 32KB = 32MB solo en requests
// + Session data: 1000 × 5KB = 5MB
// + Application objects: ~100MB
// + JVM overhead: ~50MB
// Total: ~187MB
```

---

**72. ¿Qué pasa si la base de datos se cae a mitad de una operación?**

**✅ Respuesta completa:**
1. **Conexión se pierde** - Socket connection reset
2. **Próxima operación lanza SQLException** - Connection is closed
3. **HikariCP detecta conexión muerta** - Remueve del pool
4. **@Transactional hace rollback** - Si está activa la transacción
5. **Spring lanza DataAccessException** - Envuelve la SQLException original
6. **Controller puede manejar el error** - Mostrar mensaje amigable
7. **HikariCP intenta reconectar** - Según configuración de retry
8. **Aplicación sigue funcionando** - Con conexiones nuevas del pool

**🔍 Código de manejo:**
```java
@Transactional
public void guardarBoleta(Boleta boleta) {
    try {
        boletaDAO.save(boleta);
        // Si BD cae aquí, Spring hace rollback automático
    } catch (DataAccessException ex) {
        // Spring convierte SQLException a DataAccessException
        // Transacción se marca para rollback
        throw new RuntimeException("Error de base de datos", ex);
    }
}
```

---

**73. ¿Cuál es el límite de escalabilidad de esta arquitectura?**

**✅ Respuesta completa:**
- **Peticiones por segundo:** ~500-1000 (depende de hardware)
- **Cuello de botella #1:** Base de datos (conexiones simultáneas)
- **Cuello de botella #2:** Memoria heap (OutOfMemoryError)
- **Cuello de botella #3:** CPU (procesamiento de JSON/JSP)
- **Usuarios concurrentes:** ~1000-2000 antes de degradación
- **Distribución de carga:**
  - **Vertical:** Más CPU, RAM, disco SSD
  - **Horizontal:** Load balancer + múltiples instancias
  - **Base de datos:** Read replicas, sharding

**🔍 Métricas de rendimiento:**
```java
// Con configuración por defecto:
// - Tomcat threads: 200
// - HikariCP pool: 10 conexiones
// - Heap: 512MB
// Límite teórico: 200 peticiones simultáneas
// Realista: 100 peticiones/segundo sostenidas
```

---

**74. ¿Qué sucede con el garbage collector de Java?**

**✅ Respuesta completa:**
- **Cuándo se ejecutan:** Cuando heap está lleno (Young Generation) o periódicamente (Old Generation)
- **Objetos candidatos:** Objetos sin referencias (request finalizado, variables locales)
- **Tipos de GC:** G1GC (por defecto), Serial, Parallel, ZGC
- **Impacto en rendimiento:** Pauses de 10-100ms durante GC
- **Objetos por petición:** Request, Model, DTOs, Strings temporales
- **Optimización:** Usar objetos pequeños, evitar crear muchos objetos temporales

**🔍 Generaciones de memoria:**
```java
// Heap structure:
// Young Generation (Eden + S0 + S1): ~100MB
// - Objetos nuevos van a Eden
// - GC menor copia survivors a S0/S1
// Old Generation: ~400MB
// - Objetos long-lived van aquí
// - GC mayor es más lento
// Metaspace: ~64MB
// - Class metadata
```

---

**75. ¿Cómo se puede hacer esta aplicación más rápida?**

**✅ Respuesta completa:**

**🎯 Punto lento #1: Queries N+1**
```java
// Problema:
List<Boleta> boletas = boletaDAO.findAll(); // 1 query
for (Boleta b : boletas) {
    List<DetalleBoleta> detalles = detalleDAO.findByBoleta(b.getId()); // N queries
}
// Total: 1 + N queries

// Solución:
List<BoletaConDetalles> boletas = boletaDAO.findAllWithDetalles(); // 1 query con JOIN
```

**🎯 Punto lento #2: Cargar todos los productos**
```java
// Problema:
model.addAttribute("productos", productoService.listarTodos()); // 1000 productos

// Solución:
model.addAttribute("productos", productoService.listarActivos()); // Solo necesarios
// O paginar: productoService.listarPagina(0, 20);
```

**🎯 Punto lento #3: Generar JSON en cada petición**
```java
// Problema:
String ventasPorMesJson = objectMapper.writeValueAsString(ventasPorMes);

// Solución:
@Cacheable("ventasPorMes")
public String getVentasPorMesJson() {
    return objectMapper.writeValueAsString(calcularVentasPorMes());
}
```

**🔥 Mejoras específicas:**
1. **Add caching** - @Cacheable para datos que no cambian
2. **Database connection pool** - Aumentar a 20-30 conexiones
3. **Lazy loading** - Cargar datos solo cuando se necesitan
4. **Pagination** - No cargar todos los registros
5. **Compress responses** - GZIP compression
6. **Static assets CDN** - CSS, JS, imágenes
7. **Database indexes** - En campos usados en WHERE

**📊 Medición de mejora:**
```java
// Antes: 2.5 segundos por página
// Después: 0.8 segundos por página
// Mejora: 68% más rápido
```

---

## 🎯 **Resumen de Respuestas**

Para cada pregunta, el estudiante debe demostrar entendimiento de:

1. **El qué** - Funcionalidad exacta del código
2. **El cómo** - Mecanismos internos de Spring/Java
3. **El por qué** - Razones de diseño y arquitectura
4. **Alternativas** - Otras formas de implementar
5. **Problemas** - Casos edge y posibles fallos
6. **Mejoras** - Optimizaciones y mejores prácticas

¡Estas respuestas cubren el entendimiento profundo del código y obligan a conocer realmente lo que está pasando debajo del capó! 🎓
