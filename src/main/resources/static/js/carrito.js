document.addEventListener('DOMContentLoaded', initCarritoPage);

function initCarritoPage() {
    const ctx = window.appContext || '';
    const ui = {
        contenedor: document.getElementById('carrito-container'),
        resumen: document.getElementById('resumen-productos'),
        btnContinuar: document.getElementById('btn-continuar'),
        formulario: document.getElementById('formulario-pago')
    };

    if (!ui.contenedor || !ui.resumen) {
        return;
    }

    const state = {
        carrito: obtenerCarrito(),
        ctx,
        ui
    };

    renderizarTodo(state);
    registrarEventos(state);
}

function registrarEventos(state) {
    const { ui } = state;

    ui.contenedor.addEventListener('click', (event) => manejarClickContenedor(event, state));
    ui.resumen.addEventListener('click', (event) => manejarClickResumen(event, state));

    ui.btnContinuar?.addEventListener('click', (event) => {
        event.preventDefault();

        if (!ui.formulario) {
            return;
        }

        if (ui.formulario.checkValidity()) {
            limpiarCarrito(state);
            window.location.href = `${state.ctx}/productos`;
        } else {
            ui.formulario.classList.add('was-validated');
        }
    });

    window.addEventListener('storage', (event) => {
        if (event.key === 'carrito') {
            state.carrito = obtenerCarrito();
            renderizarTodo(state);
        }
    });
}

function manejarClickContenedor(evento, state) {
    const boton = evento.target.closest('button[data-action]');
    if (!boton) {
        return;
    }

    const { action, index } = boton.dataset;
    const idx = Number.parseInt(index, 10);

    const acciones = {
        incrementar: () => actualizarCantidad(state, idx, 1),
        decrementar: () => actualizarCantidad(state, idx, -1),
        eliminar: () => eliminarProducto(state, idx),
        vaciar: () => confirmarVaciarCarrito(state)
    };

    acciones[action]?.();
}

function manejarClickResumen(evento, state) {
    const boton = evento.target.closest('button[data-action="eliminar"]');
    if (!boton) {
        return;
    }

    const idx = Number.parseInt(boton.dataset.index, 10);
    eliminarProducto(state, idx);
}

function renderizarTodo(state) {
    const { ui } = state;
    renderizarCarrito(state);
    renderizarResumen(state);
    actualizarContadorCarrito();

    if (!state.carrito.length) {
        ui.resumen.innerHTML = crearResumenVacio(state.ctx);
    }
}

function renderizarCarrito(state) {
    const { carrito, ui } = state;

    if (!carrito.length) {
        ui.contenedor.innerHTML = crearCarritoVacio(state.ctx);
        return;
    }

    const total = calcularTotal(carrito);

    const filas = carrito
        .map((producto, index) => crearFilaProducto(producto, index, state.ctx))
        .join('');

    ui.contenedor.innerHTML = `
        <div class="table-responsive">
            <table class="table">
                <thead class="table-dark">
                    <tr>
                        <th>Imagen</th>
                        <th>Producto</th>
                        <th>Precio</th>
                        <th>Cantidad</th>
                        <th>Subtotal</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>${filas}</tbody>
            </table>
        </div>
        <div class="d-flex justify-content-between align-items-center mt-4 p-4 bg-light rounded border">
            <h3 class="mb-0 text-primary">Total: <span class="text-success">${formatearMoneda(total)}</span></h3>
            <button class="btn btn-outline-warning" data-action="vaciar">
                <i class="fas fa-trash-alt"></i> Vaciar Carrito
            </button>
        </div>
    `;
}

function renderizarResumen(state) {
    const { carrito, ui } = state;

    if (!carrito.length) {
        return;
    }

    const items = carrito
        .map((producto, index) => crearItemResumen(producto, index))
        .join('');

    const total = calcularTotal(carrito);

    ui.resumen.innerHTML = `
        <ul class="list-group">
            ${items}
            <li class="list-group-item d-flex justify-content-between align-items-center">
                <strong>Total</strong>
                <span>${formatearMoneda(total)}</span>
            </li>
        </ul>
    `;
}

function crearFilaProducto(producto, index, ctx) {
    const nombre = producto.nombre || 'Producto sin nombre';
    const cantidad = obtenerCantidad(producto);
    const precio = obtenerPrecio(producto);
    const subtotal = cantidad * precio;
    const imagen = producto.imagen || `${ctx}/images/default-product.png`;

    return `
        <tr>
            <td>
                <img
                    src="${imagen}"
                    alt="${nombre}"
                    style="width: 50px; height: 50px; object-fit: cover;"
                    onerror="this.src='${ctx}/images/default-product.png'"
                >
            </td>
            <td>${nombre}</td>
            <td>${formatearMoneda(precio)}</td>
            <td>
                <div class="d-flex align-items-center">
                    <button class="btn btn-sm btn-outline-primary" data-action="decrementar" data-index="${index}">-</button>
                    <span class="mx-2">${cantidad}</span>
                    <button class="btn btn-sm btn-outline-primary" data-action="incrementar" data-index="${index}">+</button>
                </div>
            </td>
            <td>${formatearMoneda(subtotal)}</td>
            <td>
                <button class="btn btn-sm btn-danger" data-action="eliminar" data-index="${index}">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
    `;
}

function crearItemResumen(producto, index) {
    const nombre = producto.nombre || 'Producto sin nombre';
    const cantidad = obtenerCantidad(producto);
    const precio = obtenerPrecio(producto);
    const subtotal = cantidad * precio;

    return `
        <li class="list-group-item d-flex justify-content-between align-items-center">
            <div>
                <div class="fw-bold">${nombre}</div>
                <small>Cantidad: ${cantidad}</small>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span>${formatearMoneda(subtotal)}</span>
                <button type="button" class="btn btn-sm btn-danger" data-action="eliminar" data-index="${index}" aria-label="Eliminar producto">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        </li>
    `;
}

function crearCarritoVacio(ctx) {
    return `
        <div class="text-center py-5">
            <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
            <h4>Tu carrito está vacío</h4>
            <p class="text-muted">Agrega algunos productos para comenzar</p>
            <a href="${ctx}/productos" class="btn btn-primary">Ver Productos</a>
        </div>
    `;
}

function crearResumenVacio(ctx) {
    return `
        <div class="text-center py-3">
            <p class="text-muted">No hay productos en el carrito</p>
            <a href="${ctx}/productos" class="btn btn-sm btn-primary">Ver Productos</a>
        </div>
    `;
}

function actualizarCantidad(state, index, cambio) {
    if (!Number.isInteger(index) || !state.carrito[index]) {
        return;
    }

    const producto = state.carrito[index];
    const cantidad = obtenerCantidad(producto) + cambio;

    if (cantidad <= 0) {
        state.carrito.splice(index, 1);
    } else {
        producto.cantidad = cantidad;
    }

    guardarCarrito(state.carrito);
    renderizarTodo(state);
}

function eliminarProducto(state, index) {
    if (!Number.isInteger(index) || !state.carrito[index]) {
        return;
    }

    if (confirm('¿Estás seguro de eliminar este producto?')) {
        state.carrito.splice(index, 1);
        guardarCarrito(state.carrito);
        renderizarTodo(state);
    }
}

function confirmarVaciarCarrito(state) {
    if (confirm('¿Estás seguro de vaciar todo el carrito?')) {
        limpiarCarrito(state);
    }
}

function limpiarCarrito(state) {
    state.carrito = [];
    localStorage.removeItem('carrito');
    renderizarTodo(state);
}

function obtenerCarrito() {
    try {
        return JSON.parse(localStorage.getItem('carrito')) || [];
    } catch (error) {
        console.error('No se pudo leer el carrito desde el almacenamiento local', error);
        return [];
    }
}

function guardarCarrito(carrito) {
    localStorage.setItem('carrito', JSON.stringify(carrito));
}

function obtenerCantidad(producto) {
    return Number.parseInt(producto?.cantidad, 10) || 1;
}

function obtenerPrecio(producto) {
    return Number.parseFloat(producto?.precio) || 0;
}

function formatearMoneda(valor) {
    return `S/ ${valor.toFixed(2)}`;
}

function calcularTotal(carrito) {
    return carrito.reduce((acumulado, producto) => {
        const cantidad = obtenerCantidad(producto);
        const precio = obtenerPrecio(producto);
        return acumulado + cantidad * precio;
    }, 0);
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