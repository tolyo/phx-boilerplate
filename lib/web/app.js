/**
 * @type {import("@uirouter/core")}
 */
const uiRouter = window["@uirouter/core"];

const router = new uiRouter.UIRouter();
router.plugin(uiRouter.pushStateLocationPlugin);
router.plugin(uiRouter.servicesPlugin);

/**
 * @param {import("@uirouter/core").StateDeclaration} stateDef
 */
function fetchIntoDom(stateDef) {
  const state = stateDef.$$state();
  const parentId = state.parent.name || "root";
  const stateParams = router.globals.params;

  const pathSegments = Object.keys(stateParams)
    .filter(
      (key) =>
        key !== "server_path" &&
        stateParams[key] !== null &&
        stateParams[key] !== undefined,
    )
    .map((key) => `/${stateParams[key]}`)
    .join("");

  const parent = document.getElementById(parentId);
  return fetch(
    stateDef.params.server_path
      ? stateDef.params.server_path + pathSegments
      : stateDef.url,
  )
    .then((response) => response.text())
    .then((text) => {
      parent.innerHTML = text;
    });
}

/**
 * @param {import("@uirouter/core").StateDeclaration} stateDef
 */
function clearRenderedDom(stateDef) {
  const state = stateDef.$$state();
  const parentId = state.parent.name || "root";
  const parent = document.getElementById(parentId);
  parent.innerHTML = "";
}

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
