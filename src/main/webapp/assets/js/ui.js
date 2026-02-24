// ===== Card Mouse-Follow Glow Effect =====
document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll('.card').forEach(card => {
        card.addEventListener('mousemove', (e) => {
            const rect = card.getBoundingClientRect();
            const x = ((e.clientX - rect.left) / rect.width) * 100;
            const y = ((e.clientY - rect.top) / rect.height) * 100;
            card.style.setProperty('--mouse-x', x + '%');
            card.style.setProperty('--mouse-y', y + '%');
        });

        card.addEventListener('mouseleave', () => {
            card.style.setProperty('--mouse-x', '50%');
            card.style.setProperty('--mouse-y', '50%');
        });
    });

    // ===== Balance Counter Animation =====
    const balanceEl = document.getElementById('balance-counter');
    if (balanceEl) {
        const finalValue = parseFloat(balanceEl.textContent.replace(/[^0-9.]/g, '')) || 0;
        const duration = 1200;
        const startTime = performance.now();

        function animateCounter(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const eased = 1 - Math.pow(1 - progress, 3);
            const currentValue = (finalValue * eased).toFixed(2);
            balanceEl.textContent = Number(currentValue).toLocaleString('en-IN', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            });

            if (progress < 1) {
                requestAnimationFrame(animateCounter);
            }
        }

        balanceEl.textContent = '0.00';
        requestAnimationFrame(animateCounter);
    }

    // ===== Staggered Card Animation =====
    document.querySelectorAll('.card-animate').forEach((card, index) => {
        card.style.animationDelay = (index * 0.08) + 's';
    });

    // ===== Init Lucide Icons =====
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }

    // ===== URL Param Toast Notifications for transaction feedback =====
    const params = new URLSearchParams(window.location.search);
    const errorMsg = params.get('error');
    if (errorMsg) {
        showToast(decodeURIComponent(errorMsg.replace(/\+/g, ' ')), 'error');
        // Clean URL
        window.history.replaceState({}, '', window.location.pathname);
    }
});

// ===== Disable Submit Button on Submit =====
document.addEventListener("submit", (e) => {
    const btn = e.target.querySelector("button[type='submit']");
    if (btn) {
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner"></span> Processing...';
    }
});

// ===== Toast Notification System =====
function showToast(message, type) {
    type = type || 'info';
    let container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = 'toast toast-' + type;
    toast.textContent = message;
    container.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'toastOut .3s ease forwards';
        setTimeout(() => toast.remove(), 300);
    }, 4000);
}

// ===== Theme Persistence =====
(function () {
    const root = document.documentElement;
    const saved = localStorage.getItem("theme");
    if (saved) {
        root.setAttribute("data-theme", saved);
    }

    window.toggleTheme = function () {
        const current = root.getAttribute("data-theme");
        const next = current === "light" ? "" : "light";
        if (next) {
            root.setAttribute("data-theme", next);
            localStorage.setItem("theme", next);
        } else {
            root.removeAttribute("data-theme");
            localStorage.removeItem("theme");
        }
    };
})();