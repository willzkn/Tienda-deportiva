<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="es">

    <head>
      <%@ include file="includes/appHead.jspf" %>
        <title>Reportes - VENTADEPOR</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminreporte.css" />
    </head>

    <body>
      <%@ include file="includes/headerAdmin.jspf" %>

        <main class="container">
          <section class="reports-panel">
            <div class="panel-header">
              <h2>Dashboard de Métricas</h2>
            </div>

            <!-- 5 Métricas Principales con Gráficos Integrados -->
            <div class="metrics-grid">

              <!-- Métrica 1: Ingresos Totales con Gráfico de Tendencia -->
              <div class="metric-card full-width">
                <div class="metric-header">
                  <div class="metric-info-header">
                    <h3><i class="fa-solid fa-chart-line"></i> Ingresos Totales</h3>
                    <p class="metric-value">S/ ${ingresosGenerados}</p>
                  </div>
                </div>
                <div class="metric-chart">
                  <canvas id="ingresosChart" height="60"></canvas>
                </div>
              </div>

              <!-- Métrica 2: Pedidos por Mes -->
              <div class="metric-card">
                <div class="metric-info">
                  <h3><i class="fa-solid fa-shopping-cart"></i> Pedidos Mensuales</h3>
                  <p class="metric-value">${pedidosMes != null ? pedidosMes : 0}</p>
                  <p class="metric-subtitle">Mes: ${selectedMes} | Promedio: ${promedioPedidosMensuales} pedidos/mes</p>
                </div>
                <div class="metric-chart">
                  <canvas id="pedidosChart" height="80"></canvas>
                </div>
              </div>

              <!-- Métrica 3: Categoría Más Vendida -->
              <div class="metric-card">
                <div class="metric-info">
                  <h3><i class="fa-solid fa-layer-group"></i> Top Categoría</h3>
                  <p class="metric-value-small">${mayorCategoriaVendida != null ? mayorCategoriaVendida : '-'}</p>
                  <p class="metric-subtitle">${cantidadMayorCategoria != null ? cantidadMayorCategoria : 0} unidades</p>
                </div>
                <div class="metric-chart">
                  <canvas id="categoriasChart" height="80"></canvas>
                </div>
              </div>

              <!-- Métrica 4: Mejor Producto del Mes -->
              <div class="metric-card">
                <div class="metric-info">
                  <h3><i class="fa-solid fa-trophy"></i> Producto Destacado</h3>
                  <p class="metric-value-small">${mejorProductoMes != null ? mejorProductoMes : '-'}</p>
                  <p class="metric-subtitle">${cantidadMejorProductoMes != null ? cantidadMejorProductoMes : 0} unidades
                    vendidas</p>
                </div>
              </div>

              <!-- Métrica 5: Mes con Mayores Ventas -->
              <div class="metric-card">
                <div class="metric-info">
                  <h3><i class="fa-solid fa-calendar-check"></i> Mejor Mes</h3>
                  <p class="metric-value">${mayorMesVentas != null ? mayorMesVentas : '-'}</p>
                  <p class="metric-subtitle">Mayor volumen de ventas</p>
                </div>
              </div>

            </div>

            <!-- Sección de Comparación entre Meses -->
            <div class="comparison-section">
              <h2><i class="fa-solid fa-code-compare"></i> Comparación entre Meses</h2>

              <form method="get" action="${pageContext.request.contextPath}/admin/reportes" class="comparison-form">
                <div class="form-group">
                  <label for="mes">Seleccionar Mes:</label>
                  <select id="mes" name="mes" onchange="cambiarMes(this.value)">
                    <c:forEach var="m" items="${mesesDisponibles}">
                      <option value="${m}" ${m==selectedMes ? 'selected' : '' }>${m}</option>
                    </c:forEach>
                  </select>
                </div>
              </form>

              <div class="comparison-grid">
                <div class="comparison-card">
                  <h4>Ingresos del Mes</h4>
                  <p class="comparison-value">S/ ${ingresosMes != null ? ingresosMes : '0.00'}</p>
                  <canvas id="comparacionIngresosChart" height="200"></canvas>
                </div>

                <div class="comparison-card">
                  <h4>Pedidos del Mes</h4>
                  <p class="comparison-value">${pedidosMes != null ? pedidosMes : 0}</p>
                  <canvas id="comparacionPedidosChart" height="200"></canvas>
                </div>
              </div>
            </div>

          </section>
        </main>

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

        <script>
          // Datos desde el servidor
          const ventasPorMes = ${ ventasPorMesJson };
          const pedidosPorMes = ${ pedidosPorMesJson };
          const unidadesPorCategoria = ${ unidadesPorCategoriaJson };
          let selectedMes = '${selectedMes}'; // Usar 'let' para poder modificarlo

          // Configuración común optimizada
          const chartOptions = {
            responsive: true,
            maintainAspectRatio: false,
            animation: { duration: 300 },  // Reducir animación
            plugins: { legend: { display: false } }
          };

          // Preparar datos una sola vez
          const mesesArray = Object.keys(ventasPorMes);
          const ingresosArray = Object.values(ventasPorMes);
          const pedidosArray = Object.values(pedidosPorMes);

          // 1. Gráfico de Ingresos (optimizado)
          new Chart(document.getElementById('ingresosChart'), {
            type: 'line',
            data: {
              labels: mesesArray,
              datasets: [{
                data: ingresosArray,
                borderColor: '#0d6efd',
                backgroundColor: 'rgba(13, 110, 253, 0.1)',
                borderWidth: 2,
                fill: true,
                tension: 0.4,
                pointRadius: 2,
                pointHoverRadius: 4
              }]
            },
            options: {
              ...chartOptions,
              scales: {
                y: { beginAtZero: true, ticks: { callback: v => 'S/ ' + v.toFixed(0), maxTicksLimit: 5 } },
                x: { ticks: { maxRotation: 45, minRotation: 45, maxTicksLimit: 8 } }
              }
            }
          });

          // 2. Gráfico de Pedidos
          new Chart(document.getElementById('pedidosChart'), {
            type: 'bar',
            data: {
              labels: mesesArray,
              datasets: [{ data: pedidosArray, backgroundColor: '#198754', borderRadius: 4 }]
            },
            options: {
              ...chartOptions,
              scales: { y: { beginAtZero: true, ticks: { stepSize: 1, maxTicksLimit: 5 } } }
            }
          });

          // 3. Gráfico de Categorías (top 5 para mejor rendimiento)
          const categoriasTop = Object.entries(unidadesPorCategoria).sort((a, b) => b[1] - a[1]).slice(0, 5);
          new Chart(document.getElementById('categoriasChart'), {
            type: 'doughnut',
            data: {
              labels: categoriasTop.map(e => e[0]),
              datasets: [{
                data: categoriasTop.map(e => e[1]),
                backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#dc3545', '#6f42c1'],
                borderWidth: 2,
                borderColor: '#fff'
              }]
            },
            options: {
              ...chartOptions,
              plugins: {
                legend: { display: true, position: 'bottom', labels: { boxWidth: 10, font: { size: 9 }, padding: 6 } }
              }
            }
          });

          // Variables globales para los gráficos de comparación
          let chartComparacionIngresos;
          let chartComparacionPedidos;

          // 4. Comparación de Ingresos
          chartComparacionIngresos = new Chart(document.getElementById('comparacionIngresosChart'), {
            type: 'bar',
            data: {
              labels: mesesArray,
              datasets: [{
                data: ingresosArray,
                backgroundColor: mesesArray.map(m => m === selectedMes ? '#0d6efd' : '#e0e0e0'),
                borderRadius: 4,
                barThickness: 30,
                maxBarThickness: 40
              }]
            },
            options: {
              ...chartOptions,
              maintainAspectRatio: true,
              aspectRatio: 2.5,
              scales: {
                y: {
                  beginAtZero: true,
                  ticks: { callback: v => 'S/ ' + v.toFixed(0), maxTicksLimit: 6 }
                },
                x: {
                  ticks: { maxRotation: 45, minRotation: 45 }
                }
              }
            }
          });

          // 5. Comparación de Pedidos
          chartComparacionPedidos = new Chart(document.getElementById('comparacionPedidosChart'), {
            type: 'bar',
            data: {
              labels: mesesArray,
              datasets: [{
                data: pedidosArray,
                backgroundColor: mesesArray.map(m => m === selectedMes ? '#198754' : '#e0e0e0'),
                borderRadius: 4,
                barThickness: 30,
                maxBarThickness: 40
              }]
            },
            options: {
              ...chartOptions,
              maintainAspectRatio: true,
              aspectRatio: 2.5,
              scales: {
                y: {
                  beginAtZero: true,
                  ticks: { stepSize: 1, maxTicksLimit: 6 }
                },
                x: {
                  ticks: { maxRotation: 45, minRotation: 45 }
                }
              }
            }
          });
          // Función para cambiar el mes sin recargar la página
          function cambiarMes(nuevoMes) {
            console.log('Cambiando a mes:', nuevoMes); // Debug

            // Actualizar el mes seleccionado globalmente
            selectedMes = nuevoMes;

            // Actualizar los valores mostrados
            const ingresosMesValor = ventasPorMes[nuevoMes] || 0;
            const pedidosMesValor = pedidosPorMes[nuevoMes] || 0;

            console.log('Ingresos:', ingresosMesValor, 'Pedidos:', pedidosMesValor); // Debug

            // Actualizar los textos en las tarjetas de comparación
            const ingresosCard = document.querySelector('.comparison-grid .comparison-card:nth-child(1) .comparison-value');
            const pedidosCard = document.querySelector('.comparison-grid .comparison-card:nth-child(2) .comparison-value');

            if (ingresosCard) {
              ingresosCard.textContent = 'S/ ' + ingresosMesValor.toFixed(2);
            }
            if (pedidosCard) {
              pedidosCard.textContent = pedidosMesValor;
            }

            // Actualizar colores de las barras en el gráfico de ingresos
            const nuevosColoresIngresos = mesesArray.map(m => m === nuevoMes ? '#0d6efd' : '#e0e0e0');
            chartComparacionIngresos.data.datasets[0].backgroundColor = nuevosColoresIngresos;
            chartComparacionIngresos.update('none');

            // Actualizar colores de las barras en el gráfico de pedidos
            const nuevosColoresPedidos = mesesArray.map(m => m === nuevoMes ? '#198754' : '#e0e0e0');
            chartComparacionPedidos.data.datasets[0].backgroundColor = nuevosColoresPedidos;
            chartComparacionPedidos.update('none');

            // Calcular promedio de pedidos
            const totalPedidos = Object.values(pedidosPorMes).reduce((a, b) => a + b, 0);
            const promedio = (totalPedidos / Object.keys(pedidosPorMes).length).toFixed(1);

            // Actualizar la métrica de "Pedidos Mensuales" en la parte superior
            const pedidosMensualValue = document.querySelector('.metrics-grid .metric-card:nth-child(2) .metric-value');
            const pedidosMensualSubtitle = document.querySelector('.metrics-grid .metric-card:nth-child(2) .metric-subtitle');

            if (pedidosMensualValue) {
              pedidosMensualValue.textContent = pedidosMesValor;
            }
            if (pedidosMensualSubtitle) {
              pedidosMensualSubtitle.textContent = 'Mes: ' + nuevoMes + ' | Promedio: ' + promedio + ' pedidos/mes';
            }
          }
        </script>
    </body>

    </html>