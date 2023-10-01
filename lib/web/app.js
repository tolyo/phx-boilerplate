import { initRouter } from "./utils/router.js";
import getProductRoutes from "./product/product.js";

// Boostrap AlpineJS
window.Alpine.start();

/**
 * @type {import("./utils/router.js").RouteConfig[]}
 */
const routes = [{ name: "home", url: "/", serverPath: "/_home" }].concat(
  getProductRoutes(),
);

/**
 * Enable router if `ui-view` tag is present. Otherwise fallback to default
 * browser routing/navigation.
 */
if (document.querySelector("ui-view") !== null) {
  initRouter(routes);
}
