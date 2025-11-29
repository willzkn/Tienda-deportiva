<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="es">

        <head>
            <%@ include file="includes/appHead.jspf" %>
                <title>Carrito de Compras - VENTADEPOR</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productos.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        </head>

        <body>
            <%@ include file="includes/navbar.jspf" %>

                <main class="container my-5">
                    <h1 class="text-center mb-4">Carrito de Compras</h1>

                    <div class="row">
                        <!-- Formulario de pago (izquierda) -->
                        <div class="col-md-7">
                            <div class="contenedor-pago">
                                <h2 class="mb-3">Finalizar Compra</h2>

                                <form id="formulario-pago" class="border p-3 rounded bg-light">
                                    <div class="mb-3">
                                        <label class="form-label">Usuario</label>
                                        <input type="text" class="form-control"
                                            value="${sessionScope.nombreUsuario != null ? sessionScope.nombreUsuario : 'Invitado'}"
                                            readonly>
                                        <input type="hidden" name="email" value="${sessionScope.nombreUsuario}">
                                    </div>

                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle"></i> Al confirmar, se generará la boleta y nos
                                        pondremos en contacto contigo.
                                    </div>

                                    <button type="button" id="btn-continuar"
                                        class="btn btn-primary w-100 mt-3">Confirmar Compra</button>
                                </form>
                            </div>
                        </div>

                        <!-- Resumen de productos (derecha) -->
                        <div class="col-md-5">
                            <div class="card">
                                <div class="card-header bg-dark text-white">
                                    <h5 class="mb-0">Resumen de Compra</h5>
                                </div>
                                <div class="card-body">
                                    <div id="resumen-productos">
                                        <!-- El contenido del acordeón se generará dinámicamente con JavaScript -->
                                    </div>
                                    <div id="carrito-container" class="d-none">
                                        <!-- Contenedor original del carrito (oculto) -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

                <%@ include file="includes/footer.jspf" %>
                    <script>
                        window.appContext = '${pageContext.request.contextPath}';
                    </script>
                    <script src="${pageContext.request.contextPath}/js/carrito.js"></script>
        </body>

        </html>