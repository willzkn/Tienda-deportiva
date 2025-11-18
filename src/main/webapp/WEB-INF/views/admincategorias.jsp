<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <%@ include file="includes/appHead.jspf" %>
  <title>Gestión de Categorías - VENTADEPOR</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
</head>
<body>
  <%@ include file="includes/headerAdmin.jspf" %>
  <main class="container">
    <section class="management-panel">
      <div class="panel-header">
        <h2>Categorías</h2>
        <a class="btn btn-add" href="${pageContext.request.contextPath}/admin/categorias/nuevo">Nuevo</a>
      </div>
      
      <c:if test="${not empty error}">
        <div style="background-color: #f8d7da; color: #721c24; padding: 12px; margin: 15px 0; border: 1px solid #f5c6cb; border-radius: 4px;">
          ${error}
        </div>
      </c:if>
      
      <div class="table-container">
        <table class="clients-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Nombre</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="cat" items="${categorias}">
              <tr>
                <td>${cat.id_categoria}</td>
                <td>${cat.nombre_categoria}</td>
                <td>
                  <a class="btn btn-edit" href="${pageContext.request.contextPath}/admin/categorias/editar/${cat.id_categoria}">Editar</a>
                  <a class="btn btn-delete" href="${pageContext.request.contextPath}/admin/categorias/eliminar/${cat.id_categoria}" onclick="return confirm('¿Estás seguro de eliminar esta categoría? Esto puede afectar los productos asociados.');">Eliminar</a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </section>
  </main>
</body>
</html>
