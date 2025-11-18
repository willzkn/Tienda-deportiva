document.getElementById("formLogin").addEventListener("submit", function(e) {
  e.preventDefault();

  const user = document.getElementById("usuario").value.trim();
  const pass = document.getElementById("clave").value.trim();
  const submitBtn = e.target.querySelector('button[type="submit"]');

  if (user && pass) {
    // Mostrar loading
    submitBtn.classList.add('btn-loading');
    
    // Simular validación
    setTimeout(() => {
      const ctx = window.appContext || '';
      if (typeof toast !== 'undefined') {
        toast.success('Inicio de sesión exitoso');
      }
      setTimeout(() => {
        window.location.href = ctx + "/inicio";
      }, 500);
    }, 1000);
  } else {
    if (typeof toast !== 'undefined') {
      toast.error('Por favor ingrese usuario y contraseña');
    } else {
      alert("Por favor ingrese usuario y contraseña");
    }
    // Shake animation
    e.target.classList.add('shake');
    setTimeout(() => e.target.classList.remove('shake'), 500);
  }
});