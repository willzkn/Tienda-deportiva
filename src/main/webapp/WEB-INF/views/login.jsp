<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="es">

    <head>
        <%@ include file="includes/appHead.jspf" %>
            <title>Login - VENTADEPOR</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>

    <body>
        <%@ include file="includes/navbar.jspf" %>

            <div class="login-container">
                <div class="login-box">
                    <h2>Iniciar Sesión</h2>

                    <%-- Mostrar mensaje de error si existe --%>
                        <% if (request.getAttribute("error") !=null) { %>
                            <div class="error-message"
                                style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 15px; border: 1px solid #f5c6cb;">
                                <%= request.getAttribute("error") %>
                            </div>
                            <% } %>

                                <form id="formLogin" action="${pageContext.request.contextPath}/admin/login"
                                    method="post">
                                    <div class="input-box">
                                        <label for="usuario">Correo Electrónico</label>
                                        <input type="text" id="usuario" name="usuario" placeholder="Ingresa tu correo"
                                            required>
                                    </div>
                                    <div class="input-box">
                                        <label for="clave">Contraseña</label>
                                        <input type="password" id="clave" name="clave"
                                            placeholder="Ingresa tu contraseña" required>
                                    </div>
                                    <button type="submit">Ingresar</button>
                                </form>
                                <div class="login-footer">
                                    ¿No tienes cuenta? <a href="${pageContext.request.contextPath}/registro">Regístrate
                                        aquí</a>
                                </div>
                </div>
            </div>

            <%@ include file="includes/footer.jspf" %>
    </body>

    </html>