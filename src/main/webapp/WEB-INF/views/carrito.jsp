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
                                
                <form id="formulario-pago" class="border p-3 rounded bg-light needs-validation" novalidate>
                                    <!-- Datos personales -->
                                    <div class="seccion-pago mb-3">
                                        <h5><i class="fas fa-user me-2"></i> Datos Personales</h5>
                                        <div class="mb-3">
                                            <label class="form-label">Nombre</label>
                                            <input type="text" name="nombre" class="form-control" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Email</label>
                                            <input type="email" name="email" class="form-control" required>
                                        </div>
                                    </div>
                                    
                                    <!-- Dirección -->
                                    <div class="seccion-pago mb-3">
                                        <h5><i class="fas fa-map-marker-alt me-2"></i> Dirección</h5>
                                        <div class="mb-3">
                                            <label class="form-label">Dirección</label>
                                            <input type="text" name="direccion" class="form-control" required>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Ciudad</label>
                                                <input type="text" name="ciudad" class="form-control" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Código Postal</label>
                                                <input type="text" name="codigoPostal" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Pago -->
                                    <div class="seccion-pago">
                                        <h5><i class="fas fa-credit-card me-2"></i> Información de Pago</h5>
                                        <div class="mb-3">
                                            <label class="form-label">Número de Tarjeta</label>
                                            <input type="text" name="numeroTarjeta" class="form-control" required>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Fecha Expiración</label>
                                                <input type="text" name="fechaExpiracion" class="form-control" placeholder="MM/AA" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">CVV</label>
                                                <input type="text" name="cvv" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <button type="button" id="btn-continuar" class="btn btn-primary w-100 mt-3">Continuar</button>
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
                        // Definir la variable contextPath para que esté disponible en carrito.js
                        const contextPath = '${pageContext.request.contextPath}';
                    </script>
                    <script src="${pageContext.request.contextPath}/js/carrito.js"></script>
        </body>

        </html>