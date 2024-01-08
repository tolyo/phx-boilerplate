import { generateRouteConfig, initRouter } from "./utils/router.js";

import "./utils/components.js";
import FormController from "./utils/form-controller.js";

// Boostrap AlpineJS
window.Alpine.start();
window.EventBus = new EventTarget();

document.addEventListener("DOMContentLoaded", () => {
  // Clean up an init all form controllers
  if (window.FormControllers) {
    window.FormControllers.forEach((i) => i.destroy());
  }
  window.FormControllers = [];
  document
    .querySelectorAll("form")
    .forEach((form) => window.FormControllers.push(new FormController(form)));
});

window.crudRoutes.forEach((r) =>
  generateRouteConfig(r.name).forEach((v) => window.routes.push(v)),
);

/**
 * Enable router if `ui-view` tag is present. Otherwise, fallback to default
 * browser routing/navigation.
 */
if (document.querySelector("ui-view") !== null) {
  initRouter(window.routes);
}
