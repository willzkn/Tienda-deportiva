document.addEventListener('DOMContentLoaded', initProductosPage);

function initProductosPage() {
    actualizarContadorCarrito();

    document.querySelectorAll('.agregar').forEach(boton => {
        boton.addEventListener('click', manejarAgregarProducto);
    });
}

function manejarAgregarProducto(evento) {
    evento.preventDefault();

    const productoElemento = evento.currentTarget.closest('.producto');
    if (!productoElemento) {
        alert('No se pudo identificar el producto.');
        return;
    }

    try {
        const producto = obtenerProductoDesdeElemento(productoElemento);
        const carrito = agregarProductoAlCarrito(producto);

        guardarCarrito(carrito);
        actualizarContadorCarrito();
        mostrarNotificacion(`${producto.nombre} agregado al carrito`);
    } catch (error) {
        alert(`Error al agregar producto al carrito: ${error.message}`);
    }
}

function obtenerProductoDesdeElemento(productoElemento) {
    const nombreElemento = productoElemento.querySelector('h3');
    const precioElemento = productoElemento.querySelector('.producto-precio');
    const imagenElemento = productoElemento.querySelector('img');

    if (!nombreElemento || !precioElemento || !imagenElemento) {
        throw new Error('Faltan datos del producto.');
    }

    const nombre = nombreElemento.textContent.trim();
    const precio = obtenerPrecioNumerico(precioElemento.textContent);
    const imagen = imagenElemento.src;
    const id = parseInt(productoElemento.dataset.id, 10);

    console.log("Producto agregado - ID capturado:", id, "Elemento:", productoElemento);

    return {
        id: id,
        nombre,
        precio,
        imagen,
        cantidad: 1
    };
}

function obtenerPrecioNumerico(textoPrecio) {
    const normalizado = textoPrecio
        .replace(/S\/.?\s*/g, '') // quita prefijo "S/."
        .replace(/,(\d{3})/g, '$1') // quita separadores de miles
        .trim();

    const precio = parseFloat(normalizado);
    if (Number.isNaN(precio) || precio <= 0) {
        throw new Error('Precio inválido.');
    }

    return precio;
}

function agregarProductoAlCarrito(producto) {
    const carrito = obtenerCarrito();
    const existente = carrito.find(item => item.nombre === producto.nombre);

    if (existente) {
        existente.cantidad = (existente.cantidad || 1) + 1;
    } else {
        carrito.push(producto);
    }

    return carrito;
}

function obtenerCarrito() {
    try {
        return JSON.parse(localStorage.getItem('carrito')) || [];
    } catch (_) {
        return [];
    }
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

    const hayProductos = carrito.length > 0;
    contador.textContent = hayProductos ? carrito.length : '';
    contador.style.display = hayProductos ? 'inline-block' : 'none';
}

function mostrarNotificacion(mensaje) {
    const previa = document.querySelector('.carrito-notification');
    if (previa) {
        previa.remove();
    }

    const notificacion = document.createElement('div');
    notificacion.className = 'carrito-notification alert alert-success position-fixed d-flex align-items-center';
    notificacion.style.cssText = [
        'top: 20px',
        'right: 20px',
        'z-index: 9999',
        'min-width: 300px',
        'box-shadow: 0 4px 12px rgba(0,0,0,0.15)',
        'border: none',
        'border-radius: 8px',
        'background: #28a745',
        'color: white',
        'padding: 15px 20px'
    ].join(';');

    notificacion.innerHTML = `
        <i class="fas fa-check-circle me-2"></i>
        <span>${mensaje}</span>
        <button type="button" class="btn-close ms-auto" style="filter: invert(1);"></button>
    `;

    notificacion.querySelector('button').addEventListener('click', () => {
        notificacion.remove();
    });

    document.body.appendChild(notificacion);

    setTimeout(() => {
        notificacion.remove();
    }, 3000);
}
