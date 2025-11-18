// Utilidades cortas
const $ = (id)=>document.getElementById(id);

function validarPeru(){
  const ruc = $("ruc").value.trim();
  const tel = $("telefono").value.trim();
  const okRuc = /^\d{11}$/.test(ruc);
  const okTel = /^\d{9}$/.test(tel);
  return okRuc && okTel;
}

// Envío de la maqueta
$("formProveedor").addEventListener("submit", (e)=>{
  e.preventDefault();
  const submitBtn = e.target.querySelector('button[type="submit"]');

  // Obligatorios
  const requiredIds = ["razon","ruc","contacto","correo","telefono","departamento","distrito"];
  for(const id of requiredIds){
    if(!$(id).value.trim()){
      if (typeof toast !== 'undefined') {
        toast.error("Por favor completa todos los campos obligatorios.");
      } else {
        alert("Por favor completa todos los campos obligatorios.");
      }
      $(id).focus();
      $(id).parentElement.classList.add('error');
      return;
    } else {
      $(id).parentElement.classList.remove('error');
      $(id).parentElement.classList.add('success');
    }
  }
  if(!validarPeru()){
    if (typeof toast !== 'undefined') {
      toast.error("Revisa el RUC (11 dígitos) y el teléfono (9 dígitos).");
    } else {
      alert("Revisa el RUC (11 dígitos) y el teléfono (9 dígitos).");
    }
    return;
  }
  if(!$("acepto").checked){
    if (typeof toast !== 'undefined') {
      toast.warning("Debes aceptar los términos.");
    } else {
      alert("Debes aceptar los términos.");
    }
    return;
  }
  
  // Mostrar loading
  submitBtn.classList.add('btn-loading');

  // Construir solicitud (solo visual)
  const solicitud = {
    razon: $("razon").value.trim(),
    ruc: $("ruc").value.trim(),
    contacto: $("contacto").value.trim(),
    correo: $("correo").value.trim(),
    telefono: $("telefono").value.trim(),
    departamento: $("departamento").value,
    distrito: $("distrito").value.trim(),
    fecha: new Date().toISOString()
  };

  const KEY = "supplierApplications";
  const lista = JSON.parse(localStorage.getItem(KEY) || "[]");
  lista.push(solicitud);
  localStorage.setItem(KEY, JSON.stringify(lista));

  setTimeout(() => {
    submitBtn.classList.remove('btn-loading');
    if (typeof toast !== 'undefined') {
      toast.success("Solicitud enviada. Nuestro equipo revisará tu postulación.");
    } else {
      alert("Solicitud enviada. Nuestro equipo revisará tu postulación (maqueta).");
    }
    // Flujo del curso: volver al login para seguir con main → resto de páginas
    const ctx = window.appContext || '';
    setTimeout(() => {
      window.location.href = ctx + "/login";
    }, 1500);
  }, 1000);
});

// Cancelar
$("btnCancelar").addEventListener("click", ()=>{
  const ctx = window.appContext || '';
  window.location.href = ctx + "/login";
});