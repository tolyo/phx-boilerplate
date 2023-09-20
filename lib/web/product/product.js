import { generateRouteConfig } from "../utils/router.js";

/**
 * Returns a list of product route configurations.
 *
 * @returns {import('../app.js').RouteConfig[]} An array of product route configurations.
 */
export default function getProductRoutes() {
  return generateRouteConfig("products");
}
