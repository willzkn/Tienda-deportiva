<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <%@ include file="includes/appHead.jspf" %>
  <title>Usuario Admin - Editar</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
</head>
<body>
  <%@ include file="includes/headerAdmin.jspf" %>
  <main class="container">
    <section class="management-panel">
      <div class="panel-header">
        <h2><c:choose><c:when test="${usuario != null && usuario.id_usuario > 0}">Editar</c:when><c:otherwise>Nuevo</c:otherwise></c:choose> Usuario Admin</h2>
        <a class="btn" href="${pageContext.request.contextPath}/admin/clientes">Volver</a>
      </div>

      <div class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/admin/clientes/guardar">
          <input type="hidden" name="id_usuario" value="${usuario.id_usuario}" />

          <div class="form-group">
            <label for="correo">Correo</label>
            <input id="correo" name="correo" type="email" required value="${usuario.correo}" />
          </div>

          <div class="form-group">
            <label for="clave">Clave</label>
            <input id="clave" name="clave" type="text" required value="${usuario.clave}" />
          </div>

          <div class="form-group">
            <label for="rol">Rol</label>
            <select id="rol" name="rol">
              <option value="Admin" ${usuario.rol == 'Admin' ? 'selected' : ''}>Admin</option>
            </select>
          </div>

          <div class="form-actions">
            <button class="btn btn-primary" type="submit">Guardar</button>
            <a class="btn" href="${pageContext.request.contextPath}/admin/clientes">Cancelar</a>
          </div>
        </form>
      </div>
    </section>
  </main>
</body>
</html>
