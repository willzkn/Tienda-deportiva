<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            <form id="formLogin" action="${pageContext.request.contextPath}/admin/login" method="post">
                <div class="input-box">
                    <label for="usuario">Usuario</label>
                    <input type="text" id="usuario" name="usuario" placeholder="Ingresa tu usuario" required>
                </div>
                <div class="input-box">
                    <label for="clave">Contraseña</label>
                    <input type="password" id="clave" name="clave" placeholder="Ingresa tu contraseña" required>
                </div>
                <button type="submit">Ingresar</button>
            </form>
            <div class="login-footer">
                ¿No tienes cuenta? <a href="${pageContext.request.contextPath}/registro">Regístrate aquí</a>
            </div>
        </div>
    </div>
  
    <%@ include file="includes/footer.jspf" %>
    <script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>