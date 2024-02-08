import { initRouterWithBase } from "../../../utils/router.js";

function isWebview() {
  return /webview|wv|ip((?!.*Safari)|(?=.*like Safari))/i.test(
    window.navigator.userAgent,
  );
}

/**
 * Enable router if `ui-view` tag is present. Otherwise, fallback to default
 * browser routing/navigation.
 */
if (document.querySelector("ui-view") !== null) {
  initRouterWithBase("http://10.0.2.2:4000", [
    {
      name: "home",
      url: "/",
      serverPath: "/mobile/_home",
    },
  ]);
}

window.app = new Framework7();
