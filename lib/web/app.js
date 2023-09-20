import { clearRenderedDom, fetchIntoDom } from "./utils/router.js";
import getProductRoutes from "./product/product.js";

/**
 * @typedef {Object} RouteConfig
 * @property {string} name - The name of the state.
 * @property {string} url - The URL associated with the state.
 * @property {string} serverPath - The server path associated with the state.
 */

/**
 * @type {import("@uirouter/core")}
 */
const uiRouter = window["@uirouter/core"];

const router = new uiRouter.UIRouter();
router.plugin(uiRouter.pushStateLocationPlugin);
router.plugin(uiRouter.servicesPlugin);

// This transition hook renders each active states' html property
router.transitionService.onSuccess(
  {},
  /**
   * @param {import("@uirouter/core").Transition} trans
   */
  (trans) => {
    trans.exiting().forEach((stateDef) => clearRenderedDom(stateDef));
    trans.entering().forEach((stateDef) => fetchIntoDom(stateDef));
  },
);

// Route definitions
[{ name: "home", url: "/", serverPath: "/_home" }]
  .concat(getProductRoutes())
  .forEach(
    /**
     * @param {RouteConfig} config
     */
    (config) => {
      router.stateRegistry.register({
        name: config.name,
        url: config.url,
        params: { server_path: config.serverPath },
      });
    },
  );

router.urlService.rules.initial({ state: "home" });
router.urlService.rules.otherwise({ state: "home" });
router.urlService.listen();
router.urlService.sync();

// Setup-globals
window.router = router;
window.stateService = router.stateService;

// Boostrap AlpineJS
window.Alpine.start();
