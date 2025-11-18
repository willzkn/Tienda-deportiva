<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <%@ include file="includes/appHead.jspf" %>
  <title>Nosotros - VENTADEPOR</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nosotros.css">
</head>
<body>
  <%@ include file="includes/navbar.jspf" %>

  <main>
    <section class="hero">
      <div>
        <h1>CONÓCENOS</h1>
        <p>Contamos con profesionales altamente capacitados</p>
      </div>
    </section>

    <section class="descripcion">
      <div class="container">
        <p>
          Somos una empresa de consultoría que brinda servicios especializados 
          en diferentes áreas. Ofrecemos ideas y soluciones innovadoras 
          orientadas a generar valor para nuestros clientes.
        </p>
      </div>
    </section>

    <section class="mision-vision">
      <div class="container d-flex flex-wrap justify-content-center gap-4">
        <div class="card mision">
          <h2>MISIÓN</h2>
          <p>
            Ofrecer desarrollos, soluciones y productos de innovación tecnológica 
            acordes a las necesidades del cliente, dando el servicio, la capacitación 
            y el soporte necesarios para generar valor y confianza en cada proyecto.
          </p>
        </div>
        <div class="card vision">
          <h2>VISIÓN</h2>
          <p>
            Ser una empresa líder en el mercado nacional e internacional, 
            ofreciendo soluciones estratégicas e innovadoras que marquen la diferencia 
            y generen crecimiento sostenible para nuestros clientes.
  </main>

  <%@ include file="includes/footer.jspf" %>
</body>
</html>
