/**
 * Notion Widget Runtime Bridge
 * - Reads ?theme=dark|light query parameter or localStorage preference
 * - Adds a subtle floating theme toggle (☀️/🌙) when running inside Notion /embed or browser
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

  window.addEventListener("DOMContentLoaded", function () {
    if (window.location.protocol === "file:") return;
    const btn = document.createElement("button");
    btn.type = "button";
    btn.title = "Đổi giao diện Sáng / Tối (Notion Light/Dark)";
    btn.className =
      "fixed bottom-2.5 right-2.5 z-50 px-2 py-1 rounded-md text-xs border border-[var(--border)] bg-[var(--card)] text-[var(--muted-foreground)] hover:text-[var(--foreground)] shadow-sm opacity-60 hover:opacity-100 transition";
    function updateLabel() {
      const isDark =
        root.classList.contains("dark") ||
        (!root.classList.contains("light") &&
          window.matchMedia("(prefers-color-scheme: dark)").matches);
      btn.textContent = isDark ? "☀️ Light" : "🌙 Dark";
    }
    btn.addEventListener("click", function () {
      const isDark =
        root.classList.contains("dark") ||
        (!root.classList.contains("light") &&
          window.matchMedia("(prefers-color-scheme: dark)").matches);
      const next = isDark ? "light" : "dark";
      applyTheme(next);
      localStorage.setItem("notion-widget-theme", next);
      updateLabel();
    });
    updateLabel();
    document.body.appendChild(btn);
  });
})();
