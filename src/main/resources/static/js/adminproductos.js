// Admin Productos - Funcionalidad Completa con Filtros
document.addEventListener('DOMContentLoaded', function() {
    const ctx = window.appContext || '';
    
    // Modal
    const modal = document.getElementById('addProductModal');
    const addBtn = document.getElementById('addProductBtn');
    const closeBtn = document.querySelector('.close-button');
    const cancelBtn = document.querySelector('.btn-cancel');
    
    // Filtros
    const btnFiltrar = document.getElementById('btnFiltrar');
    const btnLimpiar = document.getElementById('btnLimpiar');
    const filterCategoria = document.getElementById('filterCategoria');
    const filterMaterial = document.getElementById('filterMaterial');
    const precioMin = document.getElementById('precioMin');
    const precioMax = document.getElementById('precioMax');
    const searchInput = document.getElementById('searchInput');
    
    // Abrir modal
    if (addBtn) {
        addBtn.addEventListener('click', () => {
            modal.style.display = 'flex';
        });
    }
    
    // Cerrar modal
    if (closeBtn) {
        closeBtn.addEventListener('click', () => {
            modal.style.display = 'none';
        });
    }
    
    if (cancelBtn) {
        cancelBtn.addEventListener('click', () => {
            modal.style.display = 'none';
        });
    }
    
    // Cerrar modal al hacer clic fuera
    window.addEventListener('click', (e) => {
        if (e.target === modal || !modal.contains(e.target)) {
            modal.style.display = 'none';
        }
    });
    
    // Filtrar productos
    if (btnFiltrar) {
        btnFiltrar.addEventListener('click', async function() {
            const categoria = filterCategoria ? filterCategoria.value : '';
            const material = filterMaterial ? filterMaterial.value : '';
            const min = precioMin ? precioMin.value : '';
            const max = precioMax ? precioMax.value : '';
            
            const params = new URLSearchParams();
            if (categoria) params.append('categoria', categoria);
            if (material && material !== 'todos') params.append('material', material);
            if (min) params.append('precioMin', min);
            if (max) params.append('precioMax', max);
            
            try {
                // Loading state
                btnFiltrar.disabled = true;
                btnFiltrar.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Filtrando...';
                
                const response = await fetch(`${ctx}/admin/api/productos/filtrar?${params}`);
                const productos = await response.json();
                
                actualizarTabla(productos);
                
                if (productos.length === 0) {
                    if (typeof toast !== 'undefined') {
                        toast.info('No se encontraron productos con los filtros seleccionados');
                    }
                } else {
                    if (typeof toast !== 'undefined') {
                        toast.success(`${productos.length} producto(s) encontrado(s)`);
                    }
                }
                
                // Restaurar botón
                btnFiltrar.disabled = false;
                btnFiltrar.innerHTML = '<i class="fa-solid fa-filter"></i> Filtrar';
                
            } catch (error) {
                if (typeof toast !== 'undefined') {
                    toast.error('Error al filtrar productos');
                }
                console.error(error);
                
                // Restaurar botón
                btnFiltrar.disabled = false;
                btnFiltrar.innerHTML = '<i class="fa-solid fa-filter"></i> Filtrar';
            }
        });
    }
    
    // Limpiar filtros
    if (btnLimpiar) {
        btnLimpiar.addEventListener('click', () => {
            if (filterCategoria) filterCategoria.value = '';
            if (filterMaterial) filterMaterial.value = 'todos';
            if (precioMin) precioMin.value = '';
            if (precioMax) precioMax.value = '';
            if (searchInput) searchInput.value = '';
            location.reload();
        });
    }
    
    // Función para normalizar texto (ignora acentos y mayúsculas)
    function normalizarTexto(texto) {
        return texto
            .toLowerCase()
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, ''); // Elimina acentos
    }

    // Búsqueda en tiempo real mejorada
    if (searchInput) {
        let timeout;
        searchInput.addEventListener('input', function() {
            clearTimeout(timeout);
            const query = this.value.trim();
            
            if (query.length === 0) {
                location.reload();
                return;
            }
            
            if (query.length < 2) return;
            
            timeout = setTimeout(async () => {
                try {
                    // Búsqueda con normalización
                    const queryNormalizado = normalizarTexto(query);
                    const response = await fetch(`${ctx}/admin/api/productos/filtrar`);
                    const todosProductos = await response.json();
                    
                    // Filtrar localmente con normalización
                    const productosFiltrados = todosProductos.filter(p => {
                        const nombre = p.nombre || p.NOMBRE || '';
                        const descripcion = p.descripcion || p.DESCRIPCION || '';
                        const nombreNormalizado = normalizarTexto(nombre);
                        const descripcionNormalizada = normalizarTexto(descripcion);
                        
                        return nombreNormalizado.includes(queryNormalizado) || 
                               descripcionNormalizada.includes(queryNormalizado);
                    });
                    
                    actualizarTabla(productosFiltrados);
                    
                    if (typeof toast !== 'undefined') {
                        toast.info(`${productosFiltrados.length} producto(s) encontrado(s)`);
                    }
                } catch (error) {
                    console.error('Error en búsqueda:', error);
                }
            }, 300);
        });
    }
    
    // Actualizar tabla
    function actualizarTabla(productos) {
        const tbody = document.getElementById('product-list');
        
        // Debug
        if (productos.length > 0) {
            console.log('Admin - Primer producto:', productos[0]);
            console.log('Admin - Propiedades:', Object.keys(productos[0]));
        }
        
        tbody.innerHTML = productos.map(p => {
            // Manejar diferentes nombres de propiedades (mayúsculas/minúsculas)
            const id = p.id_producto || p.ID_PRODUCTO || p.id || p.ID;
            const nombre = p.nombre || p.NOMBRE;
            const precio = p.precio || p.PRECIO;
            const categoria = p.categoria || p.CATEGORIA || 'Sin categoría';
            const imagenUrl = p.imagen_url || p.IMAGEN_URL || p.imagenUrl || p.IMAGENURL;
            
            return `
                <tr>
                    <td><img src="${imagenUrl || ctx + '/images/no-image.jpg'}" alt="${nombre}"></td>
                    <td>PRD-${id}</td>
                    <td>${nombre}</td>
                    <td>${categoria}</td>
                    <td>S/ ${parseFloat(precio).toFixed(2)}</td>
                    <td class="text-center"><span class="badge bg-success">En stock</span></td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn btn-edit" data-id="${id}">
                                <i class="fa-solid fa-pencil"></i> Editar
                            </button>
                            <button class="btn btn-delete" data-id="${id}">
                                <i class="fa-solid fa-trash-can"></i> Eliminar
                            </button>
                        </div>
                    </td>
                </tr>
            `;
        }).join('');
        
        // Re-attach event listeners
        attachDeleteListeners();
    }
    
    // Eliminar producto
    function attachDeleteListeners() {
        document.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', async function() {
                const id = this.dataset.id;
                
                if (!confirm('¿Estás seguro de eliminar este producto?')) return;
                
                this.classList.add('btn-loading');
                
                try {
                    const response = await fetch(`${ctx}/admin/api/productos/${id}`, {
                        method: 'DELETE'
                    });
                    
                    const data = await response.json();
                    
                    if (data.success) {
                        toast.success(data.message);
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        toast.error(data.message);
                        this.classList.remove('btn-loading');
                    }
                } catch (error) {
                    toast.error('Error al eliminar producto');
                    this.classList.remove('btn-loading');
                }
            });
        });
    }
    
    // Inicializar listeners de eliminar
    attachDeleteListeners();
});