# 🎨 Preguntas y Respuestas de Código Frontend - Tienda Deportiva UTP

## 📋 Tabla de Contenidos
- [Frontend - JSPs](#frontend---jsps)
- [Frontend - JSPF (Includes)](#frontend---jspf-includes)
- [Frontend - JavaScript](#frontend---javascript)
- [Frontend - Integración y Comunicación](#frontend---integración-y-comunicación)

---

## Frontend - JSPs

### 🎯 **inicio.jsp**

**1. ¿Qué hace `<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>`?**

**📄 Código:**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
```

**✅ Respuesta:**
- **Qué hace:** Define el lenguaje de la página (Java), el tipo de contenido (HTML), y la codificación de caracteres (UTF-8)
- **Cómo funciona:** El contenedor JSP procesa estas directivas antes de compilar la página a servlet
- **Por qué:** Para soportar caracteres especiales como ñ, á, é, í, ó, ú en español
- **Alternativas:** ISO-8859-1, pero no soporta todos los caracteres unicode
- **Problemas:** Si no se especifica, puede usar codificación por defecto que no soporta caracteres especiales
- **Mejoras:** Usar siempre UTF-8 para compatibilidad internacional

**🔍 Proceso de compilación:**
```java
// JSP internamente se convierte a:
public class inicio_jsp extends HttpServlet {
    public void _jspService(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        // Resto del código generado
    }
}
```

---

**2. ¿Qué sucede cuando se ejecuta `<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>`?**

**📄 Código:**
```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
```

**✅ Respuesta:**
- **Qué hace:** Importa la biblioteca JSTL Core con el prefijo "c" para usar etiquetas como c:forEach, c:if
- **Cómo funciona:** El contenedor JSP registra el TagLibrary con el URI especificado
- **Por qué:** Para evitar scriptlets Java y usar etiquetas XML más limpias
- **Alternativas:** Scriptlets <%= %>, pero son menos mantenibles
- **Problemas:** Si la librería no está en el classpath, lanza error de compilación
- **Mejoras:** Usar siempre JSTL en lugar de scriptlets

**🔍 Mapeo de etiquetas:**
```jsp
<!-- c:forEach se mapea a: -->
<c:forEach items="${productos}" var="producto">
<!-- Internamente se convierte a: -->
ForEachTag forEach = new ForEachTag();
forEach.setItems(pageContext.findAttribute("productos"));
forEach.setVar("producto");
forEach.doStartTag();
```

---

**3. ¿Qué hace `${pageContext.request.contextPath}` exactamente?**

**📄 Código:**
```jsp
<a class="navbar-brand" href="${pageContext.request.contextPath}/inicio">VENTADEPOR</a>
```

**✅ Respuesta:**
- **Qué hace:** Obtiene el context path de la aplicación web (ej: /tienda-deportiva)
- **Cómo funciona:** EL resuelve pageContext -> request -> getContextPath()
- **Por qué:** Para que las URLs funcionen sin importar dónde está desplegada la app
- **Alternativas:** URL hardcoded, pero se rompe si cambia el deployment
- **Problemas:** Si el context path es root (/), devuelve cadena vacía
- **Mejoras:** Usar siempre esta expresión para URLs relativas

**🔍 Resolución EL:**
```java
// EL internamente ejecuta:
PageContext pageContext = (PageContext) JspContext;
HttpServletRequest request = pageContext.getRequest();
String contextPath = request.getContextPath();
out.print(contextPath);
```

---

**4. ¿Qué sucede cuando se ejecuta `<c:forEach items="${productosDestacados}" var="producto">`?**

**📄 Código:**
```jsp
<c:if test="${not empty productosDestacados}">
  <c:forEach items="${productosDestacados}" var="producto">
    <div class="col-md-4">
      <div class="card mb-4">
```

**✅ Respuesta:**
- **Qué hace:** Itera sobre la colección productosDestacados, creando una variable "producto" por cada elemento
- **Cómo funciona:** JSTL crea un iterador y expone cada elemento en el PageContext
- **Por qué:** Para generar tarjetas de productos dinámicamente sin código Java
- **Alternativas:** Scriptlets for loop, pero es más verboso y menos seguro
- **Problemas:** Con muchos productos, genera mucho HTML y puede ser lento
- **Mejoras:** Usar paginación para grandes cantidades de productos

**🔍 Código generado:**
```jsp
<!-- Si hay 3 productos, genera: -->
<div class="col-md-4"><div class="card mb-4">...producto 1...</div></div>
<div class="col-md-4"><div class="card mb-4">...producto 2...</div></div>
<div class="col-md-4"><div class="card mb-4">...producto 3...</div></div>
```

---

**5. ¿Qué significa `<c:if test="${not empty productosDestacados}">`?**

**📄 Código:**
```jsp
<c:if test="${not empty productosDestacados}">
  <c:forEach items="${productosDestacados}" var="producto">
```

**✅ Respuesta:**
- **Qué hace:** Evalúa si productosDestacados no es null ni está vacío antes de iterar
- **Cómo funciona:** EL evalúa la expresión y decide si renderizar el contenido del body
- **Por qué:** Para evitar NullPointerException y mostrar contenido solo si hay datos
- **Alternativas:** Scriptlets if statement, pero es menos legible
- **Problemas:** Si la colección está vacía, no muestra nada (podría mostrar mensaje)
- **Mejoras:** Agregar else con c:if para mostrar mensaje cuando no hay productos

**🔍 Evaluación EL:**
```java
// EL internamente evalúa:
Object productos = pageContext.findAttribute("productosDestacados");
boolean notEmpty = productos != null && !((Collection)productos).isEmpty();
if (notEmpty) {
    // Renderizar contenido del body
}
```

---

### 🎯 **adminproductos.jsp**

**6. ¿Qué hace `<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>`?**

**📄 Código:**
```jsp
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
```

**✅ Respuesta:**
- **Qué hace:** Importa la biblioteca JSTL Formatting para formatear fechas, números y monedas
- **Cómo funciona:** Registra las etiquetas fmt:formatNumber, fmt:formatDate, etc.
- **Por qué:** Para formatear precios con separadores de miles y decimales
- **Alternativas:** Formatear en el controller, pero pierde flexibilidad de locale
- **Problemas:** Si no se configura locale, usa el del servidor
- **Mejoras:** Configurar locale específico para Perú (es_PE)

**🔍 Formato de moneda:**
```jsp
<!-- fmt:formatNumber se convierte a: -->
<fmt:formatNumber value="${producto.precio}" pattern="#,##0.00"/>
<!-- Genera: 1,234.56 para 1234.56 -->
```

---

**7. ¿Qué sucede con `<c:choose>` y `<c:when>`?**

**📄 Código:**
```jsp
<c:choose>
  <c:when test="${not empty producto.imagenBase64}">
    <img src="data:image/jpeg;base64,${producto.imagenBase64}" alt="${producto.nombre}">
  </c:when>
  <c:otherwise>
    <div style="background: #f0f0f0;">Sin imagen</div>
  </c:otherwise>
</c:choose>
```

**✅ Respuesta:**
- **Qué hace:** Evalúa condiciones en orden, ejecutando la primera que sea verdadera (switch-case)
- **Cómo funciona:** c:choose contiene c:when (if-else if) y opcionalmente c:otherwise (else)
- **Por qué:** Para mostrar imagen si existe, o placeholder si no hay imagen
- **Alternativas:** c:if anidados, pero es más verboso y menos legible
- **Problemas:** Si hay muchas condiciones, puede ser difícil de mantener
- **Mejoras:** Extraer a un JSPF include para reutilizar

**🔍 Lógica de evaluación:**
```java
// Internamente se convierte a:
if (producto.getImagenBase64() != null && !producto.getImagenBase64().isEmpty()) {
    out.print("<img src=\"data:image/jpeg;base64," + producto.getImagenBase64() + "\">");
} else {
    out.print("<div style=\"background: #f0f0f0;\">Sin imagen</div>");
}
```

---

**8. ¿Qué significa `enctype="multipart/form-data"`?**

**📄 Código:**
```jsp
<form id="addProductForm" action="..." method="post" enctype="multipart/form-data">
  <input type="file" id="imagenFile" name="imagenFile" accept="image/*" required>
```

**✅ Respuesta:**
- **Qué hace:** Indica que el formulario enviará datos binarios (archivos) además de texto
- **Cómo funciona:** Cambia el Content-Type a multipart/form-data con boundaries
- **Por qué:** Para poder subir archivos de imagen al servidor
- **Alternativas:** Base64 encoding, pero es menos eficiente para archivos grandes
- **Problemas:** Requiere configuración especial en el servidor (MultipartResolver)
- **Mejoras:** Validar tamaño y tipo de archivo en cliente y servidor

**🔍 Formato multipart:**
```http
POST /admin/productos/guardar HTTP/1.1
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary

------WebKitFormBoundary
Content-Disposition: form-data; name="sku"

PROD001
------WebKitFormBoundary
Content-Disposition: form-data; name="imagenFile"; filename="producto.jpg"
Content-Type: image/jpeg

[datos binarios de la imagen]
------WebKitFormBoundary--
```

---

**9. ¿Qué hace `onclick="return confirm('¿Estás seguro de eliminar este producto?');"`?**

**📄 Código:**
```jsp
<a href=".../eliminar/${producto.id_producto}" class="btn btn-delete" 
   onclick="return confirm('¿Estás seguro de eliminar este producto?');">
```

**✅ Respuesta:**
- **Qué hace:** Muestra un diálogo de confirmación antes de navegar a la URL de eliminación
- **Cómo funciona:** Si el usuario hace clic en "Cancelar", retorna false y cancela la navegación
- **Por qué:** Para prevenir eliminaciones accidentales
- **Alternativas:** Modal personalizado, pero es más complejo de implementar
- **Problemas:** El diálogo confirm() no se puede estilizar y puede ser bloqueado
- **Mejoras:** Usar modal Bootstrap para mejor UX

**🔍 Flujo de eventos:**
```javascript
// onclick internamente:
function onclick_handler(event) {
    if (!confirm('¿Estás seguro de eliminar este producto?')) {
        event.preventDefault();  // Cancela la navegación
        return false;
    }
    return true;  // Permite la navegación
}
```

---

**10. ¿Qué sucede cuando se ejecuta el JavaScript inline del modal?**

**📄 Código:**
```jsp
<script>
  document.addEventListener('DOMContentLoaded', function() {
      const modal = document.getElementById('addProductModal');
      const addBtn = document.getElementById('addProductBtn');
      addBtn.onclick = () => modal.style.display = 'flex';
  });
</script>
```

**✅ Respuesta:**
- **Qué hace:** Registra eventos para mostrar/ocultar el modal cuando el DOM está listo
- **Cómo funciona:** DOMContentLoaded asegura que todos los elementos existan antes de añadir listeners
- **Por qué:** Para hacer el modal interactivo sin recargar la página
- **Alternativas:** jQuery $(document).ready(), pero añade dependencia extra
- **Problemas:** Si hay múltiples modales, el código se duplica
- **Mejoras:** Extraer a un archivo JS externo y reutilizar

**🔍 Event loop:**
```javascript
// Flujo de ejecución:
// 1. Browser parsea HTML y construye DOM
// 2. Browser dispara evento DOMContentLoaded
// 3. JavaScript ejecuta la función callback
// 4. Se añaden event listeners a los elementos
// 5. Modal está listo para ser mostrado/ocultado
```

---

## Frontend - JSPF (Includes)

### 🎯 **layout.jspf**

**11. ¿Qué hace `<%@ include file="includes/appHead.jspf" %>`?**

**📄 Código:**
```jsp
<%@ include file="includes/appHead.jspf" %>
```

**✅ Respuesta:**
- **Qué hace:** Incluye el contenido del archivo especificado en tiempo de compilación (include estático)
- **Cómo funciona:** El contenedor JSP copia literalmente el contenido del archivo incluido
- **Por qué:** Para reutilizar componentes comunes como head, navbar, footer
- **Alternativas:** <jsp:include> (dinámico), pero es más lento
- **Problemas:** Si el archivo no existe, error de compilación
- **Mejoras:** Usar includes estáticos para contenido que no cambia

**🔍 Diferencia include types:**
```jsp
<%@ include file="header.jspf" %>    <!-- Include estático (compilación) -->
<!-- Copia el contenido literalmente antes de compilar -->

<jsp:include page="header.jspf" />   <!-- Include dinámico (runtime) -->
<!-- Incluye el resultado de ejecutar el JSP en tiempo de ejecución -->
```

---

**12. ¿Qué significa `<!DOCTYPE html>` y `<html lang="es">`?**

**📄 Código:**
```jsp
<!DOCTYPE html>
<html lang="es">
```

**✅ Respuesta:**
- **Qué hace:** Declara el tipo de documento HTML5 y especifica el idioma del contenido
- **Cómo funciona:** DOCTYPE activa el modo estándar del browser; lang ayuda a screen readers y SEO
- **Por qué:** Para renderizado consistente y accesibilidad
- **Alternativas:** DOCTYPE XHTML, pero es más estricto y menos flexible
- **Problemas:** Si no se especifica, el browser puede usar modo quirks
- **Mejoras:** Añadir meta tags para charset y viewport

**🔍 Modos de renderizado:**
```html
<!-- Con DOCTYPE: modo estándar (renderizado consistente) -->
<!DOCTYPE html>

<!-- Sin DOCTYPE: modo quirks (renderizado antiguo, inconsistente) -->
```

---

### 🎯 **headerPublic.jspf**

**13. ¿Qué hace `data-bs-toggle="collapse" data-bs-target="#navbarNav"`?**

**📄 Código:**
```jsp
<button class="navbar-toggler" type="button" 
        data-bs-toggle="collapse" data-bs-target="#navbarNav">
```

**✅ Respuesta:**
- **Qué hace:** Indica a Bootstrap.js que este botón controla el colapso del elemento #navbarNav
- **Cómo funciona:** Bootstrap.js lee los data-* attributes y añade event listeners automáticamente
- **Por qué:** Para crear menú hamburguesa responsive sin JavaScript manual
- **Alternativas:** JavaScript vanilla, pero requiere más código
- **Problemas:** Si Bootstrap.js no carga, el menú no funciona
- **Mejoras:** Añadir fallback con JavaScript vanilla

**🔍 Bootstrap JavaScript:**
```javascript
// Bootstrap internamente hace:
document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(button => {
    const target = document.querySelector(button.dataset.bsTarget);
    button.addEventListener('click', () => {
        target.classList.toggle('show');
    });
});
```

---

**14. ¿Qué significa `${pageContext.request.contextPath}/inicio`?**

**📄 Código:**
```jsp
<a class="navbar-brand" href="${pageContext.request.contextPath}/inicio">VENTADEPOR</a>
```

**✅ Respuesta:**
- **Qué hace:** Construye URL absoluta relativa al context path de la aplicación
- **Cómo funciona:** EL resuelve la expresión y concatena con "/inicio"
- **Por qué:** Para que los enlaces funcionen sin importar dónde está desplegada la app
- **Alternativas:** URL hardcoded (/tienda-deportiva/inicio), pero se rompe si cambia el deployment
- **Problemas:** Si el context path cambia, los enlaces se actualizan automáticamente
- **Mejoras:** Usar siempre esta expresión para todas las URLs internas

**🔍 URL generation:**
```java
// Si la app está en http://localhost:8080/tienda-deportiva:
// pageContext.request.contextPath = "/tienda-deportiva"
// URL generada: "/tienda-deportiva/inicio"
// Link final: "http://localhost:8080/tienda-deportiva/inicio"
```

---

## Frontend - JavaScript

### 🎯 **inicio.js - Carousel**

**15. ¿Qué hace `document.addEventListener('DOMContentLoaded', initCarousel)`?**

**📄 Código:**
```javascript
document.addEventListener('DOMContentLoaded', initCarousel);
```

**✅ Respuesta:**
- **Qué hace:** Registra la función initCarousel para que se ejecute cuando el DOM está completamente cargado
- **Cómo funciona:** El browser dispara el evento DOMContentLoaded después de parsear todo el HTML
- **Por qué:** Para asegurar que todos los elementos HTML existan antes de manipularlos
- **Alternativas:** window.onload, pero espera también a imágenes y otros recursos
- **Problemas:** Si el script se carga async, el evento puede haber ocurrido ya
- **Mejoras:** Verificar si el DOM ya está listo antes de añadir listener

**🔍 Event timing:**
```javascript
// Orden de eventos:
// 1. DOM parsing empieza
// 2. DOMContentLoaded (DOM listo, sin imágenes/css)
// 3. window.onload (todo cargado incluyendo imágenes/css)
```

---

**16. ¿Qué sucede cuando se ejecuta `const slides = document.querySelectorAll('.slides img')`?**

**📄 Código:**
```javascript
const slides = document.querySelectorAll('.slides img');
if (!slides.length) {
    return;
}
```

**✅ Respuesta:**
- **Qué hace:** Busca todos los elementos img dentro de elementos con clase .slides
- **Cómo funciona:** querySelectorAll devuelve una NodeList estática de todos los elementos que matchean
- **Por qué:** Para obtener las imágenes del carousel que se van a rotar
- **Alternativas:** getElementsByClassName, pero devuelve HTMLCollection dinámica
- **Problemas:** Si no hay slides, retorna NodeList vacío (length = 0)
- **Mejoras:** La validación !slides.length previene errores cuando no hay carousel

**🔍 NodeList vs HTMLCollection:**
```javascript
// NodeList (estática):
const slides = document.querySelectorAll('.slides img');
// slides.length no cambia aunque se añadan/eliminen elementos

// HTMLCollection (dinámica):
const slides = document.getElementsByClassName('slides')[0].getElementsByTagName('img');
// slides.length se actualiza automáticamente si cambia el DOM
```

---

**17. ¿Qué hace `setInterval(() => move(1), intervalMs)`?**

**📄 Código:**
```javascript
const startAutoplay = () => {
    stopAutoplay();
    timerId = setInterval(() => move(1), intervalMs);
};
```

**✅ Respuesta:**
- **Qué hace:** Ejecuta la función move(1) cada 5000ms (5 segundos) automáticamente
- **Cómo funciona:** setInterval registra un timer que llama repetidamente a la función
- **Por qué:** Para crear la rotación automática del carousel
- **Alternativas:** requestAnimationFrame, pero es más complejo para este caso
- **Problemas:** Si la página está en background, sigue consumiendo recursos
- **Mejoras:** Pausar autoplay cuando la página no está visible (Page Visibility API)

**🔍 Timer management:**
```javascript
// setInterval crea un timer en el event loop:
// Timer Queue: [move(1), move(1), move(1), ...]
// Cada 5000ms: move(1) se mueve a Call Stack
// Call Stack: move(1) -> ejecuta -> actualiza DOM
```

---

**18. ¿Qué significa `index = (index + step + slides.length) % slides.length`?**

**📄 Código:**
```javascript
const move = (step) => {
    index = (index + step + slides.length) % slides.length;
    render();
};
```

**✅ Respuesta:**
- **Qué hace:** Calcula el nuevo índice con wrap-around circular (si pasa el final, vuelve al inicio)
- **Cómo funciona:** El operador % (módulo) asegura que el resultado esté siempre entre 0 y slides.length-1
- **Por qué:** Para crear navegación circular infinita del carousel
- **Alternativas:** Condicional if, pero es más verboso y propenso a errores
- **Problemas:** Con step negativo grande, puede dar resultados inesperados
- **Mejoras:** La fórmula actual maneja correctamente tanto positivo como negativo

**🔍 Módulo circular:**
```javascript
// Ejemplo con 3 slides (length = 3):
// index = 2, step = 1: (2 + 1 + 3) % 3 = 6 % 3 = 0 (vuelve al inicio)
// index = 0, step = -1: (0 - 1 + 3) % 3 = 2 % 3 = 2 (va al final)
```

---

**19. ¿Qué sucede con `carousel?.addEventListener('mouseenter', stopAutoplay)`?**

**📄 Código:**
```javascript
carousel?.addEventListener('mouseenter', stopAutoplay);
carousel?.addEventListener('mouseleave', startAutoplay);
```

**✅ Respuesta:**
- **Qué hace:** Añade event listeners para pausar/reanudar el autoplay cuando el mouse entra/sale del carousel
- **Cómo funciona:** El operador ?. (optional chaining) previene error si carousel es null
- **Por qué:** Para mejor UX: el carousel se detiene cuando el usuario interactúa
- **Alternativas:** onmouseover/onmouseout attributes, pero son menos flexibles
- **Problemas:** Si el usuario toca la pantalla (móvil), no se dispara mouseenter
- **Mejoras:** Añadir touch events para dispositivos móviles

**🔍 Optional chaining:**
```javascript
// Sin optional chaining:
if (carousel) {
    carousel.addEventListener('mouseenter', stopAutoplay);
}

// Con optional chaining (?.):
carousel?.addEventListener('mouseenter', stopAutoplay);
// Si carousel es null/undefined, la expresión retorna undefined sin error
```

---

### 🎯 **carrito.js - Shopping Cart**

**20. ¿Qué hace `const ctx = window.appContext || ''`?**

**📄 Código:**
```javascript
const ctx = window.appContext || '';
```

**✅ Respuesta:**
- **Qué hace:** Obtiene el context path de la aplicación desde una variable global o usa string vacío
- **Cómo funciona:** El operador || (OR lógico) retorna el primer valor truthy
- **Por qué:** Para construir URLs correctas sin importar dónde está desplegada la app
- **Alternativas:** Usar siempre URLs relativas, pero puede ser confuso
- **Problemas:** Si window.appContext no está definido, usa string vacío (asume root context)
- **Mejoras:** Definir appContext en un template JSP para consistencia

**🔍 Context path injection:**
```jsp
<!-- En un JSP: -->
<script>
    window.appContext = '${pageContext.request.contextPath}';
</script>
```

---

**21. ¿Qué sucede cuando se ejecuta `localStorage.getItem('carrito')`?**

**📄 Código:**
```javascript
function obtenerCarrito() {
    try {
        return JSON.parse(localStorage.getItem('carrito')) || [];
    } catch (error) {
        console.error('No se pudo leer el carrito desde el almacenamiento local', error);
        return [];
    }
}
```

**✅ Respuesta:**
- **Qué hace:** Lee el carrito del almacenamiento local del browser y lo convierte de JSON a objeto
- **Cómo funciona:** localStorage almacena strings, JSON.parse convierte el string a array
- **Por qué:** Para persistir el carrito entre sesiones del usuario
- **Alternativas:** Cookies, IndexedDB, sessionStorage
- **Problemas:** Si el JSON está corrupto, JSON.parse lanza excepción
- **Mejoras:** El try-catch maneja errores y retorna array vacío

**🔍 localStorage API:**
```javascript
// localStorage almacena pares key-value (solo strings):
localStorage.setItem('carrito', JSON.stringify([{id: 1, nombre: 'Producto', cantidad: 2}]));
// localStorage: { 'carrito': '[{"id":1,"nombre":"Producto","cantidad":2}]' }

// Leer:
const carritoString = localStorage.getItem('carrito'); // '[{"id":1,...}]'
const carritoArray = JSON.parse(carritoString); // [{id:1,...}]
```

---

**22. ¿Qué significa `boton.closest('button[data-action]')`?**

**📄 Código:**
```javascript
const boton = evento.target.closest('button[data-action]');
if (!boton) {
    return;
}
const { action, index } = boton.dataset;
```

**✅ Respuesta:**
- **Qué hace:** Busca el elemento button más cercano que tenga el atributo data-action
- **Cómo funciona:** closest() recorre hacia arriba por el DOM buscando un elemento que matchee el selector
- **Por qué:** Para manejar clicks en iconos dentro de buttons (el target puede ser el icono)
- **Alternativas:** evento.target, pero falla si se hace click en elementos hijos
- **Problemas:** Si no hay un button con data-action, retorna null
- **Mejoras:** La validación if (!boton) previene errores

**🔍 Event delegation:**
```html
<button data-action="incrementar" data-index="0">
    <i class="fas fa-plus"></i>  <!-- Si se hace click aquí, target es el i -->
</button>

// evento.target = i.fas.fa-plus
// boton.closest('button[data-action]') = button con data-action
```

---

**23. ¿Qué hace `state.carrito.reduce((acumulado, producto) => {...}, 0)`?**

**📄 Código:**
```javascript
function calcularTotal(carrito) {
    return carrito.reduce((acumulado, producto) => {
        const cantidad = obtenerCantidad(producto);
        const precio = obtenerPrecio(producto);
        return acumulado + cantidad * precio;
    }, 0);
}
```

**✅ Respuesta:**
- **Qué hace:** Suma los subtotales (cantidad × precio) de todos los productos del carrito
- **Cómo funciona:** reduce() itera sobre el array, acumulando el resultado de cada iteración
- **Por qué:** Para calcular el total a pagar de forma funcional y concisa
- **Alternativas:** for loop tradicional, pero es más verboso
- **Problemas:** Con arrays muy grandes, puede ser menos eficiente que for loop
- **Mejoras:** Usar reduce para operaciones de agregación complejas

**🔍 Reduce algorithm:**
```javascript
// reduce internamente hace:
let acumulado = 0;  // valor inicial
for (let i = 0; i < carrito.length; i++) {
    const producto = carrito[i];
    const cantidad = obtenerCantidad(producto);
    const precio = obtenerPrecio(producto);
    acumulado = acumulado + cantidad * precio;  // callback return
}
return acumulado;
```

---

**24. ¿Qué sucede con `window.addEventListener('storage', (event) => {...})`?**

**📄 Código:**
```javascript
window.addEventListener('storage', (event) => {
    if (event.key === 'carrito') {
        state.carrito = obtenerCarrito();
        renderizarTodo(state);
    }
});
```

**✅ Respuesta:**
- **Qué hace:** Escucha cambios en localStorage desde otras pestañas/ventanas del mismo dominio
- **Cómo funciona:** El evento storage se dispara cuando otra pestaña modifica localStorage
- **Por qué:** Para sincronizar el carrito entre múltiples pestañas abiertas
- **Alternativas:** Polling periódico, pero es menos eficiente
- **Problemas:** No se dispara en la misma pestaña que hizo el cambio
- **Mejoras:** Combinar con storage events y actualizaciones locales

**🔍 Cross-tab synchronization:**
```javascript
// Pestaña A: modifica localStorage
localStorage.setItem('carrito', JSON.stringify(nuevoCarrito));

// Pestaña B: recibe evento storage
event.key = 'carrito'
event.newValue = '[{"id":1,...}]'
event.oldValue = '[{"id":2,...}]'
event.storageArea = localStorage
```

---

**25. ¿Qué significa `formulario.checkValidity()`?**

**📄 Código:**
```jsp
<form id="formulario-pago">
    <input type="email" required>
    <input type="tel" pattern="[0-9]{9}" required>
</form>
```

```javascript
if (ui.formulario.checkValidity()) {
    limpiarCarrito(state);
    window.location.href = `${state.ctx}/productos`;
} else {
    ui.formulario.classList.add('was-validated');
}
```

**✅ Respuesta:**
- **Qué hace:** Verifica que todos los campos del formulario cumplan con sus validaciones HTML5
- **Cómo funciona:** checkValidity() retorna true si todos los required están llenos y los patterns matchean
- **Por qué:** Para validar el formulario antes de procesar el pago
- **Alternativas:** Validación manual con JavaScript, pero es más código
- **Problemas:** La validación HTML5 puede ser limitada para casos complejos
- **Mejoras:** Combinar validación HTML5 con validación personalizada

**🔍 HTML5 validation:**
```javascript
// checkValidity() internamente verifica:
// - required: campo no está vacío
// - type="email": formato de email válido
// - pattern: matchea la regex especificada
// - min/max: número dentro del rango
// - etc.
```

---

## Frontend - Integración y Comunicación

### 🎯 **JavaScript-JSP Integration**

**26. ¿Qué hace `const ventasPorMes = ${ventasPorMesJson};` exactamente?**

**📄 Código:**
```jsp
<script>
    const ventasPorMes = ${ventasPorMesJson};
    const pedidosPorMes = ${pedidosPorMesJson};
</script>
```

**✅ Respuesta:**
- **Qué hace:** Spring convierte el objeto Java a JSON y lo incrusta directamente en el JavaScript
- **Cómo funciona:** ObjectMapper serializa el objeto y Spring lo imprime en el HTML generado
- **Por qué:** Para pasar datos estructurados del backend al frontend sin llamadas AJAX
- **Alternativas:** API REST endpoint, pero requiere una petición HTTP extra
- **Problemas:** Si el JSON tiene caracteres especiales, puede romper el JavaScript
- **Mejoras:** Usar JSON.stringify con escape proper o endpoint API

**🔍 Server-side rendering:**
```java
// En el controller:
ObjectMapper objectMapper = new ObjectMapper();
String ventasPorMesJson = objectMapper.writeValueAsString(ventasPorMesList);
model.addAttribute("ventasPorMesJson", ventasPorMesJson);

// HTML generado:
<script>
    const ventasPorMes = [100, 150, 200, 180];
</script>
```

---

**27. ¿Qué sucede cuando se ejecuta `new Chart(ctx, {...})`?**

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
            backgroundColor: 'rgba(54, 162, 235, 0.2)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
        }]
    }
});
```

**✅ Respuesta:**
- **Qué hace:** Crea una instancia de Chart.js que dibuja un gráfico de barras en el canvas
- **Cómo funciona:** Chart.js usa Canvas API para dibujar el gráfico pixel por pixel
- **Por qué:** Para visualizar datos de ventas de forma interactiva y atractiva
- **Alternativas:** D3.js (más flexible pero más complejo), CSS charts
- **Problemas:** Con muchos datos, puede ser lento y consumir mucha memoria
- **Mejoras:** Usar datasets más pequeños, lazy loading, o virtual scrolling

**🔍 Canvas rendering:**
```javascript
// Chart.js internamente usa:
const canvas = document.getElementById('ventasChart');
const ctx = canvas.getContext('2d');

// Por cada barra del gráfico:
ctx.fillStyle = 'rgba(54, 162, 235, 0.2)';  // Color de relleno
ctx.fillRect(x, y, width, height);           // Dibuja rectángulo
ctx.strokeStyle = 'rgba(54, 162, 235, 1)';  // Color del borde
ctx.strokeRect(x, y, width, height);         // Dibuja borde
```

---

**28. ¿Qué significa `document.getElementById('total').textContent = '$' + total.toFixed(2)`?**

**📄 Código:**
```javascript
document.getElementById('total').textContent = '$' + total.toFixed(2);
```

**✅ Respuesta:**
- **Qué hace:** Busca el elemento con id="total" y actualiza su contenido con el total formateado
- **Cómo funciona:** getElementById busca en el DOM, textContent actualiza solo el texto (no HTML)
- **Por qué:** Para mostrar el total del carrito formateado como moneda
- **Alternativas:** innerHTML (peligroso por XSS), innerText (menos eficiente)
- **Problemas:** Si el elemento no existe, lanza TypeError
- **Mejoras:** Validar que el elemento exista antes de usarlo

**🔍 DOM manipulation:**
```javascript
// Flujo completo:
// 1. Browser busca elemento con id="total" en el árbol DOM
// 2. Convierte total a string con 2 decimales: "123.45"
// 3. Concatena con "$": "$123.45"
// 4. Actualiza el contenido del elemento (repaint si es necesario)
```

---

**29. ¿Qué sucede con `parseFloat(document.getElementById('precio').value)`?**

**📄 Código:**
```javascript
const precio = parseFloat(document.getElementById('precio').value);
const subtotal = cantidad * precio;
```

**✅ Respuesta:**
- **Qué hace:** Convierte el string del input a número decimal para poder hacer cálculos matemáticos
- **Cómo funciona:** parseFloat analiza el string y retorna un Number o NaN si no puede convertir
- **Por qué:** Los inputs siempre retornan strings, se necesita conversión para operaciones matemáticas
- **Alternativas:** Number() constructor, parseInt() para enteros
- **Problemas:** Si el valor no es numérico o está vacío, retorna NaN
- **Mejoras:** Validar con isNaN() y proporcionar valor por defecto

**🔍 Type conversion:**
```javascript
// Input value siempre es string:
document.getElementById('precio').value  // "123.45" (string)

// parseFloat comportamiento:
parseFloat("123.45")  // 123.45 (number)
parseFloat("123")     // 123 (number)
parseFloat("abc")     // NaN (Not a Number)
parseFloat("")        // NaN
parseFloat("123abc")  // 123 (detiene en primer caracter no numérico)
```

---

**30. ¿Qué hace `addEventListener('click', function() {...})` internamente?**

**📄 Código:**
```javascript
document.querySelector('.btn-agregar').addEventListener('click', function() {
    const cantidad = parseInt(document.getElementById('cantidad').value);
    const precio = parseFloat(document.getElementById('precio').value);
    agregarAlCarrito(producto, cantidad, precio);
});
```

**✅ Respuesta:**
- **Qué hace:** Registra una función que se ejecutará cada vez que se haga click en el elemento
- **Cómo funciona:** El browser guarda el listener en una lista interna y lo ejecuta cuando ocurre el evento
- **Por qué:** Para hacer la página interactiva sin recargar, respondiendo a acciones del usuario
- **Alternativas:** onclick attribute, jQuery .click()
- **Problemas:** Si no se remueven los listeners, pueden causar memory leaks en SPA
- **Mejoras:** Usar event delegation para elementos dinámicos

**🔍 Event system:**
```javascript
// Browser internamente:
element.addEventListener = function(type, listener, options) {
    if (!this._eventListeners) {
        this._eventListeners = {};
    }
    if (!this._eventListeners[type]) {
        this._eventListeners[type] = [];
    }
    this._eventListeners[type].push(listener);
};

// Cuando ocurre el evento:
for (const listener of this._eventListeners['click']) {
    listener.call(this, event);  // Ejecuta cada listener
}
```

---

### 🎯 **AJAX y Comunicación asíncrona**

**31. ¿Qué haría `fetch('/api/productos', {...})` en este contexto?**

**📄 Código (hipotético):**
```javascript
async function cargarProductos() {
    try {
        const response = await fetch(`${ctx}/api/productos`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        });
        const productos = await response.json();
        renderizarProductos(productos);
    } catch (error) {
        console.error('Error cargando productos:', error);
    }
}
```

**✅ Respuesta:**
- **Qué hace:** Hace una petición HTTP GET asíncrona al endpoint /api/productos
- **Cómo funciona:** fetch() retorna una Promise que resuelve con la Response cuando llega
- **Por qué:** Para cargar datos dinámicamente sin recargar la página
- **Alternativas:** XMLHttpRequest (más verboso), Axios (librería externa)
- **Problemas:** Requiere CORS si es a dominio diferente
- **Mejoras:** Añadir loading states, error handling, retry logic

**🔍 Fetch API flow:**
```javascript
// Flujo de fetch:
// 1. fetch() inicia petición HTTP
// 2. Promise pending mientras espera respuesta
// 3. Response llega → Promise resuelve con Response object
// 4. response.json() parsea body y retorna Promise con data
// 5. await espera que todo termine y retorna productos
```

---

**32. ¿Qué significa `async/await` en JavaScript moderno?**

**📄 Código:**
```javascript
async function procesarPago() {
    try {
        const carrito = await obtenerCarrito();
        const total = calcularTotal(carrito);
        const resultado = await procesarPagoConTarjeta(total);
        if (resultado.exito) {
            await limpiarCarrito();
            window.location.href = '/confirmacion';
        }
    } catch (error) {
        mostrarError(error.message);
    }
}
```

**✅ Respuesta:**
- **Qué hace:** Permite escribir código asíncrono que parece síncrono, mejorando legibilidad
- **Cómo funciona:** async retorna una Promise, await pausa la ejecución hasta que la Promise resuelva
- **Por qué:** Evita el "callback hell" de .then() chains
- **Alternativas:** Promises con .then(), callbacks anidados
- **Problemas:** Si no se manejan errores correctamente, pueden ser difíciles de debuggear
- **Mejoras:** Usar try/catch para error handling, siempre en funciones async

**🔍 Async/Await transformation:**
```javascript
// Con async/await (legible):
const resultado = await fetch('/api/data');
const data = await resultado.json();

// Equivalente con Promises (más anidado):
fetch('/api/data')
    .then(response => response.json())
    .then(data => {
        // usar data aquí
    });
```

---

**33. ¿Qué sucede con `localStorage.setItem('carrito', JSON.stringify(carrito))`?**

**📄 Código:**
```javascript
function guardarCarrito(carrito) {
    localStorage.setItem('carrito', JSON.stringify(carrito));
}
```

**✅ Respuesta:**
- **Qué hace:** Convierte el array del carrito a JSON string y lo guarda en el almacenamiento local
- **Cómo funciona:** JSON.stringify convierte objetos/arrays a string, localStorage los persiste
- **Por qué:** Para mantener el carrito disponible incluso si el usuario cierra y reabre el browser
- **Alternativas:** sessionStorage (se pierde al cerrar tab), IndexedDB (más complejo)
- **Problemas:** localStorage tiene límite de ~5MB, puede lanzar excepción si se excede
- **Mejoras:** Validar quota disponible antes de guardar, manejar excepciones

**🔍 Storage mechanism:**
```javascript
// Flujo completo:
// 1. carrito = [{id:1, nombre:"Producto", cantidad:2}]
// 2. JSON.stringify(carrito) = '[{"id":1,"nombre":"Producto","cantidad":2}]'
// 3. localStorage.setItem('carrito', '[{"id":1,...}]')
// 4. Browser guarda en disco (persistente entre sesiones)
```

---

### 🎯 **Performance y Optimización**

**34. ¿Qué hace `defer` en `<script src="..." defer></script>`?**

**📄 Código:**
```jsp
<script src="${pageContext.request.contextPath}/js/inicio.js" defer></script>
```

**✅ Respuesta:**
- **Qué hace:** Indica al browser que descargue el script pero lo ejecute después de parsear el HTML
- **Cómo funciona:** El script se descarga en paralelo pero se ejecuta en orden antes de DOMContentLoaded
- **Por qué:** Para no bloquear el renderizado de la página mientras se descarga JavaScript
- **Alternativas:** async (ejecuta tan pronto como descarga, sin orden), sin atributo (bloqueante)
- **Problemas:** Si el script modifica DOM, debe esperar a que los elementos existan
- **Mejoras:** Usar defer para scripts que dependen del DOM, async para scripts independientes

**🔍 Loading strategies:**
```html
<!-- Sin atributo (blocking): -->
<script src="app.js"></script>
<!-- Descarga → Ejecuta → Continúa parsing HTML (lento) -->

<!-- Con async (non-blocking, out-of-order): -->
<script src="app.js" async></script>
<!-- Descarga en paralelo → Ejecuta inmediatamente al terminar (puede desordenar) -->

<!-- Con defer (non-blocking, in-order): -->
<script src="app.js" defer></script>
<!-- Descarga en paralelo → Ejecuta en orden antes de DOMContentLoaded (óptimo) -->
```

---

**35. ¿Qué significa `requestAnimationFrame` en animaciones?**

**📄 Código (hipotético para animaciones):**
```javascript
function animarCarousel() {
    const startTime = performance.now();
    
    function animate(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / 1000, 1); // 1 segundo de animación
        
        // Actualizar posición del carousel
        carousel.style.transform = `translateX(${targetX * progress}px)`;
        
        if (progress < 1) {
            requestAnimationFrame(animate);
        }
    }
    
    requestAnimationFrame(animate);
}
```

**✅ Respuesta:**
- **Qué hace:** Programa una función para que se ejecute en el próximo repaint del browser
- **Cómo funciona:** Se sincroniza con el refresh rate del monitor (typical 60 FPS = 16.67ms)
- **Por qué:** Para animaciones suaves y eficientes que no afectan el rendimiento
- **Alternativas:** setInterval, setTimeout (menos precisos y más ineficientes)
- **Problemas:** Si la pestaña está en background, el browser puede pausar las animaciones
- **Mejoras:** Combinar con CSS transitions para mejor rendimiento

**🔍 Animation frame timing:**
```javascript
// requestAnimationFrame loop:
// 1. Browser prepara frame (60 FPS = cada 16.67ms)
// 2. Ejecuta callbacks registrados
// 3. Calcula estilos y layout
// 4. Pinta pixels en pantalla
// 5. Repite

// vs setInterval (menos eficiente):
// setInterval(() => {
//     element.style.left = newLeft + 'px';  // Puede causar reflows/repaints innecesarios
// }, 16);
```

---

**36. ¿Qué hace `debounce` en eventos de usuario?**

**📄 Código (hipotético para search):**
```javascript
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Uso:
const buscarProductos = debounce((termino) => {
    fetch(`/api/productos?q=${termino}`)
        .then(response => response.json())
        .then(productos => renderizarProductos(productos));
}, 300);

document.getElementById('search').addEventListener('input', (e) => {
    buscarProductos(e.target.value);
});
```

**✅ Respuesta:**
- **Qué hace:** Retrasa la ejecución de una función hasta que deje de ocurrir el evento por un tiempo determinado
- **Cómo funciona:** Cancela el timeout anterior y crea uno nuevo cada vez que ocurre el evento
- **Por qué:** Para evitar hacer peticiones AJAX por cada tecla presionada en search
- **Alternativas:** throttle (ejecuta a intervalos fijos), sin optimización (peticiones por cada keystroke)
- **Problemas:** Puede hacer la UX sentirse lenta si el delay es muy grande
- **Mejoras:** Ajustar el delay según el caso de uso (300ms para search, 100ms para UI updates)

**🔍 Debounce timing:**
```javascript
// Usuario escribe "camisa":
// t=0ms: escribe "c" → timeout programado para 300ms
// t=50ms: escribe "ca" → cancela timeout anterior, programa nuevo para 350ms
// t=100ms: escribe "cam" → cancela timeout anterior, programa nuevo para 400ms
// t=400ms: usuario deja de escribir → se ejecuta la búsqueda
```

---

## 🎯 Resumen de Arquitectura Frontend

### **Stack Tecnológico:**
- **JSP/JSPF:** Server-side templating con JSTL
- **JavaScript Vanilla:** Sin frameworks, ES6+ features
- **Bootstrap 5:** CSS framework para UI responsive
- **Chart.js:** Visualización de datos
- **LocalStorage:** Persistencia client-side
- **Fetch API:** Comunicación asíncrona

### **Patrones de Diseño:**
- **Module Pattern:** Organización de código JavaScript
- **Event Delegation:** Manejo eficiente de eventos
- **Template Includes:** Reutilización de componentes JSPF
- **Progressive Enhancement:** Funcionalidad básica sin JavaScript

### **Consideraciones de Rendimiento:**
- **Lazy Loading:** Carga de imágenes bajo demanda
- **Debouncing/Throttling:** Optimización de eventos
- **LocalStorage Caching:** Reducción de peticiones
- **Script defer/loading:** Non-blocking JavaScript

### **Seguridad:**
- **XSS Prevention:** Uso de textContent vs innerHTML
- **Input Validation:** Validación client-side y server-side
- **CSRF Protection:** Tokens en formularios (Spring)
- **Content Security Policy:** Headers de seguridad

---

*Este documento cubre los aspectos fundamentales del frontend de la Tienda Deportiva UTP, explicando cómo cada tecnología y patrón contribuye a una aplicación web robusta, mantenible y con buena experiencia de usuario.*
