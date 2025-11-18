<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <%@ include file="includes/appHead.jspf" %>
    <title>Editar Producto - VENTADEPOR</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/registro.css"> <%-- Reutilizamos estilos --%>
</head>
<body>
    <%@ include file="includes/headerAdmin.jspf" %>
    <main class="container">
        <div class="form-box" role="main">
            <h2>Editar Producto</h2>
            <form action="${pageContext.request.contextPath}/admin/productos/actualizar" method="post" enctype="multipart/form-data">
                
                <%-- Campo oculto para enviar el ID del producto --%>
                <input type="hidden" name="id_producto" value="${producto.id_producto}">

                <div class="form-group">
                    <label for="sku">SKU</label>
                    <input type="text" id="sku" name="sku" value="${producto.sku}" required>
                </div>
                <div class="form-group">
                    <label for="nombre">Nombre del Producto</label>
                    <input type="text" id="nombre" name="nombre" value="${producto.nombre}" required>
                </div>
                <div class="form-group">
                    <label for="id_categoria">Categoría</label>
                    <select id="id_categoria" name="id_categoria" required>
                        <c:forEach var="cat" items="${categorias}">
                            <option value="${cat.id_categoria}" ${cat.id_categoria == producto.id_categoria ? 'selected' : ''}>
                                ${cat.nombre_categoria}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="precio">Precio (S/)</label>
                    <input type="number" id="precio" name="precio" value="${producto.precio}" step="0.01" required>
                </div>
                <div class="form-group">
                    <label for="stock">Stock</label>
                    <input type="number" id="stock" name="stock" value="${producto.stock}" required>
                </div>
                <div class="form-group">
                    <label>Imagen Actual</label><br>
                    <img src="${pageContext.request.contextPath}/productos/imagen/${producto.id_producto}" alt="Imagen actual" style="max-width: 150px; margin-bottom: 10px;">
                    <br>
                    <label for="imagenFile">Cambiar Imagen (opcional)</label>
                    <input type="file" id="imagenFile" name="imagenFile" accept="image/*">
                </div>
                
                <button type="submit">Actualizar Producto</button>
            </form>
        </div>
    </main>
</body>
</html>