(() => {
  const toggle = document.querySelector('.menu-toggle');
  const nav = document.querySelector('.primary-nav');
  if (toggle && nav) {
    toggle.addEventListener('click', () => {
      const open = nav.classList.toggle('open');
      toggle.setAttribute('aria-expanded', String(open));
    });
    nav.addEventListener('click', event => {
      if (event.target.closest('a')) {
        nav.classList.remove('open');
        toggle.setAttribute('aria-expanded', 'false');
      }
    });
  }
  const current = location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.primary-nav a').forEach(link => {
    const target = new URL(link.href, location.href).pathname.split('/').pop();
    if (target === current) link.setAttribute('aria-current', 'page');
  });
  document.querySelectorAll('[data-year]').forEach(el => el.textContent = new Date().getFullYear());
  document.querySelectorAll('[data-no-date]').forEach(el => {
    el.textContent = 'Official date to be announced';
  });
})();