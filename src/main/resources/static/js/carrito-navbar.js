// Script para manejar el contador del carrito en el navbar
document.addEventListener('DOMContentLoaded', () => {
    actualizarContadorCarrito();

    window.addEventListener('storage', (event) => {
        if (event.key === 'carrito') {
            actualizarContadorCarrito();
        }
    });
});

function obtenerCarrito() {
    return JSON.parse(localStorage.getItem('carrito')) || [];
}

function guardarCarrito(carrito) {
    localStorage.setItem('carrito', JSON.stringify(carrito));
}

function actualizarContadorCarrito() {
    const carrito = obtenerCarrito();
    const contador = document.getElementById('carrito-count');

    if (!contador) {
        return;
    }

    if (carrito.length) {
        contador.textContent = carrito.length;
        contador.style.display = 'inline-block';
    } else {
        contador.textContent = '';
        contador.style.display = 'none';
    }
}

function agregarAlCarrito(producto) {
    const carrito = obtenerCarrito();
    const existente = carrito.find((item) => item.nombre === producto.nombre);

    if (existente) {
        existente.cantidad = (existente.cantidad || 1) + 1;
    } else {
        carrito.push({ ...producto, cantidad: producto.cantidad || 1 });
    }

    guardarCarrito(carrito);
    actualizarContadorCarrito();
}

window.carritoHelpers = {
    ...(window.carritoHelpers || {}),
    obtenerCarrito,
    guardarCarrito,
    actualizarContadorCarrito,
    agregarAlCarrito
};