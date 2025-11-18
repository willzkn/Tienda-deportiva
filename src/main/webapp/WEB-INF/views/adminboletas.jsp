<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <%@ include file="includes/appHead.jspf" %>
  <title>Boletas - VENTADEPOR</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminboletas.css" />
</head>
<body>
  <%@ include file="includes/headerAdmin.jspf" %>

  <main class="container">
    <section class="management-panel">
      <div class="panel-header">
        <h2>Historial de Boletas</h2>
        <a class="btn btn-add" href="${pageContext.request.contextPath}/admin/boletas/nuevo">Nueva Boleta</a>
      </div>

      <div class="table-container">
        <table class="clients-table">
          <thead>
            <tr>
              <th>ID Boleta</th>
              <th>Usuario (correo)</th>
              <th>Fecha Emisión</th>
              <th>Total</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="boleta" items="${boletas}">
              <tr>
                <td>${boleta.id_boleta}</td>
                <td>${boleta.usuario_correo}</td>
                <td>${boleta.fecha_emision}</td>
                <td>S/ <fmt:formatNumber value="${boleta.total}" pattern="#0.00"/></td>
                <td>
                  <a class="btn" href="${pageContext.request.contextPath}/admin/boletas/${boleta.id_boleta}">Detalle</a>
                  <a class="btn btn-edit" href="${pageContext.request.contextPath}/admin/boletas/editar/${boleta.id_boleta}">Editar</a>
                  <a class="btn btn-delete" href="${pageContext.request.contextPath}/admin/boletas/eliminar/${boleta.id_boleta}" onclick="return confirm('¿Estás seguro de eliminar esta boleta y todos sus detalles?');">Eliminar</a>
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
