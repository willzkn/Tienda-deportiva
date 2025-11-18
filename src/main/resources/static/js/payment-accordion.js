// Script para manejar el acordeón de pago
document.addEventListener('DOMContentLoaded', function() {
    // Estado inicial
    let pasoActivo = 1;
    let pasosCompletados = [];
    
    // Datos del formulario
    const datosFormulario = {
        nombre: '',
        email: '',
        direccion: '',
        ciudad: '',
        codigoPostal: '',
        numeroTarjeta: '',
        nombreTarjeta: '',
        fechaExpiracion: '',
        cvv: ''
    };

    // Función para verificar si un paso está completo
    function esPasoCompleto(paso) {
        switch(paso) {
            case 1:
                return datosFormulario.nombre && datosFormulario.email;
            case 2:
                return datosFormulario.direccion && datosFormulario.ciudad && datosFormulario.codigoPostal;
            case 3:
                return datosFormulario.numeroTarjeta && datosFormulario.nombreTarjeta && datosFormulario.fechaExpiracion && datosFormulario.cvv;
            default:
                return false;
        }
    }

    // Función para manejar la finalización de un paso
    function manejarPasoCompleto(paso) {
        if (esPasoCompleto(paso) && !pasosCompletados.includes(paso)) {
            pasosCompletados.push(paso);
            if (paso < 3) {
                establecerPasoActivo(paso + 1);
            }
        }
    }

    // Función para establecer el paso activo
    function establecerPasoActivo(paso) {
        pasoActivo = paso;
        actualizarAcordeon();
    }

    // Función para manejar cambios en los inputs
    function manejarCambioInput(e) {
        const nombre = e.target.name;
        const valor = e.target.value;
        datosFormulario[nombre] = valor;
        
        // Actualizar botones de continuar
        actualizarBotonesContinuar();
    }

    // Función para actualizar los botones de continuar
    function actualizarBotonesContinuar() {
        document.querySelectorAll('.boton-continuar').forEach((btn, index) => {
            const paso = index + 1;
            if (esPasoCompleto(paso)) {
                btn.classList.remove('bg-gray-300', 'text-gray-500', 'cursor-not-allowed');
                btn.classList.add('bg-blue-500', 'hover:bg-blue-600', 'text-white', 'cursor-pointer');
                btn.disabled = false;
            } else {
                btn.classList.add('bg-gray-300', 'text-gray-500', 'cursor-not-allowed');
                btn.classList.remove('bg-blue-500', 'hover:bg-blue-600', 'text-white', 'cursor-pointer');
                btn.disabled = true;
            }
        });
    }

    // Función para actualizar el acordeón
    function actualizarAcordeon() {
        document.querySelectorAll('.seccion-acordeon').forEach((seccion, index) => {
            const paso = index + 1;
            const estaActivo = pasoActivo === paso;
            const estaCompleto = pasosCompletados.includes(paso);
            const puedeAbrir = paso === 1 || pasosCompletados.includes(paso - 1);
            
            // Actualizar cabecera del acordeón
            const cabecera = seccion.querySelector('.cabecera-acordeon');
            const contenido = seccion.querySelector('.contenido-acordeon');
            const icono = seccion.querySelector('.icono-paso');
            const chevron = seccion.querySelector('.icono-chevron');
            
            // Actualizar clases según el estado
            if (estaActivo) {
                cabecera.classList.add('bg-blue-50');
                contenido.classList.remove('hidden');
                chevron.classList.add('rotate-180');
            } else {
                cabecera.classList.remove('bg-blue-50');
                contenido.classList.add('hidden');
                chevron.classList.remove('rotate-180');
            }
            
            if (estaCompleto) {
                icono.innerHTML = '<i class="fas fa-check-circle text-white"></i>';
                icono.classList.add('bg-green-500');
                icono.classList.remove('bg-blue-500', 'bg-gray-300');
                seccion.querySelector('.estado-paso').textContent = 'Completado';
            } else if (estaActivo) {
                icono.classList.add('bg-blue-500');
                icono.classList.remove('bg-green-500', 'bg-gray-300');
                seccion.querySelector('.estado-paso').textContent = `Paso ${paso} de 3`;
            } else {
                icono.classList.add('bg-gray-300');
                icono.classList.remove('bg-green-500', 'bg-blue-500');
                seccion.querySelector('.estado-paso').textContent = `Paso ${paso} de 3`;
            }
            
            // Actualizar interactividad
            if (puedeAbrir) {
                cabecera.classList.add('hover:bg-gray-50', 'cursor-pointer');
                cabecera.classList.remove('cursor-not-allowed', 'opacity-60');
                cabecera.disabled = false;
            } else {
                cabecera.classList.remove('hover:bg-gray-50', 'cursor-pointer');
                cabecera.classList.add('cursor-not-allowed', 'opacity-60');
                cabecera.disabled = true;
            }
        });
    }

    // Inicializar eventos
    function inicializarEventos() {
        // Eventos para las cabeceras del acordeón
        document.querySelectorAll('.cabecera-acordeon').forEach((cabecera, index) => {
            const paso = index + 1;
            cabecera.addEventListener('click', function() {
                const puedeAbrir = paso === 1 || pasosCompletados.includes(paso - 1);
                if (puedeAbrir) {
                    establecerPasoActivo(pasoActivo === paso ? 0 : paso);
                }
            });
        });
        
        // Eventos para los inputs
        document.querySelectorAll('.formulario-pago input').forEach(input => {
            input.addEventListener('input', manejarCambioInput);
        });
        
        // Eventos para los botones de continuar
        document.querySelectorAll('.boton-continuar').forEach((btn, index) => {
            const paso = index + 1;
            btn.addEventListener('click', function() {
                manejarPasoCompleto(paso);
            });
        });
        
        // Evento para el formulario
        const formulario = document.querySelector('.formulario-pago');
        if (formulario) {
            formulario.addEventListener('submit', function(e) {
                e.preventDefault();
                if (pasosCompletados.length === 3) {
                    alert('¡Pago procesado exitosamente! 🎉');
                }
            });
        }
    }

    // Inicializar el acordeón
    function inicializar() {
        actualizarAcordeon();
        inicializarEventos();
    }

    // Iniciar cuando el DOM esté listo
    inicializar();
});