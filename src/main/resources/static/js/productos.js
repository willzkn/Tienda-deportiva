// Funciones del carrito integradas
function actualizarContadorCarrito() {
    const carrito = JSON.parse(localStorage.getItem('carrito')) || [];
    const contador = document.getElementById('carrito-count');
    
    if (contador) {
        if (carrito.length > 0) {
            contador.textContent = carrito.length;
            contador.style.display = 'inline-block';
        } else {
            contador.style.display = 'none';
        }
    }
}

function mostrarNotificacion(mensaje) {
    // Remover notificación existente si la hay
    const existente = document.querySelector('.carrito-notification');
    if (existente) {
        existente.remove();
    }
    
    // Crear notificación temporal
    const notificacion = document.createElement('div');
    notificacion.className = 'carrito-notification alert alert-success position-fixed d-flex align-items-center';
    notificacion.style.cssText = `
        top: 20px; right: 20px; z-index: 9999; min-width: 300px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        border: none; border-radius: 8px;
        background: #28a745; color: white; padding: 15px 20px;
    `;
    notificacion.innerHTML = `
        <i class="fas fa-check-circle me-2"></i>
        <span>${mensaje}</span>
        <button type="button" class="btn-close ms-auto" onclick="this.parentElement.remove()" style="filter: invert(1);"></button>
    `;
    
    document.body.appendChild(notificacion);
    
    // Remover después de 3 segundos
    setTimeout(() => {
        if (notificacion.parentElement) {
            notificacion.remove();
        }
    }, 3000);
}

// Script principal de productos
document.addEventListener("DOMContentLoaded", () => {
  console.log('Script de productos cargado');
  
  // Actualizar contador al cargar la página
  actualizarContadorCarrito();
  
  const botonesAgregar = document.querySelectorAll(".agregar");
  console.log('Botones encontrados:', botonesAgregar.length);

  botonesAgregar.forEach((boton, index) => {
    console.log(`Configurando botón ${index + 1}`);
    
    boton.addEventListener("click", (e) => {
      e.preventDefault();
      console.log('Botón clickeado');
      
      const productoDiv = e.target.closest('.producto');
      console.log('ProductoDiv:', productoDiv);
      
      if (!productoDiv) {
        console.error('No se encontró el div del producto');
        return;
      }
      
      try {
        // Extraer datos paso a paso
        const h3 = productoDiv.querySelector('h3');
        const precioP = productoDiv.querySelector('.producto-precio');
        const img = productoDiv.querySelector('img');
        
        console.log('Elementos encontrados:', { h3, precioP, img });
        
        if (!h3 || !precioP || !img) {
          throw new Error('Faltan elementos del producto');
        }
        
        const nombre = h3.textContent.trim();
        const precioTexto = precioP.textContent.trim();
        const imagen = img.src;
        
        console.log('Datos extraídos:', { nombre, precioTexto, imagen });
        
        // Limpiar precio: remover "S/." y espacios, mantener punto decimal
        let precioNumerico = precioTexto.replace(/S\/\.?\s*/g, '').trim();
        // Si tiene coma como separador de miles, quitarla (ej: 1,299.90 -> 1299.90)
        precioNumerico = precioNumerico.replace(/,(\d{3})/g, '$1');
        const precio = parseFloat(precioNumerico);
        
        console.log('Precio procesado:', { precioTexto, precioNumerico, precio });
        
        if (isNaN(precio) || precio <= 0) {
          throw new Error(`Precio inválido: ${precio}`);
        }
        
        const producto = {
          id: Date.now() + Math.random(),
          nombre: nombre,
          precio: precio,
          imagen: imagen,
          cantidad: 1
        };
        
        console.log('Producto final:', producto);
        
        // Agregar al carrito
        let carrito = JSON.parse(localStorage.getItem('carrito')) || [];
        
        const existente = carrito.find(item => item.nombre === producto.nombre);
        if (existente) {
          existente.cantidad += 1;
          console.log('Producto existente, cantidad actualizada');
        } else {
          carrito.push(producto);
          console.log('Producto nuevo agregado');
        }
        
        localStorage.setItem('carrito', JSON.stringify(carrito));
        console.log('Carrito guardado:', carrito);
        
        // Actualizar contador
        actualizarContadorCarrito();
        
        // Mostrar notificación
        mostrarNotificacion(`${nombre} agregado al carrito`);
        
      } catch (error) {
        console.error('Error al procesar producto:', error);
        alert('Error al agregar producto al carrito: ' + error.message);
      }
    });
  });
});
