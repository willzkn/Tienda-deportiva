# Guía Frontend-Java: Cómo se Conectan

Esta guía explica específicamente cómo los archivos del frontend (JSP, JSPF, JS) se conectan y comunican con Java.

---

## 🔗 La Conexión Frontend-Java

### ¿Cómo se comunican?
```
Frontend (JSP/JS) ←→ Spring Controller ←→ Java Services ←→ Base de Datos
```

El frontend **no habla directamente** con Java. Siempre pasa por el Controller de Spring.

---

## 📄 Archivos JSP (Java Server Pages)

### ¿Qué es JSP?
Es HTML con **poder de Java**. Permite mezclar código Java dentro del HTML.

### Sintaxis Básica JSP

#### 1. **Directivas** (Configuración)
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
```
- `page`: Configuración básica de la página
- `taglib`: Importa librerías de etiquetas (como JSTL)

#### 2. **Expresiones EL** (Mostrar datos de Java)
```jsp
<!-- Mostrar una variable del Controller -->
<h1>${pageTitle}</h1>

<!-- Acceder a propiedades de objetos -->
<p>${producto.nombre}</p>
<p>${producto.precio}</p>

<!-- Acceder a listas -->
<c:forEach items="${productos}" var="producto">
    <div>${producto.nombre} - S/. ${producto.precio}</div>
</c:forEach>
```

#### 3. **Scriptlets** (Código Java puro)
```jsp
<%
// Código Java directamente
String mensaje = "Hola desde JSP";
out.print("<p>" + mensaje + "</p>");
%>
```

#### 4. **Includes** (Reutilizar código)
```jsp
<%@ include file="includes/navbar.jspf" %>
<%@ include file="includes/footer.jspf" %>
```

---

## 🎯 Ejemplo Real: `productos.jsp`

### El Controller envía datos
```java
// En HomeController.java
@GetMapping("/productos")
public String listarProductos(
    @RequestParam(required = false) Integer categoriaId,
    @RequestParam(required = false) String sortBy,
    Model model) {
    
    // Obtener datos del backend
    List<Producto> productos = productoService.listarProductos();
    List<Categoria> categorias = categoriaService.listarTodas();
    
    // Filtrar y ordenar si es necesario
    if (categoriaId != null) {
        productos = productos.stream()
            .filter(p -> p.getId_categoria() == categoriaId)
            .collect(Collectors.toList());
    }
    
    // Enviar datos al JSP
    model.addAttribute("productos", productos);
    model.addAttribute("categorias", categorias);
    model.addAttribute("selectedCategoriaId", categoriaId);
    model.addAttribute("selectedSortBy", sortBy);
    
    return "productos";  // Nombre del archivo JSP
}
```

### El JSP recibe y muestra los datos
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>${pageTitle} - VENTADEPOR</title>
</head>
<body>
    <!-- Filtros usando datos de Java -->
    <form action="${pageContext.request.contextPath}/productos" method="GET">
        <select name="categoriaId" onchange="this.form.submit()">
            <option value="">Todas las categorías</option>
            <!-- Itera sobre la lista de categorías desde Java -->
            <c:forEach items="${categorias}" var="cat">
                <option value="${cat.id_categoria}" 
                        ${cat.id_categoria == selectedCategoriaId ? 'selected' : ''}>
                    ${cat.nombre_categoria}
                </option>
            </c:forEach>
        </select>
    </form>

    <!-- Grid de productos desde Java -->
    <div class="productos-grid">
        <c:forEach items="${productos}" var="p">
            <div class="producto">
                <!-- Imagen desde Java (Base64 o URL) -->
                <c:choose>
                    <c:when test="${not empty p.imagenBase64}">
                        <img src="data:image/jpeg;base64,${p.imagenBase64}" alt="${p.nombre}">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/images/default-product.png" alt="${p.nombre}">
                    </c:otherwise>
                </c:choose>
                
                <!-- Datos del producto desde Java -->
                <h3>${p.nombre}</h3>
                <p class="precio">
                    <fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="S/"/>
                </p>
                <p>Stock: ${p.stock}</p>
                
                <!-- Botón que usará JavaScript -->
                <button class="agregar" data-nombre="${p.nombre}" data-precio="${p.precio}">
                    Agregar al Carrito
                </button>
            </div>
        </c:forEach>
    </div>
</body>
</html>
```

**¿Qué está pasando aquí?**
1. **Controller** envía `productos`, `categorias`, `selectedCategoriaId`
2. **JSP** recibe estos datos en el `Model`
3. **JSTL** (`<c:forEach>`) itera sobre las listas
4. **EL** (`${producto.nombre}`) accede a las propiedades
5. **JavaScript** usará estos datos después

---

## 🧩 Archivos JSPF (Fragmentos JSP)

### ¿Qué son JSPF?
Son **trozos de JSP reutilizables**. El "F" significa "Fragment".

### `appHead.jspf` - Cabecera común
```jsp
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>${pageTitle} - VENTADEPOR</title>

<!-- Variable global para JavaScript -->
<script>
  window.appContext = '${pageContext.request.contextPath}';
</script>

<!-- CSS del contexto de la aplicación -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
```

**Conexión con Java:**
- `${pageTitle}`: Variable que viene del Controller
- `${pageContext.request.contextPath}`: Ruta base de la app Spring

### `navbar.jspf` - Navegación dinámica
```jsp
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<nav class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/inicio">
        VENTADEPOR
    </a>
    
    <div class="navbar-nav">
        <a class="nav-link" href="${pageContext.request.contextPath}/inicio">Inicio</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/productos">Productos</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/carrito">
            🛒 Carrito
            <!-- Contador actualizado por JavaScript -->
            <span id="carrito-count">0</span>
        </a>
        
        <!-- Enlace dinámico según si está logueado -->
        <c:choose>
            <c:when test="${sessionScope.usuario != null}">
                <a href="${pageContext.request.contextPath}/admin">
                    👤 ${sessionScope.usuario.correo}
                </a>
                <a href="${pageContext.request.contextPath}/logout">Salir</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">Login</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>
```

**Conexión con Java:**
- `${sessionScope.usuario}`: Datos de la sesión Spring
- `${pageContext.request.contextPath}`: Ruta base
- `<c:choose>`: Lógica condicional JSTL

---

## ⚡ JavaScript (La Conexión Dinámica)

### ¿Cómo JavaScript se comunica con Java?

#### 1. **Leyendo datos que Java envía**
```javascript
// productos.js
document.addEventListener('DOMContentLoaded', function() {
    
    // Los productos ya están en el HTML (puestos por JSP)
    const productos = document.querySelectorAll('.producto');
    
    productos.forEach(producto => {
        const boton = producto.querySelector('.agregar');
        
        boton.addEventListener('click', function() {
            // Extraer datos del DOM (puestos por JSP/Java)
            const nombre = this.getAttribute('data-nombre');
            const precio = parseFloat(this.getAttribute('data-precio'));
            const imagen = producto.querySelector('img').src;
            
            // Crear objeto para el carrito
            const item = {
                id: Date.now(),
                nombre: nombre,      // Venía de Java
                precio: precio,      // Venía de Java
                imagen: imagen,      // Venía de Java
                cantidad: 1
            };
            
            agregarAlCarrito(item);
        });
    });
});
```

#### 2. **Enviando datos a Java (Formularios)**
```javascript
// carrito.js - Procesar compra
document.getElementById('formulario-pago').addEventListener('submit', function(e) {
    e.preventDefault();
    
    // Obtener datos del carrito (localStorage)
    const carrito = JSON.parse(localStorage.getItem('carrito')) || [];
    
    // Obtener datos del formulario
    const formData = new FormData(this);
    const datosCliente = {
        nombre: formData.get('nombre'),
        email: formData.get('email'),
        direccion: formData.get('direccion')
    };
    
    // Preparar datos para enviar a Java
    const compraData = {
        cliente: datosCliente,
        items: carrito.map(item => ({
            nombre: item.nombre,
            precio: item.precio,
            cantidad: item.cantidad
        }))
    };
    
    // Enviar al backend Java
    fetch(`${window.appContext}/api/procesar-compra`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(compraData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('¡Compra procesada!');
            localStorage.removeItem('carrito');
            window.location.href = `${window.appContext}/productos`;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error al procesar la compra');
    });
});
```

#### 3. **Recibiendo datos de Java (AJAX)**
```javascript
// adminproductos.js - Búsqueda en tiempo real
document.getElementById('busqueda-producto').addEventListener('input', function() {
    const termino = this.value;
    
    // Pedir datos al backend Java
    fetch(`${window.appContext}/admin/api/buscar-productos?q=${termino}`)
        .then(response => response.json())
        .then(productos => {
            // Actualizar la interfaz con los datos de Java
            const contenedor = document.getElementById('resultados-busqueda');
            contenedor.innerHTML = productos.map(p => `
                <tr>
                    <td>${p.id_producto}</td>
                    <td>${p.nombre}</td>
                    <td>${p.precio}</td>
                    <td>${p.stock}</td>
                    <td>
                        <button onclick="editarProducto(${p.id_producto})">Editar</button>
                    </td>
                </tr>
            `).join('');
        });
});
```

---

## 🔄 Flujo Completo: Un Ejemplo Real

### 1. **Usuario pide productos**
```
Browser: GET /productos?categoriaId=1
↓
Spring Controller: HomeController.listarProductos()
↓
Java Service: productoService.listarProductos()
↓
Java Repository: productoDAO.findAll()
↓
Base de Datos: SELECT * FROM Productos WHERE id_categoria = 1
↓
Java Repository: Retorna List<Producto>
↓
Java Service: Aplica filtros, retorna lista
↓
Spring Controller: model.addAttribute("productos", lista)
↓
JSP: productos.jsp recibe ${productos}
↓
HTML: Renderiza productos con ${producto.nombre}, ${producto.precio}
```

### 2. **Usuario agrega al carrito**
```
Browser: Usuario hace clic en "Agregar"
↓
JavaScript: productos.js captura evento
↓
JavaScript: Extrae data-nombre, data-precio del DOM
↓
JavaScript: Crea objeto, guarda en localStorage
↓
JavaScript: Actualiza contador #carrito-count
↓
Browser: Muestra notificación
```

### 3. **Usuario procesa compra**
```
Browser: Usuario envía formulario
↓
JavaScript: Prepara JSON con datos del carrito
↓
JavaScript: POST /api/procesar-compra con JSON
↓
Spring Controller: Recibe JSON, lo convierte a objetos Java
↓
Java Service: Procesa compra, guarda en BD
↓
Java Repository: Inserta en Boletas, Detalle_Boleta
↓
Base de Datos: INSERT INTO Boletas...
↓
Spring Controller: Retorna JSON {success: true}
↓
JavaScript: Recibe respuesta, muestra mensaje, limpia carrito
```

---

## 🎯 Variables y Objetos Comunes

### Variables que Java envía al JSP
```java
// En el Controller
model.addAttribute("productos", productosList);
model.addAttribute("categorias", categoriasList);
model.addAttribute("producto", productoIndividual);
model.addAttribute("pageTitle", "Nuestros Productos");
model.addAttribute("error", "Mensaje de error");
model.addAttribute("usuario", usuarioLogueado);
```

### Cómo el JSP las usa
```jsp
<!-- Listas -->
<c:forEach items="${productos}" var="producto">
    ${producto.nombre}
</c:forEach>

<!-- Objetos individuales -->
<h1>${pageTitle}</h1>
<p>${producto.descripcion}</p>

<!-- Condiciones -->
<c:if test="${not empty error}">
    <div class="error">${error}</div>
</c:if>

<!-- Sesión -->
<c:if test="${sessionScope.usuario != null}">
    Bienvenido ${sessionScope.usuario.nombre}
</c:if>
```

### Variables que JavaScript usa
```javascript
// Variables globales puestas por JSP
const appContext = window.appContext;  // "${pageContext.request.contextPath}"

// Datos del DOM (puestos por JSP)
const productoNombre = element.getAttribute('data-nombre');  // ${producto.nombre}
const productoPrecio = element.getAttribute('data-precio');   // ${producto.precio}

// Rutas para llamadas a Java
fetch(`${appContext}/api/productos`);  // Llama a Controller Java
```

---

## 🔧 Herramientas de Depuración

### 1. **Ver qué envía Java al JSP**
```jsp
<!-- Agrega esto temporalmente para depurar -->
<c:forEach items="${productos}" var="p">
    <!-- Console.log desde JSP -->
    <script>
        console.log('Producto desde Java: ${p.nombre} - ${p.precio}');
    </script>
</c:forEach>
```

### 2. **Ver qué recibe JavaScript**
```javascript
// En productos.js
console.log('Contexto de app:', window.appContext);
console.log('Productos encontrados:', document.querySelectorAll('.producto').length);

// Ver datos extraídos
console.log('Datos del producto:', {
    nombre: this.getAttribute('data-nombre'),
    precio: this.getAttribute('data-precio')
});
```

### 3. **Ver comunicación AJAX**
```javascript
fetch(url, options)
    .then(response => {
        console.log('Respuesta de Java:', response);
        return response.json();
    })
    .then(data => {
        console.log('Datos de Java:', data);
    })
    .catch(error => {
        console.error('Error hablando con Java:', error);
    });
```

---

## 📝 Resumen de Conexiones

| Frontend | Java | ¿Cómo se conectan? |
|----------|------|-------------------|
| **JSP** | Controller | `${variable}` desde `model.addAttribute()` |
| **JSPF** | Controller | Mismo mecanismo que JSP |
| **JavaScript** | JSP | Lee datos del DOM puestos por JSP |
| **JavaScript** | Controller | `fetch()` a endpoints REST |
| **Formularios** | Controller | `POST` a rutas mapeadas con `@PostMapping` |

---

## 🎯 Lo Más Importante

1. **JSP = HTML + Java**: Puede mostrar datos de Java directamente
2. **JavaScript lee el DOM**: Extrae datos que JSP ya puso en el HTML
3. **JavaScript habla con Java**: Usando `fetch()` a endpoints Spring
4. **Todo pasa por el Controller**: Nunca hay comunicación directa
5. **Variables viajan en una dirección**: Java → JSP → JavaScript

Esta es la forma en que tu frontend y backend trabajan juntos para crear la experiencia de usuario completa.
