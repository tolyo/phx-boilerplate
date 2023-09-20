import { clearRenderedDom, fetchIntoDom } from "./utils/router.js";

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

// @ts-ignore
window.router = router;
// @ts-ignore
window.stateService = router.stateService;
router.stateRegistry.register({
  name: "home",
  url: "/",
  params: { server_path: "/_home" },
});
router.stateRegistry.register({ name: "state1.nest1", url: "/nest1" });
router.stateRegistry.register({
  name: "products",
  url: "/products",
  params: { server_path: "/_products" },
});
router.stateRegistry.register({
  name: "products:new",
  url: "/products/new",
  params: { server_path: "/_products/new" },
});
router.stateRegistry.register({
  name: "products:get",
  url: "/products/{id}",
  params: { server_path: "/_products" },
});
router.stateRegistry.register({
  name: "products:edit",
  url: "/products/edit/{id}",
  params: { server_path: "/_products/edit" },
});

router.urlService.rules.initial({ state: "home" });
router.urlService.rules.otherwise({ state: "home" });
router.urlService.listen();
router.urlService.sync();

window.Alpine.start();
