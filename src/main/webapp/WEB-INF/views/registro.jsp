<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <%@ include file="includes/appHead.jspf" %>
    <title>Postulación de Proveedores - VENTADEPOR</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/registro.css">
</head>
<body>
    <%@ include file="includes/navbar.jspf" %>
    
    <div class="form-box" role="main">
    <h2>Postulación de Proveedores</h2>
    <p class="note">
      Completa tu solicitud para unirte a nuestra red (tipo Equinox / distribuidor autorizado). <br>
      <strong>Maqueta visual</strong>: no se envía a servidor.
    </p>
    <form id="formProveedor" novalidate>
      <div class="grid">
        <div class="row">
          <label for="razon">Razón Social</label>
          <input id="razon" type="text" placeholder="Ej: Deporte & Performance S.A.C." required>
        </div>
        <div class="row">
          <label for="ruc">RUC (11 dígitos)</label>
          <input id="ruc" type="text" inputmode="numeric" maxlength="11" placeholder="20XXXXXXXXX" required>
        </div>
        <div class="row">
          <label for="contacto">Contacto Comercial</label>
          <input id="contacto" type="text" placeholder="Nombre y Apellido" required>
        </div>
        <div class="row">
          <label for="correo">Correo</label>
          <input id="correo" type="email" placeholder="contacto@empresa.com" required>
        </div>
        <div class="row">
          <label for="telefono">Teléfono (9 dígitos)</label>
          <input id="telefono" type="text" inputmode="numeric" maxlength="9" placeholder="9XXXXXXXX" required>
        </div>
        <div class="row">
          <label for="departamento">Departamento</label>
          <select id="departamento" required>
            <option value="">Selecciona…</option>
            <option>Lima</option><option>Arequipa</option><option>La Libertad</option>
            <option>Piura</option><option>Lambayeque</option><option>Cusco</option>
            <option>Junín</option><option>Ancash</option><option>Callao</option>
          </select>
        </div>
        <div class="row">
          <label for="distrito">Distrito / Ciudad</label>
          <input id="distrito" type="text" placeholder="Ej: Los Olivos" required>
        </div>
      </div>
      <div class="row">
          <label for="Tipodeproveedor">Tipo de proveedor</label>
          <input id="Tipodeproveedor" type="text" placeholder="Ej: Nacional o Exntrajero" required>
      </div>

      <div class="grid grid-1">
      </div>
      <div class="row">
        <label><input type="checkbox" id="acepto" required> Confirmo veracidad y acepto términos.</label>
      </div>
      <div class="actions">
        <button type="submit">Enviar Solicitud</button>
        <button type="button" id="btnCancelar">Cancelar</button>
      </div>
      <p class="note">¿Ya eres proveedor? <a href="${pageContext.request.contextPath}/login" class="link">Inicia sesión</a></p>
    </form>
  </div>
  <%@ include file="includes/footer.jspf" %>
  <script src="${pageContext.request.contextPath}/js/registro.js" defer></script>
</body>
</html>
