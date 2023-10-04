import { initRouter } from "./utils/router.js";
import getProductRoutes from "./product/product.js";
import "./utils/components.js";
import FormController from "./utils/form-controller.js";

// Boostrap AlpineJS
window.Alpine.start();
window.EventBus = new EventTarget();

document.querySelectorAll("form").forEach((form) => new FormController(form));

/**
 * @type {import("./utils/router.js").RouteConfig[]}
 */
const routes = [
  {
    name: "home",
    url: "/",
    serverPath: "/_home",
  },

  {
    name: "home.subview",
    url: "/",
    serverPath: "/_subview",
  },
].concat(getProductRoutes());

/**
 * Enable router if `ui-view` tag is present. Otherwise fallback to default
 * browser routing/navigation.
 */
if (document.querySelector("ui-view") !== null) {
  initRouter(routes);
}
