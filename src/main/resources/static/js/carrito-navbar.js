// Script para manejar el contador del carrito en el navbar
document.addEventListener('DOMContentLoaded', function() {
    actualizarContadorCarrito();
    
    // Escuchar cambios en el localStorage
    window.addEventListener('storage', function(e) {
        if (e.key === 'carrito') {
            actualizarContadorCarrito();
        }
    });
});

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

// Función para agregar producto al carrito (para usar en productos.js)
function agregarAlCarrito(producto) {
    let carrito = JSON.parse(localStorage.getItem('carrito')) || [];
    
    // Verificar si el producto ya existe en el carrito (por nombre)
    const productoExistente = carrito.find(item => item.nombre === producto.nombre);
    
    if (productoExistente) {
        productoExistente.cantidad = (productoExistente.cantidad || 1) + 1;
    } else {
        producto.cantidad = producto.cantidad || 1;
        carrito.push(producto);
    }
    
    localStorage.setItem('carrito', JSON.stringify(carrito));
    actualizarContadorCarrito();
    
    // Mostrar notificación
    mostrarNotificacion(`${producto.nombre} agregado al carrito`);
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
        animation: slideIn 0.3s ease-out;
    `;
    notificacion.innerHTML = `
        <i class="fas fa-check-circle me-2"></i>
        <span>${mensaje}</span>
        <button type="button" class="btn-close ms-auto" onclick="this.parentElement.remove()"></button>
    `;
    
    // Agregar CSS de animación si no existe
    if (!document.querySelector('#carrito-animations')) {
        const style = document.createElement('style');
        style.id = 'carrito-animations';
        style.textContent = `
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
        `;
        document.head.appendChild(style);
    }
    
    document.body.appendChild(notificacion);
    
    // Remover después de 3 segundos
    setTimeout(() => {
        if (notificacion.parentElement) {
            notificacion.style.animation = 'slideIn 0.3s ease-out reverse';
            setTimeout(() => notificacion.remove(), 300);
        }
    }, 3000);
}