# 🔍 Análisis Detallado del Backend - Preguntas y Explicaciones

## 📋 Tabla de Contenidos
- [1. Implementación de Repositories (DAO)](#1-implementación-de-repositories-dao)
- [2. Manejo de Transacciones](#2-manejo-de-transacciones)
- [3. Validaciones de Negocio](#3-validaciones-de-negocio)
- [4. Manejo de Errores y Feedback](#4-manejo-de-errores-y-feedback)
- [5. Optimización y Rendimiento](#5-optimización-y-rendimiento)
- [6. Concurrencia y Seguridad](#6-concurrencia-y-seguridad)
- [7. Consistencia y Nomenclatura](#7-consistencia-y-nomenclatura)
- [8. Arquitectura de Carrito](#8-arquitectura-de-carrito)

---

## 1. Implementación de Repositories (DAO)

### 🚨 **Problema Crítico: ¿Dónde están las implementaciones?**

**📄 Fragmento problemático:**
```java
// BoletaDAO.java - Solo es una interfaz
public interface BoletaDAO {
    List<Boleta> findAll();
    Optional<Boleta> findById(int id);
    void save(Boleta boleta);
    void update(Boleta boleta);
    void deleteById(int id);
    void recalcTotal(int idBoleta);
}
```

**❓ Pregunta:** ¿Dónde está la clase que implementa esta interfaz con JdbcTemplate?

**🔍 Explicación:** Spring necesita una clase concreta con `@Repository` que implemente esta interfaz:
```java
// Debería existir algo como esto:
@Repository
public class BoletaDAOImpl implements BoletaDAO {
    private final JdbcTemplate jdbcTemplate;
    
    public BoletaDAOImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    @Override
    public List<Boleta> findAll() {
        String sql = "SELECT * FROM Boletas ORDER BY fecha_emision DESC";
        return jdbcTemplate.query(sql, new BoletaRowMapper());
    }
    
    @Override
    public void recalcTotal(int idBoleta) {
        String sql = """
            UPDATE Boletas 
            SET total = (
                SELECT COALESCE(SUM(cantidad * precio_unitario), 0) 
                FROM DetalleBoletas 
                WHERE id_boleta = ?
            )
            WHERE id_boleta = ?
            """;
        jdbcTemplate.update(sql, idBoleta, idBoleta);
    }
    
    @Override
    public void save(Boleta boleta) {
        String sql = """
            INSERT INTO Boletas (id_usuario, fecha_emision, total) 
            VALUES (?, ?, ?)
            """;
        jdbcTemplate.update(sql, boleta.getId_usuario(), 
                           boleta.getFecha_emision(), boleta.getTotal());
    }
}
```

**⚠️ Problema:** Si no existe esta implementación, la aplicación no podrá iniciar porque Spring no puede inyectar `BoletaDAO`.

**🔍 Búsqueda necesaria:**
```bash
# Buscar implementaciones de DAOs
find . -name "*DAO*Impl*.java"
find . -name "*Repository*.java" | grep -v interface
```

---

## 2. Manejo de Transacciones

### 🚨 **Problema: Operaciones sin Transacciones**

**📄 Fragmento problemático:**
```java
// AdminBoletasController.java
@PostMapping("/{id}/detalle/guardar")
public String guardarDetalle(@PathVariable("id") int idBoleta, 
                            @ModelAttribute DetalleBoleta detalle) {
    detalle.setId_boleta(idBoleta);
    if (detalle.getId_detalle_boleta() == 0) {
        detalleBoletaService.guardar(detalle);      // Operación 1
    } else {
        detalleBoletaService.actualizar(detalle);   // Operación 1
    }
    // Recalcular total de la boleta luego de guardar/actualizar detalle
    boletaService.recalcTotal(idBoleta);            // Operación 2
    return "redirect:/admin/boletas/" + idBoleta;
}
```

**❓ Pregunta:** ¿Qué pasa si `guardarDetalle` funciona pero `recalcTotal` falla?

**🔍 Explicación:** Sin `@Transactional`, si la segunda operación falla, la primera queda persistida:

```java
// Escenario problemático:
// 1. detalleBoletaService.guardar(detalle) ✅ Éxito - Detalle guardado
// 2. boletaService.recalcTotal(idBoleta) ❌ Fallo - Error de SQL
// Resultado: Detalle existe pero total de boleta es incorrecto
```

**✅ Solución recomendada:**
```java
@Service
@Transactional
public class BoletaServiceImpl implements BoletaService {
    
    @Transactional
    public void guardarDetalleYRecalcular(int idBoleta, DetalleBoleta detalle) {
        // Ambas operaciones se ejecutan en una sola transacción
        detalleBoletaService.guardar(detalle);
        boletaService.recalcTotal(idBoleta);
        // Si algo falla, todo se rollback automáticamente
    }
}
```

**⚠️ Impacto:** Sin transacciones, puedes tener datos inconsistentes en producción.

---

## 3. Validaciones de Negocio

### 🚨 **Problema: Falta de Validaciones Críticas**

**📄 Fragmento problemático:**
```java
// AdminBoletasController.java
@PostMapping("/guardar")
public String guardar(@ModelAttribute Boleta boleta) {
    if (boleta.getId_boleta() == 0) {
        boletaService.guardar(boleta);  // ¿Qué pasa si total = 0?
    } else {
        boletaService.actualizar(boleta);
    }
    return "redirect:/admin/boletas";
}
```

**❓ Pregunta:** ¿Dónde se valida que una boleta tenga al menos un detalle?

**🔍 Explicación:** Actualmente puedes guardar boletas sin validaciones:

```java
// Escenarios problemáticos permitidos:
Boleta boleta = new Boleta();
boleta.setId_usuario(1);
boleta.setTotal(0.0);          // ❌ Total puede ser 0
boleta.setFecha_emision(null); // ❌ Fecha puede ser nula
boletaService.guardar(boleta); // ✅ Se guarda sin validar
```

**✅ Solución recomendada:**
```java
@Service
public class BoletaServiceImpl implements BoletaService {
    
    @Override
    public void guardar(Boleta boleta) {
        // Validaciones de negocio
        if (boleta.getId_usuario() <= 0) {
            throw new IllegalArgumentException("ID de usuario inválido");
        }
        
        if (boleta.getTotal() < 0) {
            throw new IllegalArgumentException("El total no puede ser negativo");
        }
        
        if (boleta.getFecha_emision() == null) {
            boleta.setFecha_emision(LocalDateTime.now());
        }
        
        boletaDao.save(boleta);
    }
    
    @Override
    public void guardar(Boleta boleta, List<DetalleBoleta> detalles) {
        // Validación de negocio: boleta debe tener detalles
        if (detalles == null || detalles.isEmpty()) {
            throw new IllegalArgumentException("Una boleta debe tener al menos un detalle");
        }
        
        // Validar stock para cada detalle
        for (DetalleBoleta detalle : detalles) {
            Producto producto = productoService.obtenerPorId(detalle.getId_producto())
                .orElseThrow(() -> new IllegalArgumentException("Producto no encontrado"));
                
            if (producto.getStock() < detalle.getCantidad()) {
                throw new IllegalArgumentException(
                    String.format("Stock insuficiente para %s. Disponible: %d, Solicitado: %d",
                    producto.getNombre(), producto.getStock(), detalle.getCantidad()));
            }
        }
        
        // Guardar boleta y detalles en transacción
        guardarBoletaConDetalles(boleta, detalles);
    }
}
```

**⚠️ Impacto:** Sin validaciones, puedes tener datos corruptos en la base de datos.

---

## 4. Manejo de Errores y Feedback

### 🚨 **Problema: Errores Silenciosos**

**📄 Fragmento problemático:**
```java
// AdminBoletasController.java
@GetMapping("/editar/{id}")
public String editar(@PathVariable("id") int id, Model model) {
    Boleta boleta = obtenerBoleta(id, model);
    if (boleta == null) {
        return redirigirABoletas();  // ❌ Usuario no sabe qué pasó
    }
    cargarListasBoleta(id, model);
    return "adminboleta-editar";
}
```

**❓ Pregunta:** ¿Por qué no hay mensajes de error cuando una boleta no existe?

**🔍 Explicación:** El usuario queda confundido sin saber qué pasó:

```java
// Flujo actual problemático:
// 1. Usuario hace clic en "Editar Boleta #123"
// 2. Sistema redirige a lista de boletas
// 3. Usuario no sabe por qué fue redirigido
// 4. Experiencia de usuario frustrante
```

**✅ Solución recomendada:**
```java
@GetMapping("/editar/{id}")
public String editar(@PathVariable("id") int id, Model model, 
                    RedirectAttributes redirectAttributes) {
    Boleta boleta = obtenerBoleta(id, model);
    if (boleta == null) {
        // Mensaje claro para el usuario
        redirectAttributes.addFlashAttribute("error", 
            "No se encontró la boleta con ID: " + id);
        return "redirect:/admin/boletas";
    }
    cargarListasBoleta(id, model);
    return "adminboleta-editar";
}
```

**📄 Vista con mensajes:**
```jsp
<!-- adminboletas.jsp -->
<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
```

**⚠️ Impacto:** Sin feedback claro, los usuarios no pueden entender los errores.

---

## 5. Optimización y Rendimiento

### 🚨 **Problema: Consultas Ineficientes**

**📄 Fragmento problemático:**
```java
// AdminBoletasController.java
@GetMapping("/{id}")
public String detalle(@PathVariable("id") int id, Model model) {
    // Múltiples consultas separadas
    model.addAttribute("detalles", detalleBoletaService.listarPorBoleta(id));
    model.addAttribute("productos", productoService.listarTodos()); // ❌ Todos los productos
    model.addAttribute("detalle", new DetalleBoleta());
    return "adminboleta-detalle";
}
```

**❓ Pregunta:** ¿Por qué cargas todos los productos si solo necesitas algunos?

**🔍 Explicación:** Cargas todos los productos aunque solo necesitas los que están en los detalles:

```java
// Problema de rendimiento:
// 1. detalleBoletaService.listarPorBoleta(id) → 5 detalles
// 2. productoService.listarTodos() → 1000 productos
// 3. Solo necesitas 5 productos, pero cargas 1000
```

**✅ Solución recomendada:**
```java
@GetMapping("/{id}")
public String detalle(@PathVariable("id") int id, Model model) {
    // Obtener detalles con productos relacionados en una consulta
    List<DetalleBoleta> detalles = detalleBoletaService.listarConProductos(id);
    model.addAttribute("detalles", detalles);
    
    // Extraer productos únicos de los detalles
    Set<Producto> productosUnicos = detalles.stream()
        .map(DetalleBoleta::getProducto)
        .collect(Collectors.toSet());
    model.addAttribute("productos", productosUnicos);
    
    model.addAttribute("detalle", new DetalleBoleta());
    return "adminboleta-detalle";
}
```

**📄 Implementación optimizada:**
```java
@Repository
public class DetalleBoletaDAOImpl implements DetalleBoletaDAO {
    
    @Override
    public List<DetalleBoleta> listarConProductos(int idBoleta) {
        String sql = """
            SELECT db.*, p.nombre_producto, p.precio as precio_actual
            FROM DetalleBoletas db
            JOIN Productos p ON db.id_producto = p.id_producto
            WHERE db.id_boleta = ?
            ORDER BY db.id_detalle_boleta
            """;
        return jdbcTemplate.query(sql, new DetalleBoletaRowMapper(), idBoleta);
    }
}
```

**⚠️ Impacto:** Sin optimización, la aplicación será lenta con muchos productos.

---

## 6. Concurrencia y Seguridad

### 🚨 **Problema: Condiciones de Carrera**

**📄 Fragmento problemático:**
```java
// AdminBoletasController.java
@PostMapping("/{id}/detalle/guardar")
public String guardarDetalle(@PathVariable("id") int idBoleta, 
                            @ModelAttribute DetalleBoleta detalle) {
    detalleBoletaService.guardar(detalle);
    boletaService.recalcTotal(idBoleta);  // ❌ Sin control de concurrencia
    return "redirect:/admin/boletas/" + idBoleta;
}
```

**❓ Pregunta:** ¿Qué pasa si dos usuarios modifican la misma boleta simultáneamente?

**🔍 Explicación:** Escenario de condición de carrera:

```java
// Usuario A y Usuario B modifican la misma boleta simultáneamente:
// Tiempo 0: Boleta #100 tiene total = $100
// Tiempo 1: Usuario A agrega detalle de $50 → total = $150
// Tiempo 2: Usuario B agrega detalle de $30 → total = $130
// Tiempo 3: Usuario A recalcula total → $150 (correcto)
// Tiempo 4: Usuario B recalcula total → $130 (incorrecto, sobreescribe a A)
// Resultado: Total incorrecto, se perdió el detalle de $50
```

**✅ Solución recomendada:**
```java
@Service
public class BoletaServiceImpl implements BoletaService {
    
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public void guardarDetalleYRecalcular(int idBoleta, DetalleBoleta detalle) {
        // Bloquea la boleta durante toda la operación
        lockBoleta(idBoleta);
        
        try {
            detalleBoletaService.guardar(detalle);
            recalcTotal(idBoleta);
        } finally {
            unlockBoleta(idBoleta);
        }
    }
    
    // Opción 2: Usar optimist locking
    @Transactional
    public void guardarDetalleConVersion(int idBoleta, DetalleBoleta detalle, int version) {
        Boleta boleta = obtenerPorId(idBoleta)
            .orElseThrow(() -> new IllegalArgumentException("Boleta no encontrada"));
            
        if (boleta.getVersion() != version) {
            throw new OptimisticLockException("La boleta fue modificada por otro usuario");
        }
        
        detalleBoletaService.guardar(detalle);
        recalcTotal(idBoleta);
        boleta.setVersion(version + 1);
        actualizar(boleta);
    }
}
```

**📄 Modelo con version:**
```java
public class Boleta {
    private int id_boleta;
    private int version;  // Para optimist locking
    
    // getters y setters...
}
```

**⚠️ Impacto:** Sin control de concurrencia, puedes perder datos y tener inconsistencias.

---

## 7. Consistencia y Nomenclatura

### 🚨 **Problema: Nomenclatura Inconsistente**

**📄 Fragmentos problemáticos:**
```java
// Mezcla de idiomas
public String guardarDetalle(...)           // español
public List<Producto> findAll()            // inglés
public void recalcTotal(int idBoleta)      // inglés con abreviación
public String verPaginaDeInicio()           // español
```

**❓ Pregunta:** ¿Deberíamos estandarizar a un solo idioma?

**🔍 Explicación:** La inconsistencia dificulta el mantenimiento:

```java
// Problemas de consistencia actual:
// 1. Métodos en español: guardar, editar, eliminar, listar
// 2. Métodos en inglés: save, findAll, update, delete
// 3. Variables en español: idBoleta, nombreProducto
// 4. Variables en inglés: boleta, producto, categoria
```

**✅ Solución recomendada:**
```java
// Opción A: Todo en español
public class BoletaController {
    public String guardarBoleta(Boleta boleta) { ... }
    public String editarBoleta(int id, Model model) { ... }
    public String eliminarBoleta(int id) { ... }
    public List<Boleta> listarTodas() { ... }
}

// Opción B: Todo en inglés
public class InvoiceController {
    public String saveInvoice(Invoice invoice) { ... }
    public String editInvoice(int id, Model model) { ... }
    public String deleteInvoice(int id) { ... }
    public List<Invoice> findAll() { ... }
}
```

**📄 Estándar recomendado (español):**
```java
// Nomenclatura consistente en español
public class BoletaController {
    
    @GetMapping
    public String listarBoletas(Model model) {
        model.addAttribute("boletas", boletaService.listarTodas());
        return "adminboletas";
    }
    
    @PostMapping("/guardar")
    public String guardarBoleta(@ModelAttribute Boleta boleta) {
        boletaService.guardar(boleta);
        return "redirect:/admin/boletas";
    }
    
    @GetMapping("/editar/{idBoleta}")
    public String editarBoleta(@PathVariable int idBoleta, Model model) {
        // ...
    }
}
```

**⚠️ Impacto:** La inconsistencia dificulta el mantenimiento y la colaboración.

---

## 8. Arquitectura de Carrito

### 🚨 **Problema: Carrito Incompleto**

**📄 Fragmento problemático:**
```java
// CarritoController.java - Simplificado
@Controller
public class CarritoController {
    
    @GetMapping("/carrito")
    public String verCarrito() {
        return "carrito";  // ❌ ¿Dónde se carga el carrito?
    }
}
```

**❓ Pregunta:** ¿Por qué el CarritoController no tiene la funcionalidad completa?

**🔍 Explicación:** El carrito está completamente simplificado:

```java
// Problemas del carrito actual:
// 1. No carga productos desde la sesión
// 2. No permite agregar/eliminar productos
// 3. No calcula totales
// 4. No maneja stock
// 5. No persiste en base de datos
```

**✅ Solución recomendada:**
```java
@Controller
@RequestMapping("/carrito")
public class CarritoController {
    
    @GetMapping
    public String verCarrito(HttpSession session, Model model) {
        Carrito carrito = obtenerCarrito(session);
        model.addAttribute("carrito", carrito);
        model.addAttribute("total", carrito.getTotal());
        return "carrito";
    }
    
    @PostMapping("/agregar")
    public String agregarProducto(@RequestParam int idProducto,
                                 @RequestParam int cantidad,
                                 HttpSession session,
                                 RedirectAttributes attr) {
        try {
            Carrito carrito = obtenerCarrito(session);
            Producto producto = productoService.obtenerPorId(idProducto)
                .orElseThrow(() -> new IllegalArgumentException("Producto no encontrado"));
            
            // Validar stock
            if (producto.getStock() < cantidad) {
                throw new IllegalArgumentException("Stock insuficiente");
            }
            
            // Agregar al carrito
            carrito.agregarItem(producto, cantidad);
            
            attr.addFlashAttribute("success", "Producto agregado al carrito");
        } catch (Exception e) {
            attr.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/carrito";
    }
    
    @PostMapping("/procesar")
    @Transactional
    public String procesarCarrito(HttpSession session, 
                                RedirectAttributes attr) {
        Carrito carrito = obtenerCarrito(session);
        
        if (carrito.estaVacio()) {
            attr.addFlashAttribute("error", "El carrito está vacío");
            return "redirect:/carrito";
        }
        
        try {
            // Crear boleta desde carrito
            Boleta boleta = boletaService.crearDesdeCarrito(carrito);
            
            // Vaciar carrito
            session.removeAttribute("carrito");
            
            attr.addFlashAttribute("success", 
                "Compra procesada exitosamente. Boleta #" + boleta.getId_boleta());
            
            return "redirect:/boletas/" + boleta.getId_boleta();
        } catch (Exception e) {
            attr.addFlashAttribute("error", "Error al procesar compra: " + e.getMessage());
            return "redirect:/carrito";
        }
    }
    
    private Carrito obtenerCarrito(HttpSession session) {
        Carrito carrito = (Carrito) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new Carrito();
            session.setAttribute("carrito", carrito);
        }
        return carrito;
    }
}
```

**📄 Modelo de Carrito:**
```java
public class Carrito {
    private List<CarritoItem> items = new ArrayList<>();
    
    public void agregarItem(Producto producto, int cantidad) {
        // Buscar si ya existe el producto
        Optional<CarritoItem> existente = items.stream()
            .filter(item -> item.getProducto().getId_producto().equals(producto.getId_producto()))
            .findFirst();
            
        if (existente.isPresent()) {
            existente.get().setCantidad(existente.get().getCantidad() + cantidad);
        } else {
            items.add(new CarritoItem(producto, cantidad));
        }
    }
    
    public double getTotal() {
        return items.stream()
            .mapToDouble(item -> item.getProducto().getPrecio() * item.getCantidad())
            .sum();
    }
    
    public boolean estaVacio() {
        return items.isEmpty();
    }
}
```

**⚠️ Impacto:** Sin carrito funcional, los usuarios no pueden comprar productos.

---

## 🎯 **Resumen de Problemas Críticos**

| Problema | Severidad | Impacto | Solución |
|----------|-----------|---------|----------|
| **DAOs sin implementación** | 🔴 Crítico | La aplicación no inicia | Crear clases `*Impl` con `@Repository` |
| **Sin transacciones** | 🔴 Crítico | Datos inconsistentes | Agregar `@Transactional` |
| **Sin validaciones** | 🟡 Alto | Datos corruptos | Validaciones en services |
| **Errores silenciosos** | 🟡 Alto | Mala UX | Mensajes flash claros |
| **Consultas ineficientes** | 🟡 Medio | Bajo rendimiento | Optimizar queries |
| **Sin control de concurrencia** | 🟡 Medio | Pérdida de datos | Optimist/pessimistic locking |
| **Nomenclatura inconsistente** | 🟢 Bajo | Difícil mantenimiento | Estandarizar idioma |
| **Carrito incompleto** | 🟡 Alto | No se puede comprar | Implementar carrito completo |

## 🚀 **Plan de Acción Recomendado**

### **Fase 1: Crítico (Inmediato)**
1. **Crear implementaciones de DAOs** con JdbcTemplate
2. **Agregar @Transactional** en operaciones críticas
3. **Implementar carrito funcional**

### **Fase 2: Alto (Corto plazo)**
4. **Agregar validaciones de negocio**
5. **Implementar mensajes de error claros**
6. **Optimizar consultas principales**

### **Fase 3: Medio (Medio plazo)**
7. **Agregar control de concurrencia**
8. **Estandarizar nomenclatura**

### **Fase 4: Bajo (Largo plazo)**
9. **Agregar logging y monitoreo**
10. **Implementar caché si es necesario**

---

## 🔧 **Ejemplo Completo de Implementación**

### **DAO Implementado:**
```java
@Repository
public class BoletaDAOImpl implements BoletaDAO {
    private final JdbcTemplate jdbcTemplate;
    
    public BoletaDAOImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    @Override
    @Transactional
    public void save(Boleta boleta) {
        String sql = """
            INSERT INTO Boletas (id_usuario, fecha_emision, total, version) 
            VALUES (?, ?, ?, 1)
            """;
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
    
    @Override
    @Transactional
    public void recalcTotal(int idBoleta) {
        String sql = """
            UPDATE Boletas 
            SET total = (
                SELECT COALESCE(SUM(cantidad * precio_unitario), 0) 
                FROM DetalleBoletas 
                WHERE id_boleta = ?
            ),
            version = version + 1
            WHERE id_boleta = ?
            """;
        jdbcTemplate.update(sql, idBoleta, idBoleta);
    }
}
```

### **Service con Validaciones:**
```java
@Service
@Transactional
public class BoletaServiceImpl implements BoletaService {
    
    @Override
    public void guardar(Boleta boleta) {
        // Validaciones
        if (boleta.getId_usuario() <= 0) {
            throw new IllegalArgumentException("ID de usuario inválido");
        }
        
        if (boleta.getTotal() < 0) {
            throw new IllegalArgumentException("El total no puede ser negativo");
        }
        
        if (boleta.getFecha_emision() == null) {
            boleta.setFecha_emision(LocalDateTime.now());
        }
        
        boletaDao.save(boleta);
    }
    
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public void guardarDetalleYRecalcular(int idBoleta, DetalleBoleta detalle) {
        // Bloqueo pesimista para evitar condiciones de carrera
        String lockSql = "SELECT * FROM Boletas WHERE id_boleta = ? FOR UPDATE";
        jdbcTemplate.queryForObject(lockSql, new BoletaRowMapper(), idBoleta);
        
        detalleBoletaService.guardar(detalle);
        recalcTotal(idBoleta);
    }
}
```

### **Controller con Feedback:**
```java
@Controller
@RequestMapping("/admin/boletas")
public class AdminBoletasController {
    
    @GetMapping("/editar/{id}")
    public String editar(@PathVariable("id") int id, Model model, 
                        RedirectAttributes redirectAttributes) {
        try {
            Boleta boleta = boletaService.obtenerPorId(id)
                .orElseThrow(() -> new IllegalArgumentException("Boleta no encontrada"));
            
            model.addAttribute("boleta", boleta);
            model.addAttribute("usuarios", usuarioAdminService.listarTodos());
            return "adminboleta-editar";
            
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin/boletas";
        }
    }
    
    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Boleta boleta, 
                         BindingResult result,
                         RedirectAttributes redirectAttributes) {
        try {
            if (result.hasErrors()) {
                redirectAttributes.addFlashAttribute("error", 
                    "Por favor corrija los errores del formulario");
                return "redirect:/admin/boletas/nuevo";
            }
            
            boletaService.guardar(boleta);
            redirectAttributes.addFlashAttribute("success", 
                "Boleta guardada exitosamente");
            
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Error al guardar boleta: " + e.getMessage());
        }
        
        return "redirect:/admin/boletas";
    }
}
```

Este análisis completo identifica los problemas críticos del backend y proporciona soluciones concretas para cada uno.
