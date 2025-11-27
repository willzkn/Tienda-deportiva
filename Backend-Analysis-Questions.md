# Examen de Bootstrap - Basado en Código del Proyecto

## Instrucciones
- Analiza el código proporcionado y responde las preguntas
- Todas las preguntas están basadas en el código real del proyecto VENTADEPOR
- Las respuestas se encuentran al final del documento
- Tiempo estimado: 40 minutos

---

## Sección 1: Análisis del Navbar (25 puntos)

### Código Base - navbar.jspf
```jspf
<nav class="navbar navbar-expand-lg navbar-light bg-white py-3 shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4" href="${pageContext.request.contextPath}/inicio">
            VENTADEPOR
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto gap-3">
                <li class="nav-item">
                    <a class="nav-link fw-medium" href="${pageContext.request.contextPath}/inicio">Inicio</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fw-medium" href="${pageContext.request.contextPath}/promociones">
                        <i class="fas fa-tags"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link position-relative fw-medium" href="${pageContext.request.contextPath}/carrito">
                        <i class="fas fa-shopping-cart"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="carrito-count" style="display: none;">
                            0
                        </span>
                    </a>
                </li>
                <li class="nav-item ms-2">
                    <a class="nav-link btn btn-outline-primary px-3 fw-medium" href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-user"></i>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
```

### Preguntas

**1. Explica el propósito de cada clase en la etiqueta `<nav>`:**
- `navbar`: 
- `navbar-expand-lg`: 
- `navbar-light`: 
- `bg-white`: 
- `py-3`: 
- `shadow-sm`: 

**2. ¿Qué hace el atributo `data-bs-toggle="collapse"` y cómo funciona con `data-bs-target="#navbarNav"`?**

**3. Analiza las clases del carrito de compras:**
- `position-relative`: ¿Por qué se usa en el enlace del carrito?
- `position-absolute`: ¿Por qué se usa en el span del contador?
- `translate-middle`: ¿Qué efecto visual crea?
- `top-0 start-100`: ¿Cómo posiciona el badge?

**4. ¿Qué efecto tiene `ms-auto` en `navbar-nav` y `ms-2` en el último `nav-item`?**

**5. ¿Cómo funciona el responsive design en este navbar? ¿Cuándo se colapsa?**

---

## Sección 2: Análisis de la Página de Productos (25 puntos)

### Código Base - productos.jsp
```jspf
<main class="container my-5">
    <h1 class="text-center mb-4">Nuestros Productos</h1>

    <div class="productos-layout">
        <aside class="filters-sidebar">
            <div class="filter-section">
                <h4 class="filter-title">Categorías</h4>
                <select name="categoriaId" class="sort-select" style="width: 100%;" onchange="this.form.submit()">
                    <option value="">Todas las categorías</option>
                </select>
            </div>
        </aside>

        <div class="productos-content">
            <div class="productos-header">
                <p class="productos-count"><span>${fn:length(productos)}</span> productos encontrados</p>
            </div>

            <section class="productos" id="productos-list">
                <div class="producto">
                    <img src="data:image/jpeg;base64,${p.imagenBase64}" alt="${p.nombre}">
                    <h3>${p.nombre}</h3>
                    <p class="producto-precio">S/. <fmt:formatNumber value="${p.precio}" type="number" minFractionDigits="2"/></p>
                    <button class="agregar btn btn-primary">Agregar al carrito</button>
                </div>
            </section>
        </div>
    </div>
</main>
```

### Preguntas

**6. Analiza el contenedor principal:**
- `container`: ¿Qué tipo de contenedor es y cómo se comporta?
- `my-5`: ¿Qué espaciado aplica y en qué unidades?

**7. ¿Qué hace `text-center mb-4` en el título y por qué es importante para el layout?**

**8. ¿Cómo funcionaría el sistema de grillas si quisiéramos mostrar 3 productos por fila en desktop y 1 en móvil? Escribe el código:**

**9. ¿Qué clases Bootstrap faltan en el botón "Agregar al carrito" para hacerlo más accesible y responsivo?**

**10. Si quisiéramos agregar un sistema de paginación con Bootstrap, ¿qué clases usarías? Escribe un ejemplo:**

---

## Sección 3: Análisis del Head y Configuración (20 puntos)

### Código Base - appHead.jspf
```jspf
<meta charset="UTF-8" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<meta name="description" content="VENTADEPOR - Tu tienda deportiva de confianza">
<meta name="keywords" content="deportes, ropa deportiva, zapatillas, accesorios deportivos">

<!-- CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">

<!-- Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Helvetica+Neue:wght@300;400;500;700&display=swap" rel="stylesheet">
```

### Preguntas

**11. ¿Por qué es importante el viewport meta tag y qué pasaría si se elimina?**

**12. ¿Cuál es el orden correcto de carga de CSS y por qué Bootstrap se carga primero?**

**13. ¿Qué hace `crossorigin="anonymous"` en el link de Font Awesome?**

**14. ¿Para qué sirve `preconnect` con Google Fonts y cómo mejora el rendimiento?**

**15. ¿Cómo podríamos optimizar la carga de estos recursos usando Bootstrap?**

---

## Sección 4: Preguntas de Implementación (30 puntos)

**16. Modifica el navbar para agregar un dropdown "Mi Cuenta" con las opciones "Perfil", "Pedidos", "Cerrar Sesión". Escribe el código completo:**

**17. Crea una card de producto usando Bootstrap cards que reemplace el div.producto actual:**

**18. Implementa un sistema de alertas Bootstrap para mostrar mensajes de éxito/error al agregar productos al carrito:**

**19. Crea un modal Bootstrap para confirmar la eliminación de productos del carrito:**

**20. Diseña un footer responsive usando el sistema de grillas de Bootstrap para el proyecto:**

---

## Sección 5: Depuración y Optimización (20 puntos)

**21. El navbar no se colapsa correctamente en móviles. ¿Qué clases Bootstrap faltan o están incorrectas?**

**22. Los botones no tienen espaciado adecuado. ¿Qué utilidades de Bootstrap usarías para corregirlo?**

**23. ¿Cómo harías que el layout de productos sea responsive usando las utilidades de Bootstrap sin CSS personalizado?**

**24. ¿Qué clases Bootstrap usarías para crear un loading spinner mientras cargan los productos?**

**25. ¿Cómo implementarías un sistema de tooltips Bootstrap para los iconos del navbar?**

---

---

## RESPUESTAS DETALLADAS

### Sección 1: Análisis del Navbar

**1. Propósito de cada clase en `<nav>`:**
- `navbar`: Establece el componente base de navegación con estilos fundamentales
- `navbar-expand-lg`: Expande la navbar en pantallas grandes (992px+), se colapsa en móviles
- `navbar-light`: Tema claro para texto oscuro, compatible con `bg-white`
- `bg-white`: Fondo blanco (`background-color: #fff`)
- `py-3`: Padding vertical de 1rem (16px) arriba y abajo
- `shadow-sm`: Sombra pequeña sutil para dar profundidad

**2. `data-bs-toggle="collapse"` y `data-bs-target`:**
`data-bs-toggle="collapse"` activa el plugin collapse de Bootstrap. `data-bs-target="#navbarNav"` especifica qué elemento debe colapsar/expandir. Al hacer clic, Bootstrap busca el elemento con ID "navbarNav" y alterna su visibilidad usando transiciones CSS.

**3. Análisis del carrito de compras:**
- `position-relative`: Crea un contexto de posicionamiento para el badge absoluto
- `position-absolute`: Saca el badge del flujo normal para posicionarlo sobre el icono
- `translate-middle`: Centra perfectamente el badge usando transform: translate(-50%, -50%)
- `top-0 start-100`: Posiciona el badge en la esquina superior derecha (top: 0, left: 100%)

**4. Efecto de `ms-auto` y `ms-2`:**
`ms-auto` aplica margin-start: auto (margen izquierdo automático) al `navbar-nav`, empujando todos los items hacia la derecha. `ms-2` agrega margen izquierdo de 0.5rem al último item para separarlo visualmente.

**5. Responsive design del navbar:**
Se colapsa en pantallas menores a 992px (lg). En móviles muestra solo el logo y el botón hamburguesa (navbar-toggler). El menú se oculta (collapse) y aparece como un menú vertical al hacer clic en el toggler.

### Sección 2: Análisis de Página de Productos

**6. Contenedor principal:**
- `container`: Contenedor de ancho fijo responsive (540px en sm, 720px en md, etc.)
- `my-5`: Margen vertical de 3rem (48px) arriba y abajo

**7. `text-center mb-4` en el título:**
`text-center` centra el texto horizontalmente. `mb-4` agrega margen inferior de 1.5rem, creando espacio visual apropiado antes del contenido siguiente.

**8. Sistema de grillas para 3 productos:**
```html
<div class="row g-4">
    <div class="col-12 col-md-6 col-lg-4">
        <div class="producto">Producto 1</div>
    </div>
    <div class="col-12 col-md-6 col-lg-4">
        <div class="producto">Producto 2</div>
    </div>
    <div class="col-12 col-md-6 col-lg-4">
        <div class="producto">Producto 3</div>
    </div>
</div>
```

**9. Clases faltantes en el botón:**
```html
<button class="agregar btn btn-primary w-100 py-2 d-flex align-items-center justify-content-center">
    <i class="fas fa-cart-plus me-2"></i>
    Agregar al carrito
</button>
```

**10. Sistema de paginación:**
```html
<nav aria-label="Paginación de productos">
    <ul class="pagination justify-content-center">
        <li class="page-item disabled">
            <a class="page-link" href="#" tabindex="-1">Anterior</a>
        </li>
        <li class="page-item active">
            <a class="page-link" href="#">1</a>
        </li>
        <li class="page-item">
            <a class="page-link" href="#">2</a>
        </li>
        <li class="page-item">
            <a class="page-link" href="#">3</a>
        </li>
        <li class="page-item">
            <a class="page-link" href="#">Siguiente</a>
        </li>
    </ul>
</nav>
```

### Sección 3: Análisis del Head

**11. Importancia del viewport:**
Controla cómo el contenido se muestra en móviles. Sin él, los móviles mostrarían la versión desktop (zoom out), haciendo el texto ilegible y rompiendo el layout.

**12. Orden correcto de CSS:**
Bootstrap primero porque define estilos base. Luego CSS personalizado para sobreescribir. El orden es crítico: las hojas posteriores tienen precedencia sobre las anteriores.

**13. `crossorigin="anonymous"`:**
Permite que el recurso se cargue sin enviar credenciales (cookies, HTTP auth). Necesario para CORS cuando el CDN está en dominio diferente, evitando errores de seguridad del navegador.

**14. `preconnect` para Google Fonts:**
Establece conexión TCP y TLS anticipadamente con Google Fonts. Reduce la latencia en 100-300ms al conectar antes de que se solicite el recurso, mejorando percepción de carga.

**15. Optimización con Bootstrap:**
```html
<!-- Usando utilidades Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Eliminar CSS personalizado si es posible usar utilidades -->
<!-- Lazy loading para fonts -->
<link rel="preload" href="https://fonts.googleapis.com/css2?family=Helvetica+Neue&display=swap" as="style" onload="this.onload=null;this.rel='stylesheet'">
```

### Sección 4: Implementación

**16. Dropdown Mi Cuenta:**
```html
<li class="nav-item dropdown">
    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
        <i class="fas fa-user"></i> Mi Cuenta
    </a>
    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
        <li><a class="dropdown-item" href="#"><i class="fas fa-user-circle me-2"></i> Perfil</a></li>
        <li><a class="dropdown-item" href="#"><i class="fas fa-shopping-bag me-2"></i> Pedidos</a></li>
        <li><hr class="dropdown-divider"></li>
        <li><a class="dropdown-item" href="#"><i class="fas fa-sign-out-alt me-2"></i> Cerrar Sesión</a></li>
    </ul>
</li>
```

**17. Card de producto:**
```html
<div class="col-12 col-md-6 col-lg-4 mb-4">
    <div class="card h-100">
        <img src="data:image/jpeg;base64,${p.imagenBase64}" class="card-img-top" alt="${p.nombre}">
        <div class="card-body d-flex flex-column">
            <h5 class="card-title">${p.nombre}</h5>
            <p class="card-text text-primary fw-bold fs-4">S/. <fmt:formatNumber value="${p.precio}" type="number" minFractionDigits="2"/></p>
            <div class="mt-auto">
                <button class="btn btn-primary w-100">
                    <i class="fas fa-cart-plus me-2"></i> Agregar al carrito
                </button>
            </div>
        </div>
    </div>
</div>
```

**18. Sistema de alertas:**
```html
<div id="alert-container" class="position-fixed top-0 start-50 translate-middle-x mt-3" style="z-index: 1050;">
    <!-- Alertas dinámicas -->
</div>

<script>
function showAlert(message, type = 'success') {
    const alertHtml = `
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-triangle'} me-2"></i>
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;
    document.getElementById('alert-container').insertAdjacentHTML('beforeend', alertHtml);
}
</script>
```

**19. Modal de confirmación:**
```html
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirmar Eliminación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>¿Estás seguro de que deseas eliminar este producto del carrito?</p>
                <p class="text-muted">Esta acción no se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-danger" id="confirmDelete">
                    <i class="fas fa-trash me-2"></i> Eliminar
                </button>
            </div>
        </div>
    </div>
</div>
```

**20. Footer responsive:**
```html
<footer class="bg-dark text-light py-5 mt-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-12 col-md-6 col-lg-3">
                <h5 class="h6 text-uppercase fw-bold mb-3">VENTADEPOR</h5>
                <p class="small">Tu tienda deportiva de confianza con los mejores productos del mercado.</p>
            </div>
            <div class="col-12 col-md-6 col-lg-3">
                <h5 class="h6 text-uppercase fw-bold mb-3">Enlaces Rápidos</h5>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Productos</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Promociones</a></li>
                    <li class="mb-2"><a href="#" class="text-light text-decoration-none">Contacto</a></li>
                </ul>
            </div>
            <div class="col-12 col-md-6 col-lg-3">
                <h5 class="h6 text-uppercase fw-bold mb-3">Contacto</h5>
                <ul class="list-unstyled small">
                    <li class="mb-2"><i class="fas fa-phone me-2"></i> +51 123 456 789</li>
                    <li class="mb-2"><i class="fas fa-envelope me-2"></i> info@ventadepor.com</li>
                    <li class="mb-2"><i class="fas fa-map-marker-alt me-2"></i> Lima, Perú</li>
                </ul>
            </div>
            <div class="col-12 col-md-6 col-lg-3">
                <h5 class="h6 text-uppercase fw-bold mb-3">Síguenos</h5>
                <div class="d-flex gap-3">
                    <a href="#" class="text-light fs-5"><i class="fab fa-facebook"></i></a>
                    <a href="#" class="text-light fs-5"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-light fs-5"><i class="fab fa-twitter"></i></a>
                </div>
            </div>
        </div>
        <hr class="bg-light my-4">
        <div class="text-center small">
            <p class="mb-0">&copy; 2024 VENTADEPOR. Todos los derechos reservados.</p>
        </div>
    </div>
</footer>
```

### Sección 5: Depuración y Optimización

**21. Navbar no colapsa correctamente:**
Posibles problemas:
- Falta `data-bs-target="#navbarNav"` o el ID no coincide
- No se incluye el JavaScript de Bootstrap
- Falta `aria-controls="navbarNav"` 
- El `navbar-collapse` no está dentro del `navbar`

**22. Espaciado de botones:**
```html
<!-- Usando utilidades de espaciado -->
<div class="d-flex gap-2 flex-wrap">
    <button class="btn btn-primary">Botón 1</button>
    <button class="btn btn-secondary">Botón 2</button>
    <button class="btn btn-outline-primary">Botón 3</button>
</div>
```

**23. Layout responsive sin CSS personalizado:**
```html
<div class="container">
    <div class="row g-4">
        <!-- Sidebar -->
        <div class="col-12 col-lg-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Filtros</h5>
                    <!-- Contenido filtros -->
                </div>
            </div>
        </div>
        <!-- Productos -->
        <div class="col-12 col-lg-9">
            <div class="row g-3">
                <c:forEach items="${productos}" var="p">
                    <div class="col-12 col-sm-6 col-lg-4">
                        <div class="card h-100">
                            <!-- Producto -->
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>
```

**24. Loading spinner:**
```html
<div id="loadingSpinner" class="d-flex justify-content-center py-5">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Cargando...</span>
    </div>
</div>

<script>
// Mostrar/ocultar spinner
function showLoading() {
    document.getElementById('loadingSpinner').classList.remove('d-none');
}
function hideLoading() {
    document.getElementById('loadingSpinner').classList.add('d-none');
}
</script>
```

**25. Tooltips para iconos:**
```html
<!-- Agregar atributos data-bs-toggle y title -->
<a href="#" class="nav-link" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Ver promociones">
    <i class="fas fa-tags"></i>
</a>
<a href="#" class="nav-link" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Carrito de compras">
    <i class="fas fa-shopping-cart"></i>
</a>

<!-- Inicializar tooltips -->
<script>
var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
})
</script>
```

---

## Puntuación Total: 120 puntos
- 0-71: Insuficiente
- 72-89: Regular  
- 90-107: Bueno
- 108-120: Excelente

