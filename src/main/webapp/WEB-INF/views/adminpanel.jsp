<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <%@ include file="includes/appHead.jspf" %>
  <title>VENTADEPOR — Panel de Administración</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminpanel.css" />
</head>
<body>
  <%@ include file="includes/headerAdmin.jspf" %>

  <main class="container">
    <section class="admin-panel">
      <h2>Panel de Administración</h2>
      <div class="panel-menu">
        <a href="${pageContext.request.contextPath}/admin/categorias" class="menu-item">
          <i class="fa-solid fa-users"></i>
          <span>Categorías</span>
        </a>
    
        <a href="${pageContext.request.contextPath}/admin/reportes" class="menu-item">
          <i class="fa-solid fa-chart-pie"></i>
          <span>Reportes</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/productos" class="menu-item">
          <i class="fa-solid fa-boxes-stacked"></i>
          <span>Stock Productos</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/boletas" class="menu-item">
          <i class="fa-solid fa-file-invoice-dollar"></i>
 
           <span>Boletas</span>
        </a>
      </div>
    </section>
  </main>
</body>
</html>