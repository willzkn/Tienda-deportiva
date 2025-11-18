<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <%@ include file="includes/appHead.jspf" %>
  <title>Categoría - Editar</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
</head>
<body>
  <%@ include file="includes/headerAdmin.jspf" %>
  <main class="container">
    <section class="management-panel">
      <div class="panel-header">
        <h2><c:choose><c:when test="${categoria != null && categoria.id_categoria > 0}">Editar</c:when><c:otherwise>Nueva</c:otherwise></c:choose> Categoría</h2>
        <a class="btn" href="${pageContext.request.contextPath}/admin/categorias">Volver</a>
      </div>

      <div class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/admin/categorias/guardar">
          <input type="hidden" name="id_categoria" value="${categoria.id_categoria}" />

          <div class="form-group">
            <label for="nombre_categoria">Nombre</label>
            <input id="nombre_categoria" name="nombre_categoria" type="text" required value="${categoria.nombre_categoria}" />
          </div>

          <div class="form-actions">
            <button class="btn btn-primary" type="submit">Guardar</button>
            <a class="btn" href="${pageContext.request.contextPath}/admin/categorias">Cancelar</a>
          </div>
        </form>
      </div>
    </section>
  </main>
</body>
</html>
