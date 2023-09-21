/**
 * Fetches content and renders it into the DOM for a given state definition.
 *
 * @param {import("@uirouter/core").StateDeclaration} stateDef - The state definition object.
 * @returns {Promise<void>} A promise that resolves when the content is fetched and rendered.
 */
export function fetchIntoDom(stateDef) {
  /**
   * @type {import("@uirouter/core").StateObject}
   */
  const state = stateDef.$$state();

  /**
   * The parent element's ID where the content will be rendered.
   * Defaults to "root" if the state has no parent.
   *
   * @type {string}
   */
  const parentId = state.parent.name || "root";

  /**
   * The actual parameters being passed to view
   *
   * @type {import("@uirouter/core").StateParams}
   */
  const stateParams = window.router.globals.params;

  const pathSegments = Object.keys(stateParams)
    .filter(
      (key) =>
        key !== "server_path" &&
        stateParams[key] !== null &&
        stateParams[key] !== undefined,
    )
    .map((key) => `/${stateParams[key]}`)
    .join("");

  /**
   * The parent element where the content will be rendered.
   *
   * @type {HTMLElement}
   */
  const parent = document.getElementById(parentId);

  /**
   * The server url that should return a new template
   *
   * @type {string}
   */
  const url = window.router.globals.params
    ? stateDef.params.server_path + pathSegments
    : stateDef.url;

  /**
   * Fetches content from the server and renders it into the DOM.
   *
   * @type {Promise<Response>}
   */
  return fetch(url)
    .then((response) => response.text())
    .then((text) => {
      parent.innerHTML = text;
    });
}

/**
 * Clears the rendered content from the DOM for a given state definition.
 *
 * @param {import("@uirouter/core").StateDeclaration} stateDef - The state definition object.
 */
export function clearRenderedDom(stateDef) {
  /**
   * @type {import("@uirouter/core").StateObject}
   */
  const state = stateDef.$$state();

  /**
   * The parent element's ID where the content was rendered.
   * Defaults to "root" if the state has no parent.
   *
   * @type {string}
   */
  const parentId = state.parent.name || "root";

  /**
   * The parent element from which to clear the content.
   *
   * @type {HTMLElement}
   */
  const parent = document.getElementById(parentId);

  // Clear the content by setting innerHTML to an empty string.
  parent.innerHTML = "";
}

/**
 * Generate an array of default CRUD controller route configurations for a given route name.
 *
 * @param {string} routeName - The base name of the route.
 * @returns {import('../app.js').RouteConfig[]} An array of default route configurations.
 */
export function generateRouteConfig(routeName) {
  const baseServerPath = `/_${routeName}`;

  const routes = [
    { name: routeName, url: `/${routeName}`, serverPath: baseServerPath },
    {
      name: `${routeName}:get`,
      url: `/${routeName}/{id}`,
      serverPath: baseServerPath,
    },
    {
      name: `${routeName}:new`,
      url: `/${routeName}/new`,
      serverPath: `${baseServerPath}/new`,
    },
    {
      name: `${routeName}:edit`,
      url: `/${routeName}/edit/{id}`,
      serverPath: `${baseServerPath}/edit`,
    },
  ];

  return routes;
}
