<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <%@ include file="includes/appHead.jspf" %>
  <title>VENTADEPOR — Stock de Productos</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminproductos.css" />
</head>
<body>
  <%@ include file="includes/headerAdmin.jspf" %>
  <main class="container">
    <section class="management-panel">
      <div class="panel-header">
        <h2>Stock de Productos</h2>
        <button class="btn btn-add" id="addProductBtn">
          <i class="fa-solid fa-plus"></i>
          Agregar Nuevo Producto
        </button>
      </div>
      
      <c:if test="${not empty error}">
        <div style="background-color: #f8d7da; color: #721c24; padding: 12px; margin: 15px 0; border: 1px solid #f5c6cb; border-radius: 4px;">
          ${error}
        </div>
      </c:if>
      
      <div class="table-container">
        <table class="products-table">
          <thead>
            <tr>
              <th>Imagen</th>
              <th>SKU</th>
              <th>Nombre del Producto</th>
              <th>Categoría</th>
              <th>Precio</th>
              <th class="text-center">Stock</th>
              <th>Acciones</th>
            </tr>
          </thead>
           <tbody id="product-list">
            <c:forEach var="producto" items="${productos}">
              <tr>
                <td>
                  <img src="${pageContext.request.contextPath}/productos/imagen/${producto.id_producto}" alt="${producto.nombre}" style="width: 80px; height: 80px; object-fit: cover;">
                </td>
                <td>${producto.sku}</td>
                <td>${producto.nombre}</td>
                <td>
                    <c:forEach var="cat" items="${categorias}">
                        <c:if test="${cat.id_categoria == producto.id_categoria}">${cat.nombre_categoria}</c:if>
                    </c:forEach>
                </td>
                <td>S/ <fmt:formatNumber value="${producto.precio}" pattern="#,##0.00"/></td>
                <td class="text-center">
                  <span class="status status-instock">${producto.stock}</span>
                </td>
                <td>
                  <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/admin/productos/editar/${producto.id_producto}" class="btn btn-edit" title="Editar Producto">
                        <i class="fa-solid fa-pencil"></i> Editar
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/productos/eliminar/${producto.id_producto}" class="btn btn-delete" onclick="return confirm('¿Estás seguro de eliminar este producto?');" title="Eliminar Producto">
                        <i class="fa-solid fa-trash-can"></i> Eliminar
                    </a>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </section>
  </main>

  <div id="addProductModal" class="modal" style="display: none;">
    <div class="modal-content">
      <span class="close-button">&times;</span>
      <h2>Agregar Nuevo Producto</h2>
      <form id="addProductForm" action="${pageContext.request.contextPath}/admin/productos/guardar" method="post" enctype="multipart/form-data">
        <div class="modal-body">
            <input type="text" name="sku" placeholder="SKU" required>
            <input type="text" name="nombre" placeholder="Nombre del Producto" required>
            <select name="id_categoria" required>
                <option value="">Selecciona una categoría</option>
                <c:forEach var="cat" items="${categorias}">
                    <option value="${cat.id_categoria}">${cat.nombre_categoria}</option>
                </c:forEach>
            </select>
            <input type="number" name="precio" placeholder="Precio (S/)" step="0.01" required>
            <input type="number" name="stock" placeholder="Stock" required>
            <label for="imagenFile">Imagen del Producto:</label>
            <input type="file" id="imagenFile" name="imagenFile" accept="image/*" required>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-cancel">Cancelar</button>
          <button type="submit" class="btn">Guardar Producto</button>
        </div>
      </form>
    </div>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', function() {
        const modal = document.getElementById('addProductModal');
        const addBtn = document.getElementById('addProductBtn');
        const closeBtn = document.querySelector('.close-button');
        const cancelBtn = document.querySelector('.btn-cancel');

        if (addBtn) {
            addBtn.onclick = () => modal.style.display = 'flex';
        }
        if (closeBtn) {
            closeBtn.onclick = () => modal.style.display = 'none';
        }
        if (cancelBtn) {
            cancelBtn.onclick = () => modal.style.display = 'none';
        }
        window.onclick = (event) => {
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    });
  </script>
</body>
</html>