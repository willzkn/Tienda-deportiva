document.addEventListener('DOMContentLoaded', initCarousel);

function initCarousel() {
    const slides = document.querySelectorAll('.slides img');
    if (!slides.length) {
        return;
    }

    const carousel = document.querySelector('.carousel');
    const btnPrev = document.querySelector('.prev');
    const btnNext = document.querySelector('.next');
    const intervalMs = 5000;
    let index = 0;
    let timerId = null;

    const render = () => {
        slides.forEach((img, i) => {
            img.style.display = i === index ? 'block' : 'none';
        });
    };

    const move = (step) => {
        index = (index + step + slides.length) % slides.length;
        render();
    };

    const startAutoplay = () => {
        stopAutoplay();
        timerId = setInterval(() => move(1), intervalMs);
    };

    const stopAutoplay = () => {
        if (timerId) {
            clearInterval(timerId);
        }
        timerId = null;
    };

    btnPrev?.addEventListener('click', () => {
        move(-1);
        startAutoplay();
    });

    btnNext?.addEventListener('click', () => {
        move(1);
        startAutoplay();
    });

    carousel?.addEventListener('mouseenter', stopAutoplay);
    carousel?.addEventListener('mouseleave', startAutoplay);

    document.addEventListener('keydown', (event) => {
        if (event.key === 'ArrowLeft') move(-1);
        if (event.key === 'ArrowRight') move(1);
    });

    render();
    startAutoplay();
}