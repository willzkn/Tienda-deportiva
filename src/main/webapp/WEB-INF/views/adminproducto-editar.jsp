<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <%@ include file="includes/appHead.jspf" %>
    <title>${producto.id_producto > 0 ? 'Editar Producto' : 'Nuevo Producto'} - VENTADEPOR</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/registro.css" />
</head>

<body>
    <%@ include file="includes/headerAdmin.jspf" %>

    <main class="container">
        <div class="form-box" role="main">
            <h2>${producto.id_producto > 0 ? 'Editar Producto' : 'Registrar Producto'}</h2>

            <c:if test="${not empty skuError}">
                <div style="background-color: #f8d7da; color: #721c24; padding: 12px; margin-bottom: 18px; border: 1px solid #f5c6cb; border-radius: 6px;">
                    ${skuError}
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div style="background-color: #d1e7dd; color: #0f5132; padding: 12px; margin-bottom: 18px; border: 1px solid #badbcc; border-radius: 6px;">
                    ${success}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${producto.id_producto > 0}">
                    <c:set var="formAction" value="${pageContext.request.contextPath}/admin/productos/actualizar" />
                </c:when>
                <c:otherwise>
                    <c:set var="formAction" value="${pageContext.request.contextPath}/admin/productos/guardar" />
                </c:otherwise>
            </c:choose>

            <form action="${formAction}" method="post" enctype="multipart/form-data">
                <c:if test="${producto.id_producto > 0}">
                    <input type="hidden" name="id_producto" value="${producto.id_producto}" />
                </c:if>

                <div class="form-group">
                    <label for="sku">SKU</label>
                    <input type="text" id="sku" name="sku" value="${producto.sku}" required />
                </div>

                <div class="form-group">
                    <label for="nombre">Nombre del Producto</label>
                    <input type="text" id="nombre" name="nombre" value="${producto.nombre}" required />
                </div>

                <div class="form-group">
                    <label for="id_categoria">Categoría</label>
                    <select id="id_categoria" name="id_categoria" required>
                        <option value="">Seleccione una categoría</option>
                        <c:forEach var="cat" items="${categorias}">
                            <option value="${cat.id_categoria}" ${cat.id_categoria == producto.id_categoria ? 'selected' : ''}>
                                ${cat.nombre_categoria}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="precio">Precio (S/)</label>
                    <input type="number" id="precio" name="precio" step="0.01" value="${producto.precio}" required />
                </div>

                <div class="form-group">
                    <label for="stock">Stock</label>
                    <input type="number" id="stock" name="stock" value="${producto.stock}" min="0" required />
                </div>

                <div class="form-group">
                    <label>Imagen actual</label>
                    <c:if test="${not empty producto.imagenBase64}">
                        <div style="max-width: 180px; margin-bottom: 12px;">
                            <img src="data:image/jpeg;base64,${producto.imagenBase64}" alt="${producto.nombre}" style="width: 100%; border-radius: 6px; object-fit: cover;" />
                        </div>
                    </c:if>
                    <c:if test="${empty producto.imagenBase64}">
                        <div style="max-width: 180px; height: 180px; display: flex; align-items: center; justify-content: center; background: #f0f0f0; color: #666; font-size: 12px; margin-bottom: 12px; border-radius: 6px;">
                            Sin imagen cargada
                        </div>
                    </c:if>

                    <label for="imagenFile">${producto.id_producto > 0 ? 'Cambiar imagen (opcional)' : 'Imagen del producto'}</label>
                    <input type="file" id="imagenFile" name="imagenFile" accept="image/*" ${producto.id_producto > 0 ? '' : 'required'} />
                </div>

                <div class="form-group" style="display: flex; align-items: center; gap: 10px;">
                    <input type="checkbox" id="activo" name="activo" value="true" ${producto.activo ? 'checked' : ''} />
                    <label for="activo">Producto activo</label>
                </div>

                <button type="submit" class="btn btn-primary">
                    ${producto.id_producto > 0 ? 'Actualizar Producto' : 'Guardar Producto'}
                </button>
            </form>
        </div>
    </main>
</body>

</html>