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

            <!-- Métricas Principales con Gráficos Integrados -->
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
                  <canvas id="ingresosChart" height="100"></canvas>
                </div>
              </div>

              <!-- Métrica 2: Pedidos por Mes -->
              <div class="metric-card">
                <div class="metric-info">
                  <h3><i class="fa-solid fa-shopping-cart"></i> Pedidos Mensuales</h3>
                  <p class="metric-value">${pedidosMes != null ? pedidosMes : 0}</p>
                  <p class="metric-subtitle">Mes: ${selectedMes} | Promedio:
                    ${promedioPedidosMensuales} pedidos/mes</p>
                </div>
                <div class="metric-chart">
                  <canvas id="pedidosChart" height="100"></canvas>
                </div>
              </div>

            </div>

            <!-- Sección de Clientes -->
            <div class="comparison-section">
              <div class="comparison-grid">
                <!-- Top Clientes Frecuentes -->
                <div class="comparison-card" style="grid-column: span 2; width: 100%;">
                  <h4><i class="fa-solid fa-users"></i> Top Clientes Frecuentes</h4>
                  <canvas id="topClientesChart" height="100"></canvas>
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
          const topClientes = ${ topClientesJson != null ? topClientesJson : '{}' };

          // Debug: Ver qué datos llegan
          console.log("Top Clientes recibidos:", topClientes);
          console.log("Tipo:", typeof topClientes);
          console.log("Keys:", Object.keys(topClientes));
          console.log("Values:", Object.values(topClientes));

          // Configuración común optimizada
          const chartOptions = {
            responsive: true,
            maintainAspectRatio: false,
            animation: { duration: 300 },
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
                x: {
                  ticks: {
                    maxRotation: 0,
                    minRotation: 0,
                    maxTicksLimit: 12,
                    autoSkip: true
                  }
                }
              },
              layout: {
                padding: {
                  bottom: 10
                }
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
              scales: {
                y: { beginAtZero: true, ticks: { stepSize: 1, maxTicksLimit: 5 } },
                x: {
                  ticks: {
                    maxRotation: 0,
                    minRotation: 0,
                    maxTicksLimit: 12,
                    autoSkip: true
                  }
                }
              },
              layout: {
                padding: {
                  bottom: 10
                }
              }
            }
          });

          // 3. Gráfico: Top Clientes Frecuentes (Horizontal)
          const clientesLabels = Object.keys(topClientes);
          const clientesData = Object.values(topClientes);

          console.log("Labels para gráfico:", clientesLabels);
          console.log("Data para gráfico:", clientesData);

          new Chart(document.getElementById('topClientesChart'), {
            type: 'bar',
            data: {
              labels: clientesLabels,
              datasets: [{
                label: 'Pedidos',
                data: clientesData,
                backgroundColor: '#dc3545',
                borderRadius: 4,
                barThickness: 20
              }]
            },
            options: {
              ...chartOptions,
              indexAxis: 'y', // Hace que sea horizontal
              scales: {
                x: { beginAtZero: true, ticks: { stepSize: 1 } }
              }
            }
          });
        </script>
    </body>

    </html>