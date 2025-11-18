<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <%@ include file="includes/appHead.jspf" %>
    <title>Ofertas y Promociones Deportivas | VENTADEPOR - Descuentos hasta 40%</title>
    <meta name="description" content="Descubre las mejores ofertas en equipamiento deportivo. Zapatillas, ropa y accesorios con descuentos de hasta 40%. Envío gratis en compras mayores a S/ 200.">
    <meta name="keywords" content="ofertas deportivas, descuentos zapatillas, promociones ropa deportiva, equipamiento deportivo barato, Nike, Adidas, Puma">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promociones.css">
</head>
<body>
    <%@ include file="includes/navbar.jspf" %>

    <main class="container my-5">
        <!-- Banner Principal -->
        <section class="hero-banner" aria-label="Banner principal de ofertas">
            <div class="hero-content">
                <h1>Ofertas Especiales</h1>
                <p>Descuentos de hasta 40% en equipamiento deportivo</p>
                <a href="${pageContext.request.contextPath}/productos" class="cta-button" aria-label="Ver todos los productos en oferta">Comprar Ahora</a>
            </div>
        </section>

        <!-- Ofertas Destacadas -->
        <section class="ofertas-section" aria-labelledby="ofertas-titulo">
            <h2 id="ofertas-titulo" class="section-title">Destacados</h2>
            <div class="ofertas-grid">
                <article class="oferta-card">
                    <div class="oferta-badge">-30%</div>
                    <div class="oferta-icon">👟</div>
                    <h3>Calzado Deportivo</h3>
                    <p>Zapatillas Nike, Adidas y Puma con descuentos especiales</p>
                    <div class="precio-oferta">
                        <span class="precio-antes">Antes S/ 399.90</span>
                        <span class="precio-ahora">Ahora S/ 279.90</span>
                    </div>
                </article>

                <article class="oferta-card">
                    <div class="oferta-badge">-25%</div>
                    <div class="oferta-icon">👕</div>
                    <h3>Ropa Deportiva</h3>
                    <p>Polos, shorts y conjuntos para entrenar con estilo</p>
                    <div class="precio-oferta">
                        <span class="precio-antes">Antes S/ 129.90</span>
                        <span class="precio-ahora">Ahora S/ 97.90</span>
                    </div>
                </article>

                <article class="oferta-card">
                    <div class="oferta-badge">-40%</div>
                    <div class="oferta-icon">⚽</div>
                    <h3>Accesorios</h3>
                    <p>Balones, mochilas y equipamiento esencial</p>
                    <div class="precio-oferta">
                        <span class="precio-antes">Antes S/ 199.90</span>
                        <span class="precio-ahora">Ahora S/ 119.90</span>
                    </div>
                </article>
            </div>
        </section>

        <!-- Promociones por Categoría -->
        <section class="categorias-promo" aria-labelledby="categorias-titulo">
            <h2 id="categorias-titulo" class="section-title">Por Deporte</h2>
            <div class="categorias-grid">
                <article class="categoria-promo">
                    <h3><i class="fas fa-running"></i> Running</h3>
                    <p>Equipamiento para corredores</p>
                    <span class="descuento">Hasta 35% OFF</span>
                </article>
                <article class="categoria-promo">
                    <h3><i class="fas fa-dumbbell"></i> Fitness</h3>
                    <p>Todo para tu entrenamiento</p>
                    <span class="descuento">Hasta 25% OFF</span>
                </article>
                <article class="categoria-promo">
                    <h3><i class="fas fa-futbol"></i> Fútbol</h3>
                    <p>Camisetas y accesorios</p>
                    <span class="descuento">Hasta 30% OFF</span>
                </article>
                <article class="categoria-promo">
                    <h3><i class="fas fa-basketball-ball"></i> Basketball</h3>
                    <p>Zapatillas profesionales</p>
                    <span class="descuento">Hasta 20% OFF</span>
                </article>
            </div>
        </section>

        <!-- Oferta Especial -->
        <section class="oferta-especial" aria-labelledby="oferta-especial-titulo">
            <div class="oferta-especial-content">
                <div class="discount-badge">OFERTA LIMITADA</div>
                <h2 id="oferta-especial-titulo">Envío Gratis en Compras Mayores a S/ 200</h2>
                <p>Recibe tus productos sin costo adicional</p>
                <div class="countdown" role="timer" aria-label="Tiempo restante de la oferta">
                    <div class="countdown-item">
                        <span class="countdown-number" id="hours" aria-label="Horas">24</span>
                        <span class="countdown-label">Horas</span>
                    </div>
                    <div class="countdown-item">
                        <span class="countdown-number" id="minutes" aria-label="Minutos">00</span>
                        <span class="countdown-label">Minutos</span>
                    </div>
                    <div class="countdown-item">
                        <span class="countdown-number" id="seconds" aria-label="Segundos">00</span>
                        <span class="countdown-label">Segundos</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/productos" class="cta-button" aria-label="Ir a la tienda para aprovechar la oferta">Comprar Ahora</a>
            </div>
        </section>

    </main>

    <%@ include file="includes/footer.jspf" %>

    <script>
        // Countdown timer
        function updateCountdown() {
            const now = new Date().getTime();
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            tomorrow.setHours(0, 0, 0, 0);
            const distance = tomorrow.getTime() - now;

            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);

            document.getElementById("hours").textContent = hours.toString().padStart(2, '0');
            document.getElementById("minutes").textContent = minutes.toString().padStart(2, '0');
            document.getElementById("seconds").textContent = seconds.toString().padStart(2, '0');
        }

        // Update countdown every second
        setInterval(updateCountdown, 1000);
        updateCountdown();
    </script>
</body>
</html>