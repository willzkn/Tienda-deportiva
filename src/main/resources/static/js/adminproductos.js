document.addEventListener('DOMContentLoaded', initAdminProductosPage);

let deleteListenersRegistrados = false;

function initAdminProductosPage() {
    const ctx = window.appContext || '';
    const ui = {
        modal: document.getElementById('addProductModal'),
        addBtn: document.getElementById('addProductBtn'),
        closeBtn: document.querySelector('.close-button'),
        cancelBtn: document.querySelector('.btn-cancel'),
        btnFiltrar: document.getElementById('btnFiltrar'),
        btnLimpiar: document.getElementById('btnLimpiar'),
        filterCategoria: document.getElementById('filterCategoria'),
        filterMaterial: document.getElementById('filterMaterial'),
        precioMin: document.getElementById('precioMin'),
        precioMax: document.getElementById('precioMax'),
        searchInput: document.getElementById('searchInput')
    };

    registrarModal(ui);
    registrarFiltros(ctx, ui);
    registrarBusqueda(ctx, ui.searchInput);
    attachDeleteListeners(ctx);
}

function registrarModal({ modal, addBtn, closeBtn, cancelBtn }) {
    if (!modal) {
        return;
    }

    const mostrarModal = () => (modal.style.display = 'flex');
    const ocultarModal = () => (modal.style.display = 'none');

    addBtn?.addEventListener('click', mostrarModal);
    closeBtn?.addEventListener('click', ocultarModal);
    cancelBtn?.addEventListener('click', ocultarModal);

    window.addEventListener('click', (event) => {
        if (event.target === modal || !modal.contains(event.target)) {
            ocultarModal();
        }
    });
}

function registrarFiltros(ctx, ui) {
    const {
        btnFiltrar,
        btnLimpiar,
        filterCategoria,
        filterMaterial,
        precioMin,
        precioMax,
        searchInput
    } = ui;

    if (btnFiltrar) {
        btnFiltrar.addEventListener('click', async () => {
            const params = construirParametrosFiltro({
                filterCategoria,
                filterMaterial,
                precioMin,
                precioMax
            });

            await filtrarProductos(ctx, params, btnFiltrar);
        });
    }

    btnLimpiar?.addEventListener('click', () => {
        limpiarFiltros({
            filterCategoria,
            filterMaterial,
            precioMin,
            precioMax,
            searchInput
        });
        window.location.reload();
    });
}

async function filtrarProductos(ctx, params, boton) {
    const url = `${ctx}/admin/api/productos/filtrar${params ? `?${params}` : ''}`;
    const restaurar = setButtonLoading(boton);

    try {
        const productos = await obtenerJson(url);
        if (!productos) {
            return;
        }

        actualizarTabla(productos, ctx);

        if (!productos.length) {
            console.info('No se encontraron productos con los filtros seleccionados');
        }
    } catch (error) {
        console.error('Error al filtrar productos', error);
    } finally {
        restaurar();
    }
}

function construirParametrosFiltro({ filterCategoria, filterMaterial, precioMin, precioMax }) {
    const params = new URLSearchParams();

    const categoria = leerValor(filterCategoria);
    const material = leerValor(filterMaterial);
    const min = leerValor(precioMin);
    const max = leerValor(precioMax);

    if (categoria) params.append('categoria', categoria);
    if (material && material !== 'todos') params.append('material', material);
    if (min) params.append('precioMin', min);
    if (max) params.append('precioMax', max);

    return params.toString();
}

function registrarBusqueda(ctx, input) {
    if (!input) {
        return;
    }

    let timeoutId;

    input.addEventListener('input', () => {
        clearTimeout(timeoutId);
        const query = input.value.trim();

        if (!query.length) {
            window.location.reload();
            return;
        }

        if (query.length < 2) {
            return;
        }

        timeoutId = setTimeout(async () => {
            try {
                const productos = await obtenerJson(`${ctx}/admin/api/productos/filtrar`);
                if (!productos) {
                    return;
                }

                const filtrados = filtrarPorTexto(productos, query);
                actualizarTabla(filtrados, ctx);
            } catch (error) {
                console.error('Error en búsqueda:', error);
            }
        }, 300);
    });
}

function filtrarPorTexto(productos, query) {
    const queryNormalizada = normalizarTexto(query);

    return productos.filter((producto) => {
        const nombre = normalizarTexto(producto.nombre || producto.NOMBRE || '');
        const descripcion = normalizarTexto(producto.descripcion || producto.DESCRIPCION || '');

        return nombre.includes(queryNormalizada) || descripcion.includes(queryNormalizada);
    });
}

function normalizarTexto(texto) {
    return texto
        .toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '');
}

async function obtenerJson(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Respuesta inválida (${response.status})`);
        }
        return await response.json();
    } catch (error) {
        console.error('Error al obtener datos', error);
        return null;
    }
}

function actualizarTabla(productos, ctx) {
    const tbody = document.getElementById('product-list');
    if (!tbody) {
        return;
    }

    tbody.innerHTML = productos
        .map((producto) => construirFilaProducto(producto, ctx))
        .join('');

    attachDeleteListeners(ctx);
}

function construirFilaProducto(producto, ctx) {
    const id = producto.id_producto || producto.ID_PRODUCTO || producto.id || producto.ID;
    const nombre = producto.nombre || producto.NOMBRE || 'Producto sin nombre';
    const precio = parseFloat(producto.precio || producto.PRECIO || 0).toFixed(2);
    const categoria = producto.categoria || producto.CATEGORIA || 'Sin categoría';
    const imagen = producto.imagen_url || producto.IMAGEN_URL || producto.imagenUrl || producto.IMAGENURL;

    const imagenSrc = imagen || `${ctx}/images/no-image.jpg`;

    return `
        <tr>
            <td><img src="${imagenSrc}" alt="${nombre}"></td>
            <td>PRD-${id}</td>
            <td>${nombre}</td>
            <td>${categoria}</td>
            <td>S/ ${precio}</td>
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
}

function attachDeleteListeners(ctx) {
    if (deleteListenersRegistrados) {
        return;
    }

    document.addEventListener('click', (event) => {
        const boton = event.target.closest('.btn-delete');
        if (!boton) {
            return;
        }

        eliminarProducto(ctx, boton);
    });

    deleteListenersRegistrados = true;
}

async function eliminarProducto(ctx, boton) {
    const { id } = boton.dataset;
    if (!id || !confirm('¿Estás seguro de eliminar este producto?')) {
        return;
    }

    const restaurar = setButtonLoading(boton);

    try {
        const response = await fetch(`${ctx}/admin/api/productos/${id}`, { method: 'DELETE' });
        const data = await response.json();

        if (data.success) {
            console.info(data.message);
            setTimeout(() => window.location.reload(), 1000);
        } else {
            console.error(data.message);
            restaurar();
        }
    } catch (error) {
        console.error('Error al eliminar producto', error);
        restaurar();
    }
}

function limpiarFiltros({ filterCategoria, filterMaterial, precioMin, precioMax, searchInput }) {
    if (filterCategoria) filterCategoria.value = '';
    if (filterMaterial) filterMaterial.value = 'todos';
    if (precioMin) precioMin.value = '';
    if (precioMax) precioMax.value = '';
    if (searchInput) searchInput.value = '';
}

function leerValor(input) {
    return input?.value?.trim() || '';
}

function setButtonLoading(boton, textoCarga = '<i class="fa-solid fa-spinner fa-spin"></i> Filtrando...') {
    if (!boton) {
        return () => {};
    }

    const contenidoOriginal = boton.innerHTML;
    boton.disabled = true;
    boton.innerHTML = textoCarga;

    return () => {
        boton.disabled = false;
        boton.innerHTML = contenidoOriginal;
    };
}