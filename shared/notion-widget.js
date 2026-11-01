/**
 * Notion Widget Runtime Bridge
 * - Reads ?theme=dark|light query parameter or localStorage preference
 * - Does NOT inject any extra DOM button unless explicitly requested via ?toggle=1
 */
(function () {
  const params = new URLSearchParams(window.location.search);
  const urlTheme = params.get("theme");
  const savedTheme = localStorage.getItem("notion-widget-theme");
  const root = document.documentElement;

  function applyTheme(mode) {
    if (mode === "dark") {
      root.classList.add("dark");
      root.classList.remove("light");
    } else if (mode === "light") {
      root.classList.add("light");
      root.classList.remove("dark");
    }
  }

  if (urlTheme === "dark" || urlTheme === "light") {
    applyTheme(urlTheme);
  } else if (savedTheme === "dark" || savedTheme === "light") {
    applyTheme(savedTheme);
  }
})();
