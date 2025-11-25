# Documentación de Chart.js - Sistema de Reportes VENTADEPOR

## Overview
Este documento explica línea por línea la implementación de Chart.js en el archivo `adminreporte.jsp` para el sistema de reportes de VENTADEPOR.

## Estructura del Código JavaScript

### 1. Importación de Chart.js
```javascript
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
```
- Carga la librería Chart.js versión 4.4.0 desde CDN
- Usa la versión UMD (Universal Module Definition) para compatibilidad

### 2. Datos desde el Servidor
```javascript
// Datos desde el servidor
const ventasPorMes = ${ ventasPorMesJson };
const pedidosPorMes = ${ pedidosPorMesJson };
const unidadesPorCategoria = ${ unidadesPorCategoriaJson };
let selectedMes = '${selectedMes}'; // Usar 'let' para poder modificarlo
```

**Explicación línea por línea:**
- `const ventasPorMes = ${ ventasPorMesJson };` - Recibe objeto JSON con ventas mensuales desde el controller
- `const pedidosPorMes = ${ pedidosPorMesJson };` - Recibe objeto JSON con pedidos mensuales
- `const unidadesPorCategoria = ${ unidadesPorCategoriaJson };` - Recibe objeto JSON con unidades por categoría
- `let selectedMes = '${selectedMes}';` - Variable mutable para el mes seleccionado actualmente

### 3. Configuración Común Optimizada
```javascript
// Configuración común optimizada
const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  animation: { duration: 300 },  // Reducir animación
  plugins: { legend: { display: false } }
};
```

**Explicación:**
- `responsive: true` - Los gráficos se adaptan al tamaño del contenedor
- `maintainAspectRatio: false` - Permite que los gráficos llenen completamente su contenedor
- `animation: { duration: 300 }` - Animación rápida de 300ms para mejor rendimiento
- `plugins: { legend: { display: false } }` - Oculta leyendas por defecto (se configuran individualmente)

### 4. Preparación de Datos
```javascript
// Preparar datos una sola vez
const mesesArray = Object.keys(ventasPorMes);
const ingresosArray = Object.values(ventasPorMes);
const pedidosArray = Object.values(pedidosPorMes);
```

**Explicación:**
- `Object.keys(ventasPorMes)` - Extrae los nombres de los meses (claves del objeto)
- `Object.values(ventasPorMes)` - Extrae los valores de ventas (ingresos mensuales)
- `Object.values(pedidosPorMes)` - Extrae los valores de pedidos mensuales

### 5. Gráfico de Ingresos (Línea)
```javascript
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
```

**Explicación detallada:**
- `type: 'line'` - Tipo de gráfico de líneas
- `document.getElementById('ingresosChart')` - Referencia al canvas HTML
- `labels: mesesArray` - Etiquetas del eje X (nombres de meses)
- `borderColor: '#0d6efd'` - Color azul para la línea
- `backgroundColor: 'rgba(13, 110, 253, 0.1)'` - Relleno semitransparente azul
- `tension: 0.4` - Curvatura suave de la línea
- `pointRadius: 2` - Tamaño de puntos en estado normal
- `pointHoverRadius: 4` - Tamaño de puntos al pasar el mouse
- `beginAtZero: true` - Eje Y comienza en cero
- `callback: v => 'S/ ' + v.toFixed(0)` - Formatea valores como moneda peruana

### 6. Gráfico de Pedidos (Barras)
```javascript
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
```

**Explicación:**
- `type: 'bar'` - Tipo de gráfico de barras
- `backgroundColor: '#198754'` - Color verde para las barras
- `borderRadius: 4` - Bordes redondeados en las barras
- `stepSize: 1` - Incrementos de 1 en el eje Y (para mostrar números enteros)

### 7. Gráfico de Categorías (Donut)
```javascript
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
```

**Explicación:**
- `Object.entries(unidadesPorCategoria)` - Convierte objeto a array de pares [clave, valor]
- `.sort((a, b) => b[1] - a[1])` - Ordena descendentemente por valor (unidades vendidas)
- `.slice(0, 5)` - Toma solo los 5 primeros (top 5 categorías)
- `type: 'doughnut'` - Tipo de gráfico de anillo (donut)
- `backgroundColor: [...]` - Array de colores para cada segmento
- `borderColor: '#fff'` - Bordes blancos entre segmentos
- `position: 'bottom'` - Leyenda posicionada abajo
- `boxWidth: 10` - Tamaño pequeño de los cuadros de leyenda

### 8. Variables Globales para Gráficos de Comparación
```javascript
// Variables globales para los gráficos de comparación
let chartComparacionIngresos;
let chartComparacionPedidos;
```

**Explicación:**
- Declaración de variables globales para poder actualizar los gráficos dinámicamente
- Se usarán en la función `cambiarMes()`

### 9. Gráfico de Comparación de Ingresos
```javascript
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
```

**Explicación clave:**
- `backgroundColor: mesesArray.map(m => m === selectedMes ? '#0d6efd' : '#e0e0e0')` - Colorea de azul el mes seleccionado, gris los demás
- `barThickness: 30` - Grosor fijo de las barras
- `maxBarThickness: 40` - Grosor máximo permitido
- `aspectRatio: 2.5` - Proporción ancho/alto del gráfico

### 10. Gráfico de Comparación de Pedidos
```javascript
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
```

**Explicación:**
- Similar al gráfico de ingresos pero con datos de pedidos
- `backgroundColor: mesesArray.map(m => m === selectedMes ? '#198754' : '#e0e0e0')` - Verde para mes seleccionado

### 11. Función de Cambio de Mes Dinámico
```javascript
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
```

**Explicación detallada de la función:**

1. **Actualización de variables:**
   - `selectedMes = nuevoMes` - Actualiza la variable global con el nuevo mes

2. **Obtención de datos:**
   - `ventasPorMes[nuevoMes] || 0` - Obtiene ingresos del mes seleccionado o 0 si no existe
   - `pedidosPorMes[nuevoMes] || 0` - Obtiene pedidos del mes seleccionado o 0 si no existe

3. **Actualización de UI:**
   - `document.querySelector(...)` - Selecciona elementos DOM para actualizar valores mostrados
   - `toFixed(2)` - Formatea ingresos a 2 decimales

4. **Actualización de gráficos:**
   - `mesesArray.map(m => m === nuevoMes ? '#0d6efd' : '#e0e0e0')` - Crea array de colores
   - `chartComparacionIngresos.data.datasets[0].backgroundColor = nuevosColoresIngresos` - Actualiza colores
   - `chartComparacionIngresos.update('none')` - Refresca gráfico sin animación

5. **Cálculo de promedios:**
   - `Object.values(pedidosPorMes).reduce((a, b) => a + b, 0)` - Suma total de pedidos
   - `Object.keys(pedidosPorMes).length` - Cantidad de meses
   - Calcula y muestra promedio de pedidos mensuales

## Resumen de Funcionalidades

### 5 Gráficos Implementados:
1. **Ingresos Totales** - Línea de tendencia con datos históricos
2. **Pedidos Mensuales** - Barras mostrando cantidad por mes
3. **Top Categorías** - Donut chart con las 5 categorías más vendidas
4. **Comparación de Ingresos** - Barras con resaltado del mes seleccionado
5. **Comparación de Pedidos** - Barras con resaltado del mes seleccionado

### Características Técnicas:
- **Responsive**: Se adaptan a diferentes tamaños de pantalla
- **Optimizados**: Animaciones rápidas y configuración eficiente
- **Interactivos**: Cambio dinámico de mes sin recargar página
- **Temáticos**: Colores consistentes con la identidad visual (azul/verde)
- **Formato local**: Moneda peruana (S/) y formato de números

### Integración con Backend:
- Los datos JSON son generados por el controller Spring Boot
- La función `cambiarMes()` se invoca desde el select HTML con `onchange`
- Actualización en tiempo real sin necesidad de recargar la página

Esta implementación proporciona una experiencia de usuario fluida y visualmente atractiva para el análisis de métricas del sistema VENTADEPOR.
