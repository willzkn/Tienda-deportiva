document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('formProveedor');
    form?.addEventListener('submit', () => form.submit());

    const btnCancelar = document.getElementById('btnCancelar');
    btnCancelar?.addEventListener('click', () => {
        const ctx = window.appContext || '';
        window.location.href = `${ctx}/login`;
    });
});