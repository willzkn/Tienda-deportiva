<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html lang="es">

  <head>
    <%@ include file="includes/appHead.jspf" %>
      <title>Registro - VENTADEPOR</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
  </head>

  <body>
    <%@ include file="includes/navbar.jspf" %>

      <div class="contenedor-login">
        <div class="logo-login">
          <h1>VENTADEPOR</h1>
        </div>

        <div class="formulario-login">
          <h2>Crear Cuenta</h2>

          <% if (request.getAttribute("error") !=null) { %>
            <div class="alert alert-danger" role="alert">
              <%= request.getAttribute("error") %>
            </div>
            <% } %>

              <% if (request.getAttribute("success") !=null) { %>
                <div class="alert alert-success" role="alert">
                  <%= request.getAttribute("success") %>
                </div>
                <% } %>

                  <form action="${pageContext.request.contextPath}/registro" method="post">
                    <div class="mb-3">
                      <label for="correo" class="form-label">Correo Electrónico</label>
                      <input type="email" class="form-control" id="correo" name="correo" placeholder="tu@email.com"
                        required>
                    </div>

                    <div class="mb-3">
                      <label for="clave" class="form-label">Contraseña</label>
                      <input type="password" class="form-control" id="clave" name="clave"
                        placeholder="Mínimo 6 caracteres" minlength="6" required>
                    </div>

                    <div class="mb-3">
                      <label for="confirmarClave" class="form-label">Confirmar Contraseña</label>
                      <input type="password" class="form-control" id="confirmarClave" name="confirmarClave"
                        placeholder="Repite tu contraseña" minlength="6" required>
                    </div>

                    <button type="submit" class="btn-login">Crear Cuenta</button>
                  </form>

                  <p class="texto-alternativo">
                    ¿Ya tienes cuenta? <a href="${pageContext.request.contextPath}/login">Inicia sesión</a>
                  </p>
        </div>
      </div>

      <%@ include file="includes/footer.jspf" %>

        <script>
          // Validar que las contraseñas coincidan
          const form = document.querySelector('form');
          form.addEventListener('submit', function (e) {
            const clave = document.getElementById('clave').value;
            const confirmarClave = document.getElementById('confirmarClave').value;

            if (clave !== confirmarClave) {
              e.preventDefault();
              alert('Las contraseñas no coinciden');
            }
          });
        </script>
  </body>

  </html>