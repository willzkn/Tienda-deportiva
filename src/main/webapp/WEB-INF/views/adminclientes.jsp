<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <%@ include file="includes/appHead.jspf" %>
  <title>Gestión de Clientes - VENTADEPOR</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminclientes.css" />
</head>
<body>
  <%@ include file="includes/headerAdmin.jspf" %>

  <main class="container">
    <section class="management-panel">
      <div class="panel-header">
        <h2>Gestión de Clientes</h2>
        <a class="btn btn-add" href="${pageContext.request.contextPath}/admin/clientes/nuevo">
          <i class="fa-solid fa-plus"></i>
          Agregar Nuevo Usuario
        </a>
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
              <th>ID Usuario</th>
              <th>Correo</th>
              <th>Rol</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="cliente" items="${clientes}">
              <tr>
                <td>${cliente.id_usuario}</td>
                <td>${cliente.correo}</td>
                <td>${cliente.rol}</td>
                <td><span class="status status-active">Activo</span></td>
                <td>
                  <a class="btn btn-edit" href="${pageContext.request.contextPath}/admin/clientes/editar/${cliente.id_usuario}" title="Editar Usuario">
                    <i class="fa-solid fa-pencil"></i> Editar
                  </a>
                  <a class="btn btn-delete" href="${pageContext.request.contextPath}/admin/clientes/eliminar/${cliente.id_usuario}" onclick="return confirm('¿Estás seguro de eliminar este usuario?');" title="Eliminar Usuario">
                    <i class="fa-solid fa-trash"></i> Eliminar
                  </a>
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
