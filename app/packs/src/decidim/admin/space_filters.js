// Participa: shows / hides the extra filters row (creation date and author)
// in the participatory processes and assemblies admin lists.
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
      toggle.querySelector("svg")?.classList.toggle("rotate-180", !expanded);
    });
  });
};

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initSpaceFilters);
} else {
  initSpaceFilters();
}
