<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="es">

    <head>
      <%@ include file="includes/appHead.jspf" %>
        <title>Boleta - Editar</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
    </head>

    <body>
      <%@ include file="includes/headerAdmin.jspf" %>
        <main class="container">
          <section class="management-panel">
            <div class="panel-header">
              <h2>
                <c:choose>
                  <c:when test="${boleta != null && boleta.id_boleta > 0}">Editar</c:when>
                  <c:otherwise>Nueva</c:otherwise>
                </c:choose> Boleta
              </h2>
              <a class="btn" href="${pageContext.request.contextPath}/admin/boletas">Volver</a>
            </div>

            <div class="form-container">
              <form method="post" action="${pageContext.request.contextPath}/admin/boletas/guardar">
                <input type="hidden" name="id_boleta" value="${boleta.id_boleta}" />

                <div class="form-group">
                  <label for="id_usuario">Usuario</label>
                  <select id="id_usuario" name="id_usuario" class="form-control" required>
                    <option value="">Seleccione un usuario</option>
                    <c:forEach var="u" items="${usuarios}">
                      <option value="${u.id_usuario}" ${u.id_usuario==boleta.id_usuario ? 'selected' : '' }>${u.correo}
                        (ID: ${u.id_usuario})</option>
                    </c:forEach>
                  </select>
                </div>

                <div class="form-group">
                  <label for="total">Total (S/)</label>
                  <input id="total" name="total" type="number" step="0.01" min="0" required value="${boleta.total}"
                    readonly title="El total se calcula automáticamente desde los detalles de la boleta" />
                  <small style="color: #666;">El total se calcula automáticamente desde los detalles de la
                    boleta</small>
                </div>

                <div class="form-actions">
                  <button class="btn btn-primary" type="submit">Guardar</button>
                  <a class="btn" href="${pageContext.request.contextPath}/admin/boletas">Cancelar</a>
                </div>
              </form>
            </div>

            <h3>Items de la boleta</h3>
            <div class="table-container">
              <table class="clients-table">
                <thead>
                  <tr>
                    <th>ID Detalle</th>
                    <th>Producto</th>
                    <th>ID Producto</th>
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
                      <td>${d.id_producto}</td>
                      <td>${d.cantidad}</td>
                      <td>${d.precio_unitario}</td>
                      <td>${d.cantidad * d.precio_unitario}</td>
                      <td>
                        <a class="btn"
                          href="${pageContext.request.contextPath}/admin/boletas/${boleta.id_boleta}">Gestionar</a>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>

            <div class="form-actions" style="margin-top: 12px;">
              <a class="btn btn-primary"
                href="${pageContext.request.contextPath}/admin/boletas/${boleta.id_boleta}">Gestionar items
                (agregar/editar)</a>
            </div>
          </section>
        </main>
    </body>

    </html>