<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <%@ include file="includes/appHead.jspf" %>
    <title>Contacto - VENTADEPOR</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contacto.css">
</head>
<body>
    <%@ include file="includes/navbar.jspf" %>

  <main class="contact-container">
    <div class="container py-5">
      <div class="text-center mb-5">
        <h1 class="contact-title">Ponte en Contacto</h1>
        <p class="lead">Nos encantaría saber de ti. Utiliza nuestra información de contacto.</p>
      </div>
      <div class="row g-4 justify-content-center">
        <div class="col-lg-5">
          <div class="info-wrapper">
            <h3 class="mb-4">Información de Contacto</h3>
            <ul class="list-unstyled">
              <li class="d-flex align-items-start mb-4">
                <span class="icon me-3">📍</span>
                <div>
                  <strong>Dirección:</strong><br>
                  Av. Principal 123, Lima, Perú
                </div>
              </li>
              <li class="d-flex align-items-start mb-4">
                <span class="icon me-3">📞</span>
                <div>
                  <strong>Teléfono:</strong><br>
                  +51 987 654 321
                </div>
              </li>
              <li class="d-flex align-items-start">
                <span class="icon me-3">✉️</span>
                <div>
                  <strong>Email:</strong><br>
                  contacto@ventadepor.com
                </div>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </main>

  <%@ include file="includes/footer.jspf" %>
</body>
</html>
