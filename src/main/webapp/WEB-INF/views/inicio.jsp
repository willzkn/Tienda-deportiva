<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="es">

    <head>
      <%@ include file="includes/appHead.jspf" %>
        <title>Inicio - VENTADEPOR</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/inicio.css">
    </head>

    <body>
      <%@ include file="includes/navbar.jspf" %>

        <div class="container mt-4">
          <h1>Bienvenidos a VENTADEPOR</h1>

          <div class="carousel">
            <div class="slides">
              <img src="${pageContext.request.contextPath}/images/descuento1.png" alt="Descuento 1">
              <img src="${pageContext.request.contextPath}/images/descuento2.jpeg" alt="Descuento 2">
              <img src="${pageContext.request.contextPath}/images/descuento3.jpg" alt="Descuento 3">
            </div>
            <button class="prev">&#10094;</button>
            <button class="next">&#10095;</button>
          </div>

          <!-- Sección de productos destacados -->
          <div class="row mt-5">
            <h2>Productos Destacados</h2>
            <c:if test="${not empty productosDestacados}">
              <c:forEach items="${productosDestacados}" var="producto">
                <div class="col-md-4">
                  <div class="card mb-4">
                    <img src="${pageContext.request.contextPath}${producto.imagenUrl}" class="card-img-top"
                      alt="${producto.nombre}">
                    <div class="card-body">
                      <h5 class="card-title">${producto.nombre}</h5>
                      <p class="card-text"><strong>Precio: $${producto.precio}</strong></p>
                      <a href="#" class="btn btn-primary">Ver más</a>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </c:if>
          </div>
        </div>

        <%@ include file="includes/footer.jspf" %>
        <script src="${pageContext.request.contextPath}/js/inicio.js"></script>
    </body>

    </html>