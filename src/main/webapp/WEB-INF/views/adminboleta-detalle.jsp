<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <%@ include file="includes/appHead.jspf" %>
  <title>Detalle Boleta</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
</head>
<body>
  <%@ include file="includes/headerAdmin.jspf" %>
  <main class="container">
    <section class="management-panel">
      <div class="panel-header">
        <h2>Boleta #${boleta.id_boleta}</h2>
        <a class="btn" href="${pageContext.request.contextPath}/admin/boletas">Volver</a>
      </div>
      <div class="info">
        <p><strong>Usuario:</strong> ${boleta.usuario_correo}</p>
        <p><strong>Fecha:</strong> ${boleta.fecha_emision}</p>
        <p><strong>Total:</strong> S/ <fmt:formatNumber value="${boleta.total}" pattern="#0.00"/></p>
      </div>

      <h3>Items</h3>
      <div class="table-container">
        <table class="clients-table">
          <thead>
            <tr>
              <th>ID Detalle</th>
              <th>Producto</th>
              <th>Cantidad</th>
              <th>Precio Unitario</th>
              <th>Subtotal</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="d" items="${detalles}">
              <tr>
                <td>${d.id_detalle_boleta}</td>
                <td>${d.producto_nombre}</td>
                <td>${d.cantidad}</td>
                <td>S/ <fmt:formatNumber value="${d.precio_unitario}" pattern="#0.00"/></td>
                <td>S/ <fmt:formatNumber value="${d.cantidad * d.precio_unitario}" pattern="#0.00"/></td>
                <td>
                  <a class="btn btn-edit" href="${pageContext.request.contextPath}/admin/boletas/${boleta.id_boleta}/detalle/editar/${d.id_detalle_boleta}">Editar</a>
                  <a class="btn btn-delete" href="${pageContext.request.contextPath}/admin/boletas/detalle/eliminar/${d.id_detalle_boleta}" onclick="return confirm('¿Estás seguro de eliminar este item?');">Eliminar</a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>

      <h3>Agregar/Editar Item</h3>
      <div class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/admin/boletas/${boleta.id_boleta}/detalle/guardar">
          <input type="hidden" name="id_detalle_boleta" value="${detalle.id_detalle_boleta}" />
          <div class="form-group">
            <label for="id_producto">Producto</label>
            <select id="id_producto" name="id_producto" required onchange="actualizarPrecio()">
              <option value="">Seleccione un producto</option>
              <c:forEach var="p" items="${productos}">
                <option value="${p.id_producto}" data-precio="${p.precio}"<c:if test="${detalle != null && p.id_producto == detalle.id_producto}"> selected</c:if>>${p.nombre} - S/ ${p.precio}</option>
              </c:forEach>
            </select>
          </div>
          <div class="form-group">
            <label for="cantidad">Cantidad</label>
            <input id="cantidad" name="cantidad" type="number" min="1" required value="${detalle.cantidad > 0 ? detalle.cantidad : 1}" />
          </div>
          <div class="form-group">
            <label for="precio_unitario">Precio Unitario (S/)</label>
            <input id="precio_unitario" name="precio_unitario" type="number" step="0.01" min="0" required value="${detalle.precio_unitario}" />
          </div>
          <div class="form-actions">
            <button class="btn btn-primary" type="submit">Guardar Item</button>
            <a class="btn" href="${pageContext.request.contextPath}/admin/boletas/${boleta.id_boleta}">Nuevo item</a>
          </div>
        </form>
      </div>
      
      <script>
        function actualizarPrecio() {
          const select = document.getElementById('id_producto');
          const precioInput = document.getElementById('precio_unitario');
          const selectedOption = select.options[select.selectedIndex];
          
          if (selectedOption && selectedOption.dataset.precio) {
            precioInput.value = selectedOption.dataset.precio;
          }
        }
        
        // Inicializar precio si hay un producto seleccionado
        window.addEventListener('DOMContentLoaded', function() {
          const precioInput = document.getElementById('precio_unitario');
          if (!precioInput.value || precioInput.value === '0' || precioInput.value === '0.0') {
            actualizarPrecio();
          }
        });
      </script>
    </section>
  </main>
</body>
</html>
