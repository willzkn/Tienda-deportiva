<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <%@ include file="includes/appHead.jspf" %>
    <title>Nuestros Productos - VENTADEPOR</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productos.css">
</head>
<body>
    <%@ include file="includes/navbar.jspf" %>

    <main class="container my-5">
        <h1 class="text-center mb-4">Nuestros Productos</h1>

        <div class="productos-layout">
            <aside class="filters-sidebar">
                 <form action="${pageContext.request.contextPath}/productos" method="GET">
                    <div class="filters-header">
                        <h3>Filtros</h3>
                    </div>

                    
 <div class="filter-section">
                        <h4 class="filter-title">Categorías</h4>
                        <select name="categoriaId" class="sort-select" style="width: 100%;" onchange="this.form.submit()">
                            <option value="">Todas las categorías</option>
                            <c:forEach var="cat" items="${categorias}">
                                <option value="${cat.id_categoria}" ${cat.id_categoria == selectedCategoriaId ? 'selected' : ''}>
                                    ${cat.nombre_categoria}
                                </option>
                            </c:forEach>
                         </select>
                    </div>

                    <div class="filter-section">
                        <h4 class="filter-title">Ordenar por</h4>
                         <select name="sortBy" class="sort-select" style="width: 100%;" onchange="this.form.submit()">
                            <option value="relevancia" ${'relevancia' == selectedSortBy ? 'selected' : ''}>Relevancia</option>
                            <option value="precio-asc" ${'precio-asc' == selectedSortBy ? 'selected' : ''}>Precio: Menor a Mayor</option>
                            <option value="precio-desc" ${'precio-desc' == selectedSortBy ? 'selected' : ''}>Precio: Mayor a Menor</option>
                            <option value="nombre" ${'nombre' == selectedSortBy ? 'selected' : ''}>Nombre A-Z</option>
                        </select>
                    </div>
                    
                    <a href="${pageContext.request.contextPath}/productos" class="btn-clear" style="display: block; text-align: center; margin-top: 15px;">Limpiar Filtros</a>
                 </form>
            </aside>

            <div class="productos-content">
                <div class="productos-header">
                    <p class="productos-count"><span>${fn:length(productos)}</span> productos encontrados</p>
                </div>

       
                 <section class="productos" id="productos-list">
                    <c:choose>
                        <c:when test="${not empty productos}">
                            <c:forEach items="${productos}" var="p">
            
                                 <div class="producto">
                                    <c:choose>
                                        <c:when test="${not empty p.imagenBase64}">
                                            <img src="data:image/jpeg;base64,${p.imagenBase64}" alt="${p.nombre}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/images/default-product.png" alt="Imagen no disponible" class="producto-imagen-placeholder">
                                        </c:otherwise>
                                    </c:choose>
                                    <h3>${p.nombre}</h3>
     
                                     <p class="producto-precio">S/. <fmt:formatNumber value="${p.precio}" type="number" minFractionDigits="2"/></p>
                                    <button class="agregar btn btn-primary">Agregar al carrito</button>
                                </div>
                        
                             </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="grid-column: 1/-1; text-align: center; padding: 40px;">
              
                                 <p>No se encontraron productos con los filtros seleccionados.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
   
                 </section>
            </div>
        </div>
    </main>

    <%@ include file="includes/footer.jspf" %>
    <script src="${pageContext.request.contextPath}/js/productos.js"></script>
</body>
</html>