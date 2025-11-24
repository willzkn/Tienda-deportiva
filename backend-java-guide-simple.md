# Guía Sencilla del Backend Java

Esta es una explicación simple de cada archivo Java en tu proyecto, como si empezaras a programar en Java.

---

## 🚀 Archivos Principales

### `DemoApplication.java`
Es el **arrancador** de tu aplicación.
- `@SpringBootApplication`: Le dice a Spring "esto es una aplicación web"
- `main()`: El método que inicia todo
- `StandardServletMultipartResolver`: Permite que los usuarios suban archivos (como imágenes de productos)

### `WebConfig.java`
Configura las rutas de archivos estáticos.
- Le dice a Spring dónde encontrar los archivos CSS, JS, imágenes
- Por ejemplo: `/css/style.css` busca en `src/main/resources/static/css/`

---

## 🎮 Controllers (Los que manejan las páginas web)

### ¿Qué es un Controller?
Es como el **recepcionista** de tu sitio web:
- Recibe las peticiones de los usuarios (cuando hacen clic en un enlace)
- Decide qué página mostrar
- Prepara los datos para esa página

### `HomeController.java`
Maneja las páginas públicas:
- `@Controller`: "Este es un controlador"
- `@GetMapping("/")`: Cuando alguien visita la página principal
- `@GetMapping("/productos")`: Cuando alguien ve los productos
- `Model`: Es como una bandeja donde pones los datos para la página

### `AdminController.java`
Maneja el panel de administración:
- `@RequestMapping("/admin")`: Todas las rutas empiezan con `/admin`
- Maneja el login de admin
- Muestra reportes y estadísticas

### `AdminBoletasController.java`
Maneja las boletas (facturas):
- `@GetMapping("/admin/boletas")`: Muestra todas las boletas
- `@PostMapping`: Guarda cambios cuando envías un formulario
- `@PathVariable`: Obtiene valores de la URL (como `/editar/5` donde 5 es el ID)

### Otros Controllers similares:
- `AdminCategoriasController`: Para gestionar categorías
- `AdminClientesController`: Para gestionar usuarios
- `CarritoController`: Para mostrar el carrito de compras

---

## 🧠 Services (Los que hacen la lógica)

### ¿Qué es un Service?
Es como el **cerebro** de tu aplicación:
- Contiene las reglas de negocio
- Decide qué hacer con los datos
- Se comunica con la base de datos

### `ProductoServiceImpl.java`
Maneja todo lo relacionado con productos:
- `@Service`: "Este es un servicio"
- `guardarProducto()`: Guarda un producto nuevo
- `actualizarProducto()`: Modifica un producto existente
- Maneja las imágenes (las convierte a bytes para guardarlas)

### Otros Services:
- `BoletaServiceImpl`: Para las boletas/facturas
- `CategoriaServiceImpl`: Para las categorías
- `UsuarioAdminServiceImpl`: Para los usuarios administradores

### `ConsultaDataSource.java`
Es una forma **alternativa** de hablar con la base de datos:
- Usa JDBC puro (más manual que JdbcTemplate)
- `Connection`: Conexión a la base de datos
- `PreparedStatement`: Consulta SQL segura (evita ataques)
- `ResultSet`: Los resultados de una consulta

---

## 🗄️ Repositories (Los que hablan con la base de datos)

### ¿Qué es un Repository/DAO?
Es como el **bibliotecario** de tu base de datos:
- Saben exactamente dónde está cada dato
- Saben cómo guardar, buscar, actualizar o eliminar
- Traducen objetos Java a filas de la base de datos

### Interfaces (Los contratos)
Como `BoletaDAO.java`, `ProductoDAO.java`:
- Son como **contratos** que dicen "esto es lo que sé hacer"
- Métodos comunes: `findAll()`, `findById()`, `save()`, `update()`, `deleteById()`

### Implementaciones (Los que hacen el trabajo)
Como `JdbcBoletaRepository.java`:
- `@Repository`: "Este es un repositorio"
- `JdbcTemplate`: Una herramienta de Spring que facilita el trabajo con bases de datos

---

## 📊 Operaciones con Base de Datos (JdbcTemplate)

### `jdbcTemplate.query()` - Para LEER datos
```java
// Obtener muchos productos
List<Producto> productos = jdbcTemplate.query(
    "SELECT * FROM Productos", 
    rowMapper  // Convierte filas a objetos
);
```

### `jdbcTemplate.queryForObject()` - Para LEER un solo dato
```java
// Obtener un producto por ID
Producto producto = jdbcTemplate.queryForObject(
    "SELECT * FROM Productos WHERE id = ?", 
    rowMapper, 
    id  // Parámetro seguro
);
```

### `jdbcTemplate.update()` - Para MODIFICAR datos
```java
// Insertar un producto nuevo
jdbcTemplate.update(
    "INSERT INTO Productos (nombre, precio) VALUES (?, ?)",
    nombre,  // Parámetro 1
    precio   // Parámetro 2
);
```

### RowMapper - El traductor
```java
private final RowMapper<Producto> rowMapper = (rs, rowNum) -> {
    Producto p = new Producto();
    p.setId(rs.getInt("id"));           // Convierte INT a int
    p.setNombre(rs.getString("nombre")); // Convierte VARCHAR a String
    p.setPrecio(rs.getDouble("precio"));  // Convierte DECIMAL a double
    return p;
};
```
- **rs**: ResultSet = los datos de una fila de la base de datos
- **Convierte**: Tipos de SQL a tipos de Java

---

## 📦 Models (Las cosas que guardas)

### ¿Qué es un Model?
Es como una **caja** para guardar datos:
- Representa una tabla de la base de datos
- Tiene propiedades (campos) y métodos (getters/setters)

### `Producto.java`
```java
public class Producto {
    private int id_producto;        // ID del producto
    private String nombre;          // Nombre del producto
    private String sku;             // Código del producto
    private double precio;          // Precio
    private int stock;              // Cantidad disponible
    private byte[] imagen;          // Imagen en bytes
    
    // Getters y Setters...
    
    public String getImagenBase64() {
        // Método especial para mostrar imagen en HTML
        return Base64.getEncoder().encodeToString(imagen);
    }
}
```

### Otros Models:
- `Boleta.java`: Para las facturas/boletas
- `Categoria.java`: Para las categorías de productos
- `UsuarioAdmin.java`: Para los usuarios administradores
- `DetalleBoleta.java`: Para los detalles de cada boleta

---

## 🔧 Anotaciones Importantes (Las @)

| Anotación | Significado | Dónde usarla |
|-----------|-------------|--------------|
| `@Controller` | "Esto maneja páginas web" | En clases que gestionan peticiones HTTP |
| `@Service` | "Esto tiene lógica de negocio" | En clases con reglas del negocio |
| `@Repository` | "Esto habla con la base de datos" | En clases que acceden a datos |
| `@Autowired` | "Inyecta esta dependencia" | Para usar otros componentes |
| `@GetMapping` | "Responde a peticiones GET" | En métodos de controllers |
| `@PostMapping` | "Responde a peticiones POST" | En métodos que reciben formularios |
| `@RequestParam` | "Toma este parámetro de la URL" | En parámetros de métodos |

---

## 🔄 ¿Cómo funciona todo junto?

1. **Usuario** hace clic en "Ver Productos"
2. **Controller** (`HomeController`) recibe la petición
3. **Controller** llama al **Service** (`ProductoService`)
4. **Service** llama al **Repository** (`ProductoDAO`)
5. **Repository** ejecuta SQL con **JdbcTemplate**
6. **RowMapper** convierte los resultados a objetos `Producto`
7. **Service** devuelve la lista de productos
8. **Controller** pone los productos en el `Model`
9. **Controller** dice "muestra la página productos.jsp"
10. **JSP** muestra los productos usando los datos

---

## 💡 Consejos para Principiantes

1. **Los nombres importan**: Un controller se llama `XxxController`, un service `XxxService`
2. **Cada cosa en su lugar**: Controllers no hablan directamente con la base de datos
3. **Usa @Autowired**: Deja que Spring gestione las dependencias
4. **PreparedStatement siempre**: Nunita concatenes SQL directamente (es inseguro)
5. **Los Models son simples**: Solo datos, getters y setters

---

## 🎯 Resumen por Archivo

| Tipo | Archivo | ¿Qué hace? |
|------|---------|------------|
| **Aplicación** | `DemoApplication` | Arranca todo |
| **Config** | `WebConfig` | Configura rutas estáticas |
| **Controllers** | `HomeController` | Páginas públicas |
| | `AdminController` | Panel de admin |
| | `AdminBoletasController` | Gestiona boletas |
| | `AdminCategoriasController` | Gestiona categorías |
| | `AdminClientesController` | Gestiona usuarios |
| | `CarritoController` | Muestra carrito |
| **Services** | `ProductoServiceImpl` | Lógica de productos |
| | `BoletaServiceImpl` | Lógica de boletas |
| | `CategoriaServiceImpl` | Lógica de categorías |
| | `UsuarioAdminServiceImpl` | Lógica de usuarios |
| | `ConsultaDataSource` | Acceso a BD manual |
| **Repositories** | `JdbcProductoRepository` | Guarda/lee productos |
| | `JdbcBoletaRepository` | Guarda/lee boletas |
| | `JdbcCategoriaRepository` | Guarda/lee categorías |
| | `JdbcUsuarioAdminRepository` | Guarda/lee usuarios |
| **Models** | `Producto` | Datos de un producto |
| | `Boleta` | Datos de una boleta |
| | `Categoria` | Datos de una categoría |
| | `UsuarioAdmin` | Datos de un usuario |
| | `DetalleBoleta` | Detalles de una boleta |

---

## 📝 En resumen

Tu backend es como una **organización**:
- **Controllers**: Recepcionistas (reciben peticiones)
- **Services**: Cerebros (toman decisiones)
- **Repositories**: Bibliotecarios (gestionan datos)
- **Models**: Cajas (guardan información)
- **Spring**: El gerente que une todo

Cada uno sabe hacer su trabajo y no interfiere en el de los demás. ¡Así se mantiene todo ordenado!
