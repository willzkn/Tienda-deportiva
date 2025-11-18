/**
 * Script simplificado para el carrito de compras
 */

// Actualiza el contador del carrito
function actualizarContadorCarrito() {
    const carrito = JSON.parse(localStorage.getItem('carrito')) || [];
    const contador = document.getElementById('carrito-count');
    
    if (contador) {
        contador.textContent = carrito.length;
        contador.style.display = carrito.length > 0 ? 'inline-block' : 'none';
    }
}

// Inicialización
document.addEventListener("DOMContentLoaded", function () {
    const carritoContainer = document.getElementById("carrito-container");
    const resumenProductos = document.getElementById("resumen-productos");
    const btnContinuar = document.getElementById("btn-continuar");
    let carrito = JSON.parse(localStorage.getItem("carrito")) || [];

    // Renderiza el carrito (versión original - ahora oculta)
    function renderizarCarrito() {
        if (carrito.length === 0) {
            carritoContainer.innerHTML = `
                <div class="text-center py-5">
                    <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                    <h4>Tu carrito está vacío</h4>
                    <p class="text-muted">Agrega algunos productos para comenzar</p>
                    <a href="${contextPath}/productos" class="btn btn-primary">Ver Productos</a>
                </div>`;
            
            // Si el carrito está vacío, también actualizamos el resumen
            resumenProductos.innerHTML = `
                <div class="text-center py-3">
                    <p class="text-muted">No hay productos en el carrito</p>
                    <a href="${contextPath}/productos" class="btn btn-sm btn-primary">Ver Productos</a>
                </div>`;
        } else {
            let total = 0;
            let tableHTML = `
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
                        <tbody>`;

            carrito.forEach(function (producto, index) {
                const cantidad = parseInt(producto.cantidad) || 1;
                const precio = parseFloat(producto.precio) || 0;
                const subtotal = precio * cantidad;
                total += subtotal;

                const nombre = producto.nombre || 'Producto sin nombre';
                const imagen = producto.imagen || contextPath + '/images/default-product.jpg';

                tableHTML += `
                    <tr>
                        <td>
                            <img src="${imagen}" alt="${nombre}" 
                                style="width: 50px; height: 50px; object-fit: cover;" 
                                onerror="this.src='${contextPath}/images/default-product.jpg'">
                        </td>
                        <td>${nombre}</td>
                        <td>S/ ${precio.toFixed(2)}</td>
                        <td>
                            <div class="d-flex align-items-center">
                                <button class="btn btn-sm btn-outline-primary" onclick="cambiarCantidad(${index}, -1)">-</button>
                                <span class="mx-2">${cantidad}</span>
                                <button class="btn btn-sm btn-outline-primary" onclick="cambiarCantidad(${index}, 1)">+</button>
                            </div>
                        </td>
                        <td>S/ ${subtotal.toFixed(2)}</td>
                        <td>
                            <button class="btn btn-sm btn-danger" onclick="eliminarProducto(${index})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>`;
            });

            tableHTML += '</tbody>' +
                '</table>' +
                '</div>' +
                '<div class="d-flex justify-content-between align-items-center mt-4 p-4 bg-light rounded border">' +
                '<h3 class="mb-0 text-primary">Total: <span class="text-success">S/ ' + total.toFixed(2) + '</span></h3>' +
                '<button class="btn btn-outline-warning" onclick="vaciarCarrito()">' +
                '<i class="fas fa-trash-alt"></i> Vaciar Carrito' +
                '</button>' +
                '</div>';

            carritoContainer.innerHTML = tableHTML;
            
            // Renderizar el acordeón de productos
            renderizarAcordeonProductos(total);
        }

        actualizarContadorCarrito();
    }
    
    // Renderiza el acordeón de productos (nuevo)
    function renderizarAcordeonProductos(total) {
        if (carrito.length === 0) {
            resumenProductos.innerHTML = `
                <div class="text-center py-3">
                    <p class="text-muted">No hay productos en el carrito</p>
                    <a href="${contextPath}/productos" class="btn btn-sm btn-primary">Ver Productos</a>
                </div>`;
            return;
        }
        
        let acordeonHTML = '';
        
        // Crear un elemento de acordeón para cada producto
        carrito.forEach(function (producto, index) {
            const cantidad = parseInt(producto.cantidad) || 1;
            const precio = parseFloat(producto.precio) || 0;
            const subtotal = precio * cantidad;
            
            const nombre = producto.nombre || 'Producto sin nombre';
            const imagen = producto.imagen || contextPath + '/images/default-product.jpg';
            
            acordeonHTML += `
                <div class="accordion-item">
                    <h2 class="accordion-header" id="heading${index}">
                        <button class="accordion-button ${index !== 0 ? 'collapsed' : ''}" type="button" data-bs-toggle="collapse" 
                            data-bs-target="#collapse${index}" aria-expanded="${index === 0 ? 'true' : 'false'}" 
                            aria-controls="collapse${index}">
                            ${nombre}
                        </button>
                    </h2>
                    <div id="collapse${index}" class="accordion-collapse collapse ${index === 0 ? 'show' : ''}" 
                        aria-labelledby="heading${index}" data-bs-parent="#resumen-productos">
                        <div class="accordion-body">
                            <div class="d-flex align-items-center">
                                <img src="${imagen}" alt="${nombre}" 
                                    class="me-3" style="width: 60px; height: 60px; object-fit: cover;" 
                                    onerror="this.src='${contextPath}/images/default-product.jpg'">
                                <div>
                                    <p class="mb-1">Precio: <strong>S/ ${precio.toFixed(2)}</strong></p>
                                    <p class="mb-1">Cantidad: <strong>${cantidad}</strong></p>
                                    <p class="mb-0">Subtotal: <strong>S/ ${subtotal.toFixed(2)}</strong></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        });
        
        // Agregar el total al final
        acordeonHTML += `
            <div class="mt-3 p-3 bg-light rounded border">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Total:</h5>
                    <h5 class="mb-0 text-success">S/ ${total.toFixed(2)}</h5>
                </div>
            </div>
        `;
        
        resumenProductos.innerHTML = acordeonHTML;
    }

    // Función para cambiar la cantidad de un producto
    window.cambiarCantidad = function (index, cambio) {
        console.log('Cambiando cantidad del producto', index, 'en', cambio);

        if (carrito[index]) {
            carrito[index].cantidad = (parseInt(carrito[index].cantidad) || 1) + cambio;
            if (carrito[index].cantidad <= 0) {
                carrito.splice(index, 1);
            }
            localStorage.setItem("carrito", JSON.stringify(carrito));
            renderizarCarrito();
        }
    };

    // Función para eliminar un producto del carrito
    window.eliminarProducto = function (index) {
        console.log('Eliminando producto', index);

        if (confirm('¿Estás seguro de eliminar este producto?')) {
            carrito.splice(index, 1);
            localStorage.setItem("carrito", JSON.stringify(carrito));
            renderizarCarrito();
        }
    };

    // Función para vaciar todo el carrito
    window.vaciarCarrito = function () {
        console.log('Vaciando carrito');

        if (confirm('¿Estás seguro de vaciar todo el carrito?')) {
            carrito = [];
            localStorage.removeItem("carrito");
            renderizarCarrito();
        }
    };

    // Renderizar el carrito al cargar la página
    renderizarCarrito();

    // Escuchar cambios en el localStorage (para sincronización entre pestañas)
    window.addEventListener('storage', function (e) {
        if (e.key === 'carrito') {
            carrito = JSON.parse(e.newValue) || [];
            renderizarCarrito();
        }
    });
    
    // Hacer funcional el botón Continuar
    if (btnContinuar) {
        btnContinuar.addEventListener('click', function() {
            // Validar el formulario
            const form = document.getElementById('formulario-pago');
            if (form.checkValidity()) {
                // Mostrar mensaje de éxito
                Swal.fire({
                    title: '¡Compra Exitosa!',
                    text: 'Tu pedido ha sido procesado correctamente',
                    icon: 'success',
                    confirmButtonText: 'Aceptar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Vaciar el carrito
                        carrito = [];
                        localStorage.removeItem("carrito");
                        // Redirigir a la página de productos
                        window.location.href = contextPath + '/productos';
                    }
                });
            } else {
                // Mostrar validaciones del formulario
                form.classList.add('was-validated');
            }
        });
    }
    
    // Renderizar el carrito al cargar la página
    renderizarCarrito();
});