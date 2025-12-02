// adminproductos.js mantiene la interacción mínima del panel de productos:
// apertura/cierre del modal y confirmación antes de eliminar un producto.
(function () {
    function initAdminProductos() {
        console.log('adminproductos.js initialized');

        var openModalBtn = document.getElementById('addProductBtn');
        var ctx = window.appContext || '';

        if (!openModalBtn) {
            console.warn('adminproductos.js: botón "Agregar" no encontrado.');
        } else {
            openModalBtn.addEventListener('click', function (event) {
                event.preventDefault();
                window.location.href = ctx + '/admin/productos/nuevo';
            });
        }

        // Solicita confirmación antes de navegar al enlace de eliminación.
        document.addEventListener('click', function (event) {
            var deleteLink = null;

            if (typeof event.target.closest === 'function') {
                deleteLink = event.target.closest('a.btn-delete');
            }

            if (!deleteLink) {
                return;
            }

            if (!window.confirm('¿Deseas eliminar este producto?')) {
                event.preventDefault();
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initAdminProductos);
    } else {
        initAdminProductos();
    }
})();