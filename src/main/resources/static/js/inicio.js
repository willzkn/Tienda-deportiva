(() => {
  document.addEventListener('DOMContentLoaded', () => {
    const slides = document.querySelectorAll(".slides img");
    const carousel = document.querySelector(".carousel");
    const btnPrev = document.querySelector(".prev");
    const btnNext = document.querySelector(".next");
    if (slides.length) {
      let index = 0;
      let timerId = null;
      const intervalMs = 5000;
      function render() {
        slides.forEach((img, i) => img.style.display = (i === index) ? "block" : "none");
      }
      function move(step) {
        index = (index + step + slides.length) % slides.length;
        render();
      }
      function startAutoplay() {
        stopAutoplay();
        timerId = setInterval(() => move(1), intervalMs);
      }
      function stopAutoplay() {
        if (timerId) clearInterval(timerId);
        timerId = null;
      }
      if (btnPrev) btnPrev.addEventListener('click', () => { 
        move(-1); 
        startAutoplay(); // Reinicia autoplay al usar flechas
      });
      if (btnNext) btnNext.addEventListener('click', () => { 
        move(1); 
        startAutoplay(); 
      });
      if (carousel) {
        carousel.addEventListener('mouseenter', stopAutoplay);
        carousel.addEventListener('mouseleave', startAutoplay);
      }
      document.addEventListener('keydown', (e) => {
        if (e.key === "ArrowLeft") move(-1);
        if (e.key === "ArrowRight") move(1);
      });
      render();
      startAutoplay();
    }
  });
})();