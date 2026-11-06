const initSpaceFilters = () => {
  document.querySelectorAll("[data-space-filters-toggle]").forEach((toggle) => {
    const panel = document.getElementById(toggle.getAttribute("aria-controls"));
    if (!panel) {
      return;
    }

    toggle.addEventListener("click", () => {
      const expanded = toggle.getAttribute("aria-expanded") === "true";
      toggle.setAttribute("aria-expanded", String(!expanded));
      panel.hidden = expanded;
    });
  });
};

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initSpaceFilters);
} else {
  initSpaceFilters();
}
